Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab3A3XYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 18:24:23 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59488 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab3A3XYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 18:24:21 -0500
Date: Wed, 30 Jan 2013 23:24:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Ruslan Bilovol <ruslan.bilovol@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com,
        eduardo.valentin@ti.com
Subject: Re: [RFC PATCH v3 1/2] ARM: kernel: update cpuinfo to print SoC
	model name
Message-ID: <20130130232408.GL2637@n2100.arm.linux.org.uk>
References: <1359558091-29251-1-git-send-email-ruslan.bilovol@ti.com> <1359558091-29251-2-git-send-email-ruslan.bilovol@ti.com> <alpine.LFD.2.02.1301301402330.6300@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1301301402330.6300@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 02:07:53PM -0500, Nicolas Pitre wrote:
> On Wed, 30 Jan 2013, Ruslan Bilovol wrote:
> 
> > Currently, reading /proc/cpuinfo provides userspace with CPU ID of
> > the CPU carrying out the read from the file.
> > Userspace using this information may decide what module
> > to load or how to configure some specific (and processor-depended)
> > settings or so.
> > However, since really different SoCs can share same ARM core,
> > this information currently is not so useful.
> > For example, TI OMAP4460 and OMAP4470 SoCs show the same
> > information in the /proc/cpuinfo whereas they are different.
> > Since in most cases ARM CPU is a part of some system on a chip (SoC),
> > the "cpuinfo" file looks like exactly that place, where this
> > information have to be displayed.
> > 
> > So added new line "SoC name" in the "cpuinfo" output for system
> > on a chip name. It is placed between CPU information and machine
> > information, so the file structure looks gracefully (CPU-SoC-Hardware)
> > 
> > Example:
> > 
> > / # cat proc/cpuinfo
> > [...]
> > CPU variant     : 0x2
> > CPU part        : 0xc09
> > CPU revision    : 10
> > 
> > SoC name        : OMAP4470
> > 
> > Hardware        : OMAP4 Blaze Tablet
> 
> Please remove that extra blank line between "SoC name" and "Hardware".  
> The blank line after "CPU revision" is fine.
> 
> Also, please rename this to "System name".  Not all systems are "on 
> chip".  By using "System name" this is more universally useful.

You may notice I've already suggested that this should be using the SoC
infrastructure to export this information, which was explicitly designed
to do this.

If we're going to have one SoC doing one thing and another SoC exporting
this information a completely different way, we're doomed.  We need to
make a decision and do it one way and one way only - and that decision
was made when drivers/base/soc.c was merged.

Unfortunately, I'd forgotten about that when I made my initial comments
about the difference between "CPU" and "SoC".
