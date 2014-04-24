Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbaDXNnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:43:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52401 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbaDXNnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:43:46 -0400
Date: Thu, 24 Apr 2014 15:43:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@jikos.cz>
Subject: Re: 3.15-rc2: i915 regression: only top 20% of screen works in X
Message-ID: <20140424134345.GA20861@amd.pavel.ucw.cz>
References: <20140423202248.GA3621@amd.pavel.ucw.cz>
 <CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com>
 <20140423220952.GA3627@amd.pavel.ucw.cz>
 <20140424055023.GA31221@nuc-i3427.alporthouse.com>
 <CAKMK7uFAgHJ-kYJEcDCvNm3B4ELKC8CFK8iP+-SL7bdT5-VQHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uFAgHJ-kYJEcDCvNm3B4ELKC8CFK8iP+-SL7bdT5-VQHA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Like Chris said please test latest drm-intel-nighlty from
> http://cgit.freedesktop.org/drm-intel to make sure that the recently
> merged mitigation measures work properly. But those won't get your gpu
> back, only the display and it's only for 3.16. We're still hunting a

What does it means "won't get my gpu back, just my display"? Gpu is
the thing driving the display... no?

I checked out drm-intel-nightly. Now I can see some kernel messages
scrolling around on vga console (improvement?), but then end up with
completely blank screen, and dead machine, AFAICT. Can't seem to ping
it.

BTW you might want to fix these...

drivers/gpu/drm/i915/i915_cmd_parser.c: In function ‘i915_parse_cmds’:
drivers/gpu/drm/i915/i915_cmd_parser.c:919: warning: format ‘%td’
expects type ‘ptrdiff_t’, but argument 5 has type ‘long unsigned int’
  CC      drivers/gpu/drm/i915/i915_gem_context.o
  LD [M]  drivers/gpu/drm/udl/udl.o
  CC      drivers/gpu/drm/i915/i915_gem_debug.o
  CC      drivers/gpu/drm/i915/i915_gem_dmabuf.o
  CC      drivers/gpu/drm/i915/i915_gem_evict.o
  CC      drivers/gpu/drm/i915/i915_gem_execbuffer.o
  CC      drivers/gpu/drm/i915/i915_gem_gtt.o
drivers/gpu/drm/i915/i915_gem_gtt.c: In function
‘gen8_ggtt_insert_entries’:
drivers/gpu/drm/i915/i915_gem_gtt.c:1389: warning: ‘addr’ may be used
uninitialized in this function
drivers/gpu/drm/i915/i915_gem_gtt.c: In function
‘gen6_ggtt_insert_entries’:
drivers/gpu/drm/i915/i915_gem_gtt.c:1435: warning: ‘addr’ may be used
uninitialized in this function

Thanks,
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
