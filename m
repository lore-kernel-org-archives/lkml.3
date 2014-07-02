Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaGBVXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 17:23:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53612 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbaGBVW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 17:22:59 -0400
Date: Wed, 2 Jul 2014 23:22:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Richter <thor@math.tu-berlin.de>
Cc: linux-kernel@vger.kernel.org,
        Ville Syrj?l? <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>, rjw@sisk.pl
Subject: Re: Kernel OOPS when reloading i915 after resume from suspend
Message-ID: <20140702212219.GA2842@xo-6d-61-c0.localdomain>
References: <53B05033.7070709@math.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B05033.7070709@math.tu-berlin.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> still experimenting with the resume from suspend on the Fujitsu
> S6010. I can, however, still create a kernel oops. The kernel source
> comes from alm_fixes5, kernel 3.15.0-rc7+. For that, do the
> following:
> 
> 1) Shut down X,
> 2) Unbind the consoles:
> 
> echo 0 > /sys/class/vtconsole/vtcon1/bind
> echo 0 > /sys/class/vtconsole/vtcon0/bind
> 
> 3) Remove the i915
> 
> rmmod i915
> 
> 4) Suspend the system
> 
> pm-suspend

Does it also break with plain echo mem > /sys/power/state?

Does it break when you don't suspend at all?

> 5) Resume the system by pressing on the power-button.
> 6) Reload the i915 module with
> 
> modprobe i915.
> 
> Result is a kernel-Oops:

Sounds like problem in suspend/resume framework, actually :-(.

									Pavel

> 
> Jun 29 19:34:00 tyleet kernel: [  321.283072] [drm] Memory usable by
> graphics device = 128M
> Jun 29 19:34:00 tyleet kernel: [  321.286770] [drm] Supports vblank
> timestamp caching Rev 2 (21.10.2013).
> Jun 29 19:34:00 tyleet kernel: [  321.286782] [drm] Driver supports
> precise vblank timestamp query.
> Jun 29 19:34:00 tyleet kernel: [  321.286959] [drm] applying pipe a
> force quirk
> Jun 29 19:34:00 tyleet kernel: [  321.286965] [drm] applying pipe b
> force quirk
> Jun 29 19:34:00 tyleet kernel: [  321.307436] *pde = 00000000
> Jun 29 19:34:00 tyleet kernel: [  321.307568] Oops: 0000 [#1]
> Jun 29 19:34:00 tyleet kernel: [  321.307751] Modules linked in:
> i915(+) michael_mic arc4 ecb lib80211_crypt_tkip lib80211_crypt_ccmp
> binfmt_misc fuse netconsole loop firewire_sbp2 hid_generic usbhid
> hid snd_intel8x0 sg snd_ac97_codec ac97_bus snd_pcm sr_mod snd_seq

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
