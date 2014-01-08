Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbaAHVOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:14:15 -0500
Received: from relais.videotron.ca ([24.201.245.36]:64630 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291AbaAHVON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:14:13 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 08 Jan 2014 15:58:52 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        David Garbett <David.Garbett@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] arm: Add Arm Erratum 773769 for Large data RAM latency.
In-reply-to: <CAD=FV=Ui8kec5vYA1jRT3EGNaUeWX-Ua5sUs+u3wdRz1oFnTzw@mail.gmail.com>
Message-id: <alpine.LFD.2.10.1401081538350.1851@knanqh.ubzr>
References: <1389187991-26446-1-git-send-email-gautam.vivek@samsung.com>
 <20140108143529.GB14122@mudshark.cambridge.arm.com>
 <CAD=FV=WYe7Qk_XPs=FCeB7pbDz8AnG0txFcDyAQWWAU60vd-Sw@mail.gmail.com>
 <20140108192028.GM27432@n2100.arm.linux.org.uk>
 <CAD=FV=Ui8kec5vYA1jRT3EGNaUeWX-Ua5sUs+u3wdRz1oFnTzw@mail.gmail.com>
User-Agent: Alpine 2.10 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jan 2014, Doug Anderson wrote:

> On Wed, Jan 8, 2014 at 11:20 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > We've been through these arguments many times, you're not the first to
> > raise it, and we've decided upon the policy.  We want as _few_ work-
> > arounds in the kernel as possible, because applying the work-arounds
> > is very problematical with the mixture of secure and non-secure booting.
> 
> OK, fair enough.  If we want no workaround here then we can drop this patch.
> 
> 
> I'd guess that the way forward is:
> 
> * Land kernel workaround locally in Chromium tree
> 
> * I'll try to land FW change locally in at least one Chromium branch.
> If we were to get a new RO build ever (seems unlikely at this point)
> it would be fixed for upstream kernels.  If we were to get a new RW
> build (seems unlikely, but at least less unlikely) it would be fixed
> if someone landed a kernel patch to save/restore this register across
> suspend/resume.
> 
> * If Joe Upstream wants to run an upstream kernel on some type of
> exynos5250 product (Samsung ARM Chromebook, HP Chromebook 11, Nexus 10
> are the ones I know of) then he will deal with the small number of
> crashes or figure out a solution.

At some point you have to realize that what you're proposing is not 
viable when taking into account the bigger picture.  And your FW 
architecture is to blame.  If you were running Windows instead of Linux 
I bet you'd have found a way to fix things differently than asking 
Microsoft to add a special quirk in their code.  In the PC world you are 
required to perform a BIOS update instead.

So you really need to provision the ability to update at least a portion 
of the firmware that is not read-only.  That may be a third-stage 
bootloader or the like which purpose is only to install workarounds such 
as this before executing the kernel and which doesn't need to be updated 
with the kernel.  And in theory you should be able to do that on top of 
your current RO firmware.

Errata workarounds are often machine specific and they can be applied 
only in special conditions the kernel might not safely know about until 
it is too late.


Nicolas
