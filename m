Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaEWQSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:18:01 -0400
Received: from helium.waldemar-brodkorb.de ([89.238.66.15]:59381 "EHLO
	helium.waldemar-brodkorb.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162AbaEWQSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:18:00 -0400
Date: Fri, 23 May 2014 18:17:57 +0200
From: Waldemar Brodkorb <wbx@openadk.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>, Shawn Guo <shawn.guo@linaro.org>,
        Rabeeh Khoury <rabeeh@solid-run.com>, linux-kernel@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: oops on cubox-i (v3.15-rc4)
Message-ID: <20140523161757.GI618@waldemar-brodkorb.de>
References: <20140509144438.GW14063@waldemar-brodkorb.de>
 <20140511002506.GN12708@titan.lakedaemon.net>
 <20140523101751.GH618@waldemar-brodkorb.de>
 <20140523143845.GD8664@titan.lakedaemon.net>
 <20140523154453.GY3693@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140523154453.GY3693@n2100.arm.linux.org.uk>
X-Operating-System: Linux 3.2.0-4-amd64 x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,
Russell King - ARM Linux wrote,

> > Can you get an oops from when it's on ext4?  It looks like this is going
> > through fuse which opens a whole can of unknown worms.
> 
> Waldemar mentioned ext4.
> 
> I don't think there's anything specific about it to the Cubox-i, and I'd
> also suggest that it's got nothing to do with ARM either - the iMX6 are
> PIPT data caches so there can't be any issues with D-cache aliasing with
> fuse.
> 
> It must be a bug in generic code.

I think this, too. I observed a crash in a similar configuration
with my Mikrotik RB532 (mips32). I just couldn't get a kernel Oops yet,
because I fighted against some PCI and serial output problems on
this device.
http://www.linux-mips.org/archives/linux-mips/2014-05/msg00124.html
http://www.linux-mips.org/archives/linux-mips/2014-05/msg00074.html
May be I can get an oops on Monday.
 
> > > > > Booting Linux on physical CPU 0x0
> > > > > Linux version 3.15.0-rc4 (wbx@kop-brodkorbw) (gcc version 4.8.2 (GCC) ) #1 SMP Fri May 9 12:58:45 CEST 2014
> > > > > CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7), cr=10c53c7d
> > > > > CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
> > > > > Machine model: SolidRun Cubox-i Dual/Quad
> > > > > Truncating RAM at 10000000-4fffffff to -3f7fffff (vmalloc region overlap).
> 
> Also worth noting that 1/4 of the RAM is not used because highmem is not
> enabled.  Also L2 cache is disabled (so it's running slower than it
> should...)

Thanks for the hint. I thought I only need HIGHMEM for cubox-i4pro
with 2 GB. Will enable it for my cubox-i2ultra.
 
best regards
 Waldemar
