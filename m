Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaJLOab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 10:30:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38310 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaJLOa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 10:30:29 -0400
Date: Sun, 12 Oct 2014 16:30:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org
Subject: Re: Machine crashes right *after* ~successful resume
Message-ID: <20141012143025.GA378@amd>
References: <54347520.3050109@gaast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54347520.3050109@gaast.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Rafael, including you on this since http://linuxconcloudopenna2013.sched.org/event/d708f47d07cd44b9669610778c024708#.VDRzTDS_EUF
> mentions you as the maintainer for Linux + power management. I hope this is
> still accurate.
> 
> Since Linux 3.12 (Debian version 3.12.9-1~bpo70+1) and all the way up to
> 3.16 (Debian version 3.16.3-2), I'm having suspend-resume issues on my
> machine (Intel Z68, i7-3770K) that are somewhat less obvious.
> 
> After every boot, I get two successful suspend+resume cycles, but after the
> third suspend, it won't resume successfully. On the VGA console I've never
> had anything useful logged, luckily over the serial console I've had more
> luck. I seem to get as far as:

Has it ever worked ok? ...aha, in 3.10, ok.

> I've found out about pm_trace, which always points at the same line (and no
> device):
> 
> /var/log/syslog.1:Oct 10 16:43:58 ruby kernel: [    0.780503]   Magic
> number: 0:52:740
> /var/log/syslog.1:Oct 10 16:43:58 ruby kernel: [    0.780599]   hash matches
> /tmp/linux-3.16.3/drivers/base/power/main.c:812
> 
> In my source tree that line is:
> 
>         TRACE_RESUME(error);


if it resumes ok, this kind of tracking will not help.

> With kernels 3.10 and older I have no such problems, I can suspend+resume as
> often as I want.

is there chance to bisect?

> I've already tried to skip the NVidia + VMware modules at boot time (as you
> can see from the logs they're not loaded at any point), but it didn't help.
> I could try omitting more modules.

Yes, try with minimal modules (and no s2ram) would be nice.
									
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
