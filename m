Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab3BATyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 14:54:39 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:46019 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523Ab3BATyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 14:54:37 -0500
Date: Fri, 1 Feb 2013 21:54:34 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Alex Deucher <alexdeucher@gmail.com>
cc: Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: Radeon RV100 init fails with specific card+mobo - IRQ problem
In-Reply-To: <CADnq5_Ny9_OVqyahSN9WOuwt=PxbT48=NbWr0-r1A5y0yhHKhA@mail.gmail.com>
Message-ID: <alpine.SOC.1.00.1302012153260.3031@math.ut.ee>
References: <alpine.SOC.1.00.1302011321220.17427@math.ut.ee> <CAH3drwb-248ngSqiXZGU=X1k45V8wmN4127_0gr=AQA=px2g0g@mail.gmail.com> <alpine.SOC.1.00.1302011726290.17427@math.ut.ee> <CADnq5_Ny9_OVqyahSN9WOuwt=PxbT48=NbWr0-r1A5y0yhHKhA@mail.gmail.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > Adding some printks reveals it calls
> >> > r100_init() -> radeon_irq_kms_init() -> drm_irq_install() ->
> >> > drm_dev_to_irq() and that fails. So no IRQ, no KMS.
> >> >
> >> > lspci does not show Interrupt like on some other PCI devices.
> >> > /proc/interrupts obviously does not contain the irq since we do not
> >> > register any yet.
> >> >
> >> > There is no BIOS option of "Enable IRQ for VGA" or similar (BIOS is
> >> > latest). Could this be the problem?
> >> >
> >> > What can I do to get KMS working on this computer?
> >> >
> >> > --
> >> > Meelis Roos (mroos@linux.ee)
> >>
> >> Try booting with radeon.agp_mode=-1
> >
> > radeon: `-1' invalid for parameter `agp_mode'
> 
> radeon.agpmode=-1

Still fails in the same place as in the beginning - finding IRQ.
 
> However, I think there are a number of places where we require
> interrupts that would need to be worked around (fences, display
> hotplug, pageflipping) if not interrupt is available.

OK.

-- 
Meelis Roos (mroos@linux.ee)
