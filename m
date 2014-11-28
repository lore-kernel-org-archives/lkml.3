Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaK1LL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:11:57 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:61866 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaK1LLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:11:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, linux-samsung-soc@vger.kernel.org,
        lauraa@codeaurora.org, tony@atomide.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        loeliger@gmail.com, Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        linux-omap@vger.kernel.org, drake@endlessm.com
Subject: Re: [PATCH v9 0/7] Enable L2 cache support on Exynos4210/4x12 SoCs
Date: Fri, 28 Nov 2014 12:11:38 +0100
Message-ID: <3059840.P4aX5Il9dy@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54783899.2060604@samsung.com>
References: <1416224909-4290-1-git-send-email-m.szyprowski@samsung.com> <20141127225100.GA3840@n2100.arm.linux.org.uk> <54783899.2060604@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3GUwLoeU3q7cLN5QyvDhKV1iO66/RxOmp5nfDUAiD2l
 s3E6WRCiTl4ClWycu8IEfSE9lLBxPWq8/pSOigTTEaBJyXcYvQ
 h9pTYSlt53DYh76Ws3NE8hEyZ3VpT/129L1yAJ6UpxHNDqi38M
 +gdOQX6JIV0lO3RGjzXg6tpCCZjhf5XnI9rNUZKH7amiqwdNik
 CY0qDKVS2JETvuQsfbCPro2HV49nOSohDyUKYj6dP46WXT4k7R
 S2/vF+ZNb7XPPMcNLF8ABJdDDAXfx6RB+ijOupevBwV+SREoak
 DMXKpd4HVimOnuwvCM7/GIFX22yMzI2VGQmrzWKiAr8lVd/tRi
 3+RL6sQL3VyuAx33eYyo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 November 2014 09:55:53 Marek Szyprowski wrote:
> On 2014-11-27 23:51, Russell King - ARM Linux wrote:
> > On Mon, Nov 17, 2014 at 12:48:22PM +0100, Marek Szyprowski wrote:
> >>
> >> Changes in this version tested on Exynos4412-based TRATS2 and OdroidU3+
> >> boards (both with secure firmware). There should be no functional change
> >> for Exynos boards running without secure firmware. I do not have access
> >> to affected non-Exynos boards, so I could not test on them.
> > So, I applied this series, and now I get a conflicts between my tree and
> > arm-soc for:
> >
> > arch/arm/mach-exynos/firmware.c
> > arch/arm/mach-exynos/sleep.S
> >
> > So, I'm going to un-stage the exynos bits, and we'll have to work out
> > some way to handle those.

Ok

> I've already pointed that those patches depend on other previously merged to
> exynos and arm-soc trees, but both Arnd and Kukjin said that those patch 
> series
> should go via your kernel tree:
> 
> https://lkml.org/lkml/2014/11/15/158
> 
> That's why in v9 I rebased patches once again onto vanilla v3.18-rc4 and 
> uploaded
> to your patch tracker. I see the following two possibilities to get them 
> merged:
> 
> 1. Merge patches to rmk tree and resolve the merge conflict. The 
> conflict IS quite
> easy to resolve - both trees, arm-soc and rmk only adds some code and 
> the goal is
> simply to have both chunks added.
> 
> 2. Merge the previous version (v8 from the above link) to arm-soc tree, 
> where it
> applies cleanly on for-next, preferably with Russell's Acked-by.
> 
> Arnd, Russell: which approach do you prefer? How can I help to get it 
> merged?

I'm fine with it either way. Russell, if you like you can merge
http://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung v3.19-next/pm-samsung-2
into your tree and resolve the conflict on your end, we have a stable
copy of that branch queued in next/soc.

If you prefer v8 to go through arm-soc, that's fine with me too, or
we could share a branch with v9 of Marek's series and have that merged
into arm-soc/next/soc to resolve the conflict.

	arnd
