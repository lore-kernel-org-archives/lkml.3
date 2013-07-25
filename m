Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab3GYUF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 16:05:56 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:34099 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab3GYUFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:05:55 -0400
Date: Thu, 25 Jul 2013 22:05:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject: Re: Ugly patches for stolen reservation
Message-ID: <20130725200551.GA16719@gmail.com>
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> Patch 2/2 has the description, but suffice it to say I'm 
> not really pleased with this, though it does solve a 
> problem we have.  On some machines, we get MMIO space 
> allocated on top of this hidden memory, which can cause 
> problems.  I'm not sure if there are similar problems for 
> other hunks of the address space; if so it's possible 
> this could be made more general (though the bits for 
> looking up the address of this region are definitely 
> Intel graphics specific).

It looks pretty hardware specific. Discovering it the hard 
way and marking it e820 reserved in an early quirk is what 
the firmware should have done to begin with - and I doubt 
the kernel could do anything significantly cleaner.

How does Windows manage to not crash? By luckily never 
allocating PCI resources on top of the RAM? Or does it have 
a quirk?

> Chris has some patches on top to add a new E820 type so 
> we can look up the region later, which removes some 
> redundant code in the i915 driver at least.
> 
> Any comments?  I assume no one likes this, but maybe it's 
> just another early quirk we'll have to live with...

No strong feelings against it - my only suggestion would be 
to make this more visible - right now it's added as e820 
reserved which hides amongst other areas already marked 
reserved - would a low-key printk() of the range added make 
it more apparent that a kernel quirk activated here?

Just so that people know that it came from the kernel, not 
the firmware.

But in any case:

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
