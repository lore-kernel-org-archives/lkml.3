Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbbAZK12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:27:28 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42910 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbbAZK1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:27:24 -0500
Date: Mon, 26 Jan 2015 10:27:11 +0000
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: perf not capturing stack traces
Message-ID: <20150126102711.GC15598@arm.com>
References: <20150123195128.GE26557@saruman.tx.rr.com>
 <20150123205959.GD3073@kernel.org>
 <20150123223745.GJ26557@saruman.tx.rr.com>
 <20150124151204.GF3073@kernel.org>
 <20150124222342.GA26941@saruman.tx.rr.com>
 <20150125155651.GB11502@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150125155651.GB11502@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 03:56:52PM +0000, Russell King - ARM Linux wrote:
> On Sat, Jan 24, 2015 at 04:23:42PM -0600, Felipe Balbi wrote:
> > yeah, I'll try a few older kernels, also see if I can reproduce on other
> > boards.
> 
> Perf works for me with CONFIG_FRAME_POINTER=y, but that's only for kernel
> space, and for userspace where the programs have been built for ARM mode
> with frame pointers.
> 
> The kernel may work without CONFIG_FRAME_POINTER set, but I've never
> tested that, and I'd suggest that (given my experience looking at oops
> dumps) it's not all that reliable.
> 
> Lastly, userspace without frame pointers is pretty much hopeless.

FWIW, perf can now use libunwind for unwinding the userspace side of
things, so it's not quite as bad as it used to be. For the kernel side,
if the unwinder isn't working properly it would be nice to know *why*,
but I agree that it tends to be far flakier than the frame-pointer method.

Will
