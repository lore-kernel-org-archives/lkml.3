Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab3LPLrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:47:40 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:49664 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3LPLrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:47:37 -0500
Message-ID: <1387194450.13062.134.camel@host5.omatika.ru>
Subject: Re: [PATCH v2 03/16] ARM: dts: provide DMA config to pxamci
From: Sergei Ianovich <ynvich@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        DOCUMENTATION <linux-doc@vger.kernel.org>, linux-mmc@vger.kernel.org
Date: Mon, 16 Dec 2013 15:47:30 +0400
In-Reply-To: <52AECEB2.4070807@gmail.com>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
		 <1386901645-28895-1-git-send-email-ynvich@gmail.com>
		 <1386901645-28895-4-git-send-email-ynvich@gmail.com>
		 <201312142006.26979.arnd@arndb.de>
	 <1387049660.7152.317.camel@host5.omatika.ru> <52AECEB2.4070807@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-16 at 10:58 +0100, Daniel Mack wrote:
> On 12/14/2013 08:34 PM, Sergei Ianovich wrote:
> > On Sat, 2013-12-14 at 20:06 +0100, Arnd Bergmann wrote:
> 
> >> The patch looks ok in case we are merging your patches for 3.14
> >> and Daniel's patches later than that. If they end up in the
> >> same merge window however, we'd have to be care to resolve
> >> the obvious conflict in a proper way.
> > 
> > The most recently published Daniel's patch (Aug 2013) wraps
> > IORESOURCE_DMA handling on DT presence in a similar way,
> 
> Erm, no it doesn't. My patch uses dma_request_slave_channel_compat() in
> DT case, and that works fine with the current version of pdma, and
> there's no need to read the "dmas" properties directly.
> 
> If you want to provide a way to simply denote the dma channel numbers,
> without looking at the actual phandle, then yes, we could merge this
> patch first, but it would be effectively reverted a proper implementation.

Daniel is right. His patch doesn't need to read "dmas" directly. So my
patch won't need to change drivers/mmc/host/pxamci.c at all, if it is
applied after Daniel's one.

What are we going to do in this context?

