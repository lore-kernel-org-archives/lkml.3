Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936103Ab3DILao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:30:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55073 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936026Ab3DILak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:30:40 -0400
Date: Tue, 9 Apr 2013 12:30:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: build warning after merge of the final tree
	(probably arm-soc tree related)
Message-ID: <20130409113007.GB14496@n2100.arm.linux.org.uk>
References: <20130409190900.97dcf3a70a9c0ad727b8bc4b@canb.auug.org.au> <201304091121.24372.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304091121.24372.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 11:21:24AM +0200, Arnd Bergmann wrote:
> On Tuesday 09 April 2013, Stephen Rothwell wrote:
> > After merging the final tree, today's linux-next build (arm defconfig)
> > produced these warnings:
> > 
> > arch/arm/mach-cns3xxx/Kconfig:2:warning: choice value used outside its choice group
> > arch/arm/mach-bcm2835/Kconfig:2:warning: choice value used outside its choice group
> > arch/arm/Kconfig:287:error: recursive dependency detected!
> > arch/arm/Kconfig:287:   choice <choice> contains symbol ARCH_CNS3XXX
> > arch/arm/Kconfig:366:   symbol ARCH_CNS3XXX depends on ARCH_MULTI_V6
> > arch/arm/Kconfig:933:   symbol ARCH_MULTI_V6 depends on ARCH_MULTIPLATFORM
> > arch/arm/Kconfig:292:   symbol ARCH_MULTIPLATFORM is part of choice <choice>
> 
> Thanks for the notification, I think git rerere picked up a wrong conflict resolution
> again that I did earlier. I'll fix it when I do the next pulls today.

The problem commit is: d4b63675f7202d2d7865aa19d83537e615ad3c50 which is
your next/multiplatform branch.  It re-introduces the ARCH_CNS3XXX
in arch/arm/Kconfig, which should've remained deleted.
