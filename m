Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830Ab3LIQjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:39:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50720 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3LIQjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:39:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH 9/9] ARM: pxa27x: device tree support ICP DAS LP-8x4x
Date: Mon, 9 Dec 2013 17:39:27 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
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
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com> <1386602213.7152.180.camel@host5.omatika.ru> <1386604530.7152.184.camel@host5.omatika.ru>
In-Reply-To: <1386604530.7152.184.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312091739.27920.arnd@arndb.de>
X-Provags-ID: V02:K0:smbww4GNONyvlA9lgk+Ac0U8WII1Y0ZmBIHp3vYZVaX
 HnXOSh7YzohpBUYkCASkWv17z5s9TZJSl5f85NbcqZBhKhllSC
 fxB7D9MxmPcOdXFNFQ8xNGKptbhNOCyZmZI0sLK0kj4VWfj6jq
 URWuwJu/DPTa0AKh73Nv6f4Sf7qlZMZnHC0eBOpvzyBJRPuU4f
 U+5G2YRpkV5z2vt8YG+x0I5adIXcgAcX7RHa+2JsIcwsbNacdU
 mScXgbCEQssgOUl7NVoeisSsj25Yi+PKkOSQ5Fy6Q5XAYKv0qi
 k0PVbGATq9hl2bAcm2zPR0ZJAgrn+V0OGJxsC6CurkzNBqDFXx
 /bCrtAPhPz+nhmBHcuYg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 December 2013, Sergei Ianovich wrote:
> anovich wrote:
> > On Mon, 2013-12-09 at 02:47 +0100, Arnd Bergmann wrote:
> > > On Sunday 08 December 2013, Sergei Ianovich wrote:
> > > > +
> > > > +#ifdef CONFIG_PXA27x
> > > > +extern void __init pxa27x_dt_init_irq(void);
> > 
> > > > +static void __init pxa27x_init_early(void)
> > > > +{
> > > > +     pxa27x_skip_init();
> > > > +}
> > > 
> > > I would prefer not to have an init_early function at all, and instead
> > > check "if (of_have_populated_dt())" in pxa27x_init, or to split
> > > that function into two.
> 
> Although this is counterintuitive, it works. Since of_populate_dt() is
> not required for of_have_populated_dt() to return true, should we rename
> of_have_populated_dt() to of_have_dt()?

I don't think it's worth the change. The explanation for the current
terminoligy is that of_unflatten() populates the DT device_node structures
in the kernel from the FTD blob, while of_platform_populate populates the
platform_device infrastructure from the device nodes.

	Arnd
