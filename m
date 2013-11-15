Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab3KOPQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:16:53 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55190 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751966Ab3KOPQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:16:45 -0500
Date: Fri, 15 Nov 2013 15:16:39 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Jonas Bonn <jonas@southpole.se>
Cc: Olof Kindgren <olof.kindgren@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Mehall <contact@kevinmehall.net>, linux <linux@openrisc.net>
Subject: Re: [ORLinux] [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
Message-ID: <20131115151638.GC24831@e106331-lin.cambridge.arm.com>
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
 <5285EE5A.1070202@southpole.se>
 <CAMuHMdWA-9ax=NG_d0tyfzY3+42Ka7_r+jTeF-m5oW0eV8t1=g@mail.gmail.com>
 <5285FE1D.3020800@southpole.se>
 <CAKaYPCNqzYcSyTUjjb9H3naErjzqjLDBthE2xfQ98j-YOzQWwg@mail.gmail.com>
 <52860FC1.6050500@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52860FC1.6050500@southpole.se>
Thread-Topic: [ORLinux] [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> >>>> Version number needed.  OpenCores wanted "projectname-rtlsvn###" where
> >>>> ###
> >>>> is the SVN commit number of the RTL directory in the project's source
> >>>> repository.
> >>>>
> >>>
> >>> That's gonna need some information diving, as Stefan's orpsoc git
> >>> repositories
> >>> only contains references to orpsocv2 git-svn-ids, not the svn ids of
> >>> the original
> >>> component repositories.
> >>>
> >>
> >> Stefan?  Where's the "official" home of these cores nowadays?  Have they
> >> been modified since they were copied from OpenCores into orpsocv2?
> >>
> >>
> > Most cores are fetched directly from OpenCores SVN. Out of these, some are
> > patched on the fly by ORPSoC before they are being built. Most of the new
> > cores are only available on github
> 
> The version number is important in order to ensure _driver_ 
> compatibility.  As long as the patches don't make changes that requires 
> changes to the Linux driver then it's OK to just put the SVN version 
> number on them.  If incompatible changes are being made, then we really 
> need to find a "home" for these cores so that we can manage their 
> version numbers in some way.

On this front, I note the CPU node has:

  compatible = "opencores,or1200-rtlsvn481";

Should this not be something like:

  compatible = "opencores,or1200-rtlsvn481", "opencores,or1200";

That way falling back to an always known compatible string is easier.

> 
> >
> > More generally, can Linux use out-of-tree DTS files in an easy way? It's
> > handy to have them in the kernel, but the best fit might actually be to put
> > them in the corresponding orpsocv3 system directory. That would also make
> > it easier to have separate device trees for differently configured FPGAs
> > (they are reprogrammable after all).
> 
> Yes, the DTS files don't really belong in the kernel tree at all.  They 
> belong "near the hardware".  For these FPGA projects it definitely makes 
> sense to keep (or automatically generate) the DTS files in the RTL build 
> system, i.e. orpsoc.
> 
> We generally build the DTB into the kernel image itself, but that's not 
> really necessary.  You just need to get the DTB into memory and pass the 
> kernel a pointer to it.  If you can find some way to build the DTB into 
> the FPGA image (block RAM?) then you've got a self-describing HW image: 
>   have the OpenRISC core initialize itself with r3 containing the 
> address of the DTB and jump to the kernel entry point (reset vector) and 
> everything should just work.  If you put device tree logic into newlib 
> as well then you can use this HW description for (other) bare metal 
> apps, as well.
> 
> The device tree compiler is in the Linux kernel tree... but it's usable 
> outside of the Linux build system, as well.  You'll find the binary in 
> script/dtc/dtc in the kernel tree... run it with --help to get an idea 
> of how it's used.  It really isn't supposed to have anything to do with 
> Linux at all; it's a generic tool for a generic HW description.

It's worth noting the dtc is managed outside of the kernel [1] and
periodically new features are pulled in. It's available on it's own, and
several distributions package it.

As long as the bindings you are using are not in flux, then it's
entirely possible to use an out-of-tree dts.

Thanks,
Mark.

[1] http://git.jdl.com/gitweb/?p=dtc.git;a=summary
