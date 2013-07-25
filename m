Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab3GYXRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:17:30 -0400
Received: from oproxy13-pub.unifiedlayer.com ([69.89.16.30]:50624 "HELO
	oproxy13-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757262Ab3GYXR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:17:29 -0400
Date: Thu, 25 Jul 2013 16:17:15 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject: Re: Ugly patches for stolen reservation
Message-ID: <20130725161715.50d85926@jbarnes-desktop>
In-Reply-To: <5304d042-6f8f-4754-9d19-df62662d19f4@email.android.com>
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org>
	<20130725200551.GA16719@gmail.com>
	<5304d042-6f8f-4754-9d19-df62662d19f4@email.android.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, it's ok if the boot loader writes to this memory, the worst
that'll happen is you'll see garbage on the screen.  If the boot loader
tries to do MMIO mapping on top it'll get into trouble... but why would
it do that?

Jesse

On Thu, 25 Jul 2013 15:42:25 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> So the bootloader is just as likely to step on things... what happens when/if it does?
> 
> Ingo Molnar <mingo@kernel.org> wrote:
> >
> >* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >
> >> Patch 2/2 has the description, but suffice it to say I'm 
> >> not really pleased with this, though it does solve a 
> >> problem we have.  On some machines, we get MMIO space 
> >> allocated on top of this hidden memory, which can cause 
> >> problems.  I'm not sure if there are similar problems for 
> >> other hunks of the address space; if so it's possible 
> >> this could be made more general (though the bits for 
> >> looking up the address of this region are definitely 
> >> Intel graphics specific).
> >
> >It looks pretty hardware specific. Discovering it the hard 
> >way and marking it e820 reserved in an early quirk is what 
> >the firmware should have done to begin with - and I doubt 
> >the kernel could do anything significantly cleaner.
> >
> >How does Windows manage to not crash? By luckily never 
> >allocating PCI resources on top of the RAM? Or does it have 
> >a quirk?
> >
> >> Chris has some patches on top to add a new E820 type so 
> >> we can look up the region later, which removes some 
> >> redundant code in the i915 driver at least.
> >> 
> >> Any comments?  I assume no one likes this, but maybe it's 
> >> just another early quirk we'll have to live with...
> >
> >No strong feelings against it - my only suggestion would be 
> >to make this more visible - right now it's added as e820 
> >reserved which hides amongst other areas already marked 
> >reserved - would a low-key printk() of the range added make 
> >it more apparent that a kernel quirk activated here?
> >
> >Just so that people know that it came from the kernel, not 
> >the firmware.
> >
> >But in any case:
> >
> >Acked-by: Ingo Molnar <mingo@kernel.org>
> >
> >Thanks,
> >
> >	Ingo
> 


-- 
Jesse Barnes, Intel Open Source Technology Center
