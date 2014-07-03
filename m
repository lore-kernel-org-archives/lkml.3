Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaGCKit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:38:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54309 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbaGCKis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 06:38:48 -0400
Date: Thu, 3 Jul 2014 12:38:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Richter <thor@math.tu-berlin.de>
Cc: linux-kernel@vger.kernel.org,
        Ville Syrj?l? <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: Kernel OOPS when reloading i915 after resume from suspend
Message-ID: <20140703103846.GA12400@amd.pavel.ucw.cz>
References: <53B05033.7070709@math.tu-berlin.de>
 <13976_1404336180_53B47834_13976_165_1_20140702212219.GA2842@xo-6d-61-c0.localdomain>
 <53B4F3FB.6030108@math.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B4F3FB.6030108@math.tu-berlin.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>1) Shut down X,
> >>2) Unbind the consoles:
> >>
> >>echo 0 > /sys/class/vtconsole/vtcon1/bind
> >>echo 0 > /sys/class/vtconsole/vtcon0/bind
> >>
> >>3) Remove the i915
> >>
> >>rmmod i915
> >>
> >>4) Suspend the system
> >>
> >>pm-suspend
> >
> >Does it also break with plain echo mem > /sys/power/state?
> 
> No. If the modules stay resident, any user driven shutdown/resume
> events by writing into /sys/power/state work just fine.
> 
> >Does it break when you don't suspend at all?
> 
> No. Unloading and reloading i915 under normal conditions also works fine.
> 
> >>5) Resume the system by pressing on the power-button.
> >>6) Reload the i915 module with
> >>
> >>modprobe i915.
> >>
> >>Result is a kernel-Oops:
> >
> >Sounds like problem in suspend/resume framework, actually :-(.
> 
> Good guess, but wrong. The BIOS leaves the 830GM in a state the i915
> does not seem to like.

Ok, good, something for Intel people to solve, then...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
