Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab3GYURD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 16:17:03 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:33476 "HELO
	oproxy5.bluehost.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1757029Ab3GYURA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:17:00 -0400
Date: Thu, 25 Jul 2013 13:16:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject: Re: Ugly patches for stolen reservation
Message-ID: <20130725131648.561cc63c@jbarnes-desktop>
In-Reply-To: <20130725200551.GA16719@gmail.com>
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org>
	<20130725200551.GA16719@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013 22:05:51 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > Patch 2/2 has the description, but suffice it to say I'm 
> > not really pleased with this, though it does solve a 
> > problem we have.  On some machines, we get MMIO space 
> > allocated on top of this hidden memory, which can cause 
> > problems.  I'm not sure if there are similar problems for 
> > other hunks of the address space; if so it's possible 
> > this could be made more general (though the bits for 
> > looking up the address of this region are definitely 
> > Intel graphics specific).
> 
> It looks pretty hardware specific. Discovering it the hard 
> way and marking it e820 reserved in an early quirk is what 
> the firmware should have done to begin with - and I doubt 
> the kernel could do anything significantly cleaner.
> 
> How does Windows manage to not crash? By luckily never 
> allocating PCI resources on top of the RAM? Or does it have 
> a quirk?

Pretty sure Windows doesn't allocate MMIO space the same way we do, so
doesn't run into this on platforms where it's not E820_RESERVED.  On
top of that, BIOS vendors probably just move things around until
Windows boots and the device manager doesn't have any dreaded "yellow
bang" icons that would prevent them from getting their "designed for
windows" sticker.

> > Chris has some patches on top to add a new E820 type so 
> > we can look up the region later, which removes some 
> > redundant code in the i915 driver at least.
> > 
> > Any comments?  I assume no one likes this, but maybe it's 
> > just another early quirk we'll have to live with...
> 
> No strong feelings against it - my only suggestion would be 
> to make this more visible - right now it's added as e820 
> reserved which hides amongst other areas already marked 
> reserved - would a low-key printk() of the range added make 
> it more apparent that a kernel quirk activated here?

Sounds good, I think Chris's patches should satisfy there.  They make
it a new E820 type so it's clear in /proc/iomem too.

> 
> Just so that people know that it came from the kernel, not 
> the firmware.
> 
> But in any case:
> 
> Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
