Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbaAHVIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:08:45 -0500
Received: from relais.videotron.ca ([24.201.245.36]:17997 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaAHVIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:08:43 -0500
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jan 2014 16:08:43 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 08 Jan 2014 16:08:42 -0500 (EST)
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
Message-id: <alpine.LFD.2.10.1401081600370.1851@knanqh.ubzr>
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

> Hi,
> 
> On Wed, Jan 8, 2014 at 11:20 AM, Russell King - ARM Linux
> > No, we're saying to put the work-around in the boot loader, not the kernel.
> 
> Unfortunately the resume path of the firmware runs from Read Only 
> firmware code (yes, it sucks), so it's not totally trivial to fix. It 
> would be possible for someone to unscrew their write protect switch 
> and update their RO firmware, but that doesn't help the average user.

[...]

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

If Joe Upstream wants to run an upstream kernel, doesn't he have to 
unscrew his write protect switch first, at which point the RO firmware 
can be updated as well?


Nicolas
