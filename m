Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaDXT2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:28:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34447 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaDXT2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:28:09 -0400
Date: Thu, 24 Apr 2014 21:28:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@jikos.cz>
Subject: [partial bisect] Re: 3.15-rc2: i915 regression: only top 20% of
 screen works in X
Message-ID: <20140424192807.GA30333@amd.pavel.ucw.cz>
References: <20140423202248.GA3621@amd.pavel.ucw.cz>
 <CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com>
 <20140423220952.GA3627@amd.pavel.ucw.cz>
 <20140424055023.GA31221@nuc-i3427.alporthouse.com>
 <CAKMK7uFAgHJ-kYJEcDCvNm3B4ELKC8CFK8iP+-SL7bdT5-VQHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFAgHJ-kYJEcDCvNm3B4ELKC8CFK8iP+-SL7bdT5-VQHA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> And if you can indeed reliably reproduce this a bisect could be
>  really useful

It seems reliable, yes. So far I got:
								Pavel

git bisect start
# good: [455c6fdbd219161bd09b1165f11699d6d73de11c] Linux 3.14
git bisect good 455c6fdbd219161bd09b1165f11699d6d73de11c
# bad: [c39b06951f1dc2e384650288676c5b7dcc0ec92c] DRM: armada: fix corruption while loading cursors
git bisect bad c39b06951f1dc2e384650288676c5b7dcc0ec92c
# good: [5fb6b953bb7aa86a9c8ea760934982cedc45c52b] include/linux/syscalls.h: add sys_renameat2() prototype
git bisect good 5fb6b953bb7aa86a9c8ea760934982cedc45c52b
# good: [8ad2bc9796994ecba9f4ba2fc9abca27ee9d193d] Merge branch 'drm-intel-next' of git://git.freedesktop.org/git/drm-intel into drm-next
git bisect good 8ad2bc9796994ecba9f4ba2fc9abca27ee9d193d
# good: [1287aa903f1b9248f34fb215e3b875d2ae243425] drm: Remove the prefix argument of drm_ut_debug_printk()
git bisect good 1287aa903f1b9248f34fb215e3b875d2ae243425
# bad: [c8431fda9f9f3c3b7490cb44bd5720b494a2421e] drm/i915: don't get/put runtime PM at the debugfs forcewake file
git bisect bad c8431fda9f9f3c3b7490cb44bd5720b494a2421e
# bad: [db8384f2e07bfa8cc607914dfa0b3cee81f59839] drm/i915: don't get/put PC8 reference on freeze/thaw
git bisect bad db8384f2e07bfa8cc607914dfa0b3cee81f59839
# bad: [b2040f6fed736ccd2319768bc59833abe74148b8] drm/i915: Remove erronous WARN in the vlv pipe crc code
git bisect bad b2040f6fed736ccd2319768bc59833abe74148b8
# good: [301ea74a57851c19e1438ceeaffab663f402f79f] drm/i915: Allow HDMI+VGA cloning
git bisect good 301ea74a57851c19e1438ceeaffab663f402f79f
# bad: [02f6a1e750df8201561171c47472435557a65864] drm/i915: warn if ring is active before sync flush
git bisect bad 02f6a1e750df8201561171c47472435557a65864
# good: [8407bb9129da95fc4099b84cdbbc23e6d4f66aee] drm/i915/bdw: Use scratch page table for GEN8 PPGTT
git bisect good 8407bb9129da95fc4099b84cdbbc23e6d4f66aee





-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
