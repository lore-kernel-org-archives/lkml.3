Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaCLXk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 19:40:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46943 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaCLXkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 19:40:55 -0400
Date: Thu, 13 Mar 2014 00:30:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: daniel.vetter@ffwll.ch, jani.nikula@linux.intel.com,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: WARN_ON() and X session lost from i915 on 3.14-rc6
Message-ID: <20140312233039.GA5582@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This cost me two half-written mails...

So far it happened once, so it may be very infrequent; but I do not
think I seen similar failure from i915 before, so it may be an
regression. Well...

-22 should be EINVAL afaict.

Any ideas?
								Pavel

[drm:i915_gem_object_get_pages] *ERROR* Attempting to obtain a
purgeable object
[drm:i915_gem_object_get_pages] *ERROR* Attempting to obtain a
purgeable object
------------[ cut here ]------------
WARNING: CPU: 0 PID: 2945 at drivers/gpu/drm/i915/i915_gem.c:1459
i915_gem_fault+0x10c/0x240()
unhandled error in i915_gem_fault: -22
Modules linked in:
CPU: 0 PID: 2945 Comm: Xorg Tainted: G        W    3.14.0-rc6+ #325
Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )
03/31/2011
 000005b3 f00ade08 c47db94b c4a318f4 f00ade38 c4037f9a c4a31ed0
 f00ade64
 00000b81 c4a318f4 000005b3 c436cb9c c436cb9c 00000002 ea35af00
 f00adebc
 f00ade50 c403803e 00000009 f00ade48 c4a31ed0 f00ade64 f00ade90
 c436cb9c
Call Trace:
 [<c47db94b>] dump_stack+0x41/0x52
 [<c4037f9a>] warn_slowpath_common+0x7a/0xa0
 [<c436cb9c>] ? i915_gem_fault+0x10c/0x240
 [<c436cb9c>] ? i915_gem_fault+0x10c/0x240
 [<c403803e>] warn_slowpath_fmt+0x2e/0x30
 [<c436cb9c>] i915_gem_fault+0x10c/0x240
 [<c40d2fa7>] __do_fault+0x57/0x490
 [<c4074e6e>] ? __lock_acquire+0x3ae/0xc80
 [<c436ca90>] ? i915_gem_pwrite_ioctl+0x8a0/0x8a0
 [<c40d428b>] handle_mm_fault+0x14b/0x750
 [<c402f54f>] ? __do_page_fault+0xaf/0x410
 [<c402f8b0>] ? __do_page_fault+0x410/0x410
 [<c402f8b0>] ? __do_page_fault+0x410/0x410
 [<c402f59c>] __do_page_fault+0xfc/0x410
 [<c403abb5>] ? SyS_setitimer+0x45/0xd0
 [<c40fc3e5>] ? SyS_ioctl+0x45/0x70
 [<c402f8b0>] ? __do_page_fault+0x410/0x410
 [<c402f8bb>] do_page_fault+0xb/0x10
 [<c47e0a17>] error_code+0x67/0x6c
---[ end trace c124d19552341c51 ]---
wlan0: deauthenticating from 00:33:13:01:31:45 by local choice
(reason=3)
cfg80211: Calling CRDA to update world regulatory domain
Chrome_IOThread[20585]: segfault at 0 ip b459e086 sp ad7f9da0 error 4
in chromium-browser[b3ecd000+390f000]
wlan0: authenticate with 00:33:13:01:31:45
wlan0: send auth to 00:33:13:01:31:45 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:33:13:01:31:45 (try 1/3)


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
