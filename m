Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab3IPPyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:54:13 -0400
Received: from smtprelay0126.hostedemail.com ([216.40.44.126]:53582 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750998Ab3IPPyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:54:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2689:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3872:3873:3874:4250:4321:5007:7514:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: alarm22_7baf29a70a62b
X-Filterd-Recvd-Size: 2591
Message-ID: <1379346848.1934.13.camel@joe-AO722>
Subject: Re: [PATCH] gpu: host1x: use %pa to print dma_addr_t
From: Joe Perches <joe@perches.com>
To: Olof Johansson <olof@lixom.net>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Terje =?ISO-8859-1?Q?Bergstr=F6m?= <tbergstrom@nvidia.com>,
        dri-devel@lists.freedesktop.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 16 Sep 2013 08:54:08 -0700
In-Reply-To: <CAOesGMjUeyKDtNU+zVpPYWyQX8ESoUhqaHXLuW5jJ=u2ggEb5A@mail.gmail.com>
References: <1378960909-15773-1-git-send-email-olof@lixom.net>
	 <20130916151716.GA5613@ulmo>
	 <CAOesGMjUeyKDtNU+zVpPYWyQX8ESoUhqaHXLuW5jJ=u2ggEb5A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 08:46 -0700, Olof Johansson wrote:
> On Mon, Sep 16, 2013 at 8:17 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Wed, Sep 11, 2013 at 09:41:49PM -0700, Olof Johansson wrote:
> >> This removes two warnings where dma_addr_t variables were printed using
> >> %x when built with CONFIG_ARM_LPAE=y, thus having 64-bit dma_addr_t:
> >>
> >>   drivers/gpu/host1x/hw/cdma_hw.c:57:3: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t'
> >>   drivers/gpu/host1x/hw/debug_hw.c:175:10: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'dma_addr_t'
> >
> > Hi Olof,
> >
> > I can't reproduce this. Does this perhaps depend on some other patch?
> > When I enable LPAE I do see similar warnings in drivers/iommu/tegra-*.c
> > and those can indeed be fixed using an equivalent patch.
> 
> You need to enable LPAE on a platform that also selects
> ARCH_DMA_ADDR_T_64BIT, I don't think tegra does. If you do it with
> multi_v7_defconfig you'll see them.
> 
> However, see discussion on another of the emails in the series; I'll
> have to introduce a new format specifier instead.

Or not.

I don't know whether or not the dma_addr_t really needs a
fixed 18 byte output length for 64 bit uses.

I think always using a cast for dma_addr_t addresses like:

	printk("dma_addr_t: %#llx\n", (u64)addr);

would probably work just fine.


