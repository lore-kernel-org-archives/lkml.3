Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783Ab3LIPzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:55:38 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:53648 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457Ab3LIPzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:55:36 -0500
Message-ID: <1386604530.7152.184.camel@host5.omatika.ru>
Subject: Re: [PATCH 9/9] ARM: pxa27x: device tree support ICP DAS LP-8x4x
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Date: Mon, 09 Dec 2013 19:55:30 +0400
In-Reply-To: <1386602213.7152.180.camel@host5.omatika.ru>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com>
	 <1386543229-1542-1-git-send-email-ynvich@gmail.com>
	 <1386543229-1542-10-git-send-email-ynvich@gmail.com>
	 <201312090247.24978.arnd@arndb.de>
	 <1386602213.7152.180.camel@host5.omatika.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 19:16 +0400, Sergei Ianovich wrote:
> On Mon, 2013-12-09 at 02:47 +0100, Arnd Bergmann wrote:
> > On Sunday 08 December 2013, Sergei Ianovich wrote:
> > > +
> > > +#ifdef CONFIG_PXA27x
> > > +extern void __init pxa27x_dt_init_irq(void);
> 
> > > +static void __init pxa27x_init_early(void)
> > > +{
> > > +     pxa27x_skip_init();
> > > +}
> > 
> > I would prefer not to have an init_early function at all, and instead
> > check "if (of_have_populated_dt())" in pxa27x_init, or to split
> > that function into two.

Although this is counterintuitive, it works. Since of_populate_dt() is
not required for of_have_populated_dt() to return true, should we rename
of_have_populated_dt() to of_have_dt()?

> Device tree is populated in init_machine. However, pxa27x_init is
> executed before via postcore_initcall. The only chance to run before is
> to use init_early. What's wrong with this function?

I was wrong.

