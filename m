Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaI0LLm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 07:11:42 -0400
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:36702 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaI0LLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 07:11:40 -0400
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Sep 2014 07:11:40 EDT
Date: Sat, 27 Sep 2014 14:01:56 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        C =?iso-8859-1?Q?Bergstr=F6m?= <cbergstrom@pathscale.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: Stupid NVIDIA 3D vgaarb.c patch
Message-ID: <20140927110156.GD12451@reaktio.net>
References: <CAOnawYp7kv7Zjn4j-j4-TUOshE9G1uXWEqXB_=RHePNwNLmwWA@mail.gmail.com>
 <CA+55aFwX_nV9oUjh6u5WY=jpLxN-a5GFLmXQWDbHW0Yom9OOVA@mail.gmail.com>
 <1411420555.1199.151.camel@ul30vt.home>
 <CAOnawYp4QLq+k9__BKcAapHQyShYa93B9S7rbt30Jv3z+Dm9XA@mail.gmail.com>
 <1411422892.1199.173.camel@ul30vt.home>
 <CADnq5_MXAsW+=Zaed-RVCentb+p7GgETOisDkGdMk_OGxPHLng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_MXAsW+=Zaed-RVCentb+p7GgETOisDkGdMk_OGxPHLng@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 06:10:50PM -0400, Alex Deucher wrote:
> >
> > With dual VGA controllers, we can change VGA routing in the chipset so
> > that we can address one device or the other using the VGA address space.
> > This lets things like Xorg switch between cards to initialize a card via
> > the VGA BIOS or execute runtime VGA BIOS calls.  If one of those devices
> > reports itself as a 3D controller, then we have no reason to believe
> > that the device actually responds to VGA accesses or that the PCI ROM
> > payload includes a VGA BIOS.
> >
> > Maybe that's how the arbiter device registration should work, if the
> > class code is VGA add it, if it's 3D controller, switch VGA routing and
> > see if it responds to VGA.  There are still a couple problems that I've
> > been beating my head against though.  First, i915 lies when it opts-out
> > of VGA arbitration, so you might think you've found a VGA device
> > elsewhere, but you're actually still talking to IGD.  Second is the Xorg
> > DRI problem where it's going to disable DRI support if suddenly a second
> > arbitration participant appears.  This is what happened when I tried to
> > fix the i915 problem and suddenly anybody with IGD + plugin graphics
> > lost DRI and the fix was reverted.  The whole thing is pretty broken.
> >
> > In this case, if your laptop actually supports disabling and hiding the
> > IGD device, I'd expect the Nvidia device to switch to reporting itself
> > as VGA.  It seems like often the Optimus graphics aren't even directly
> > connected to an output device, which makes me curious that you can
> > actually pick one or the other.  Thanks,
> 
> AFAIK, on most recent (like in the last 2-3 years) hybrid laptops
> don't really have the option to boot to the dGPU or even disable the
> integrated graphics (I'm not sure that was ever possibly, even on the
> old muxed ones).  Depending on the OEM, the dGPU may be wired to one
> or more of the external ports, but I don't think those are usable
> until after the drivers have loaded.  Newer radeon PowerXpress laptops
> mark the dGPU as PCI_CLASS_DISPLAY_OTHER and I don't think there is
> any expectation that they should be messing with vga.
>

I had Lenovo T430 hybrid graphics laptop earlier, which is in "last 2-3 years",
and it allowed me to choose "IGD only", "Optimus", or "Nvidia only" in BIOS..


-- Pasi
 
> Alex
> 

