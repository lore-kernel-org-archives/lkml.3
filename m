Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbaDXNhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:37:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52247 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbaDXNgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:36:53 -0400
Date: Thu, 24 Apr 2014 15:36:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@jikos.cz>
Subject: Re: 3.15-rc2: i915 regression: only top 20% of screen works in X
Message-ID: <20140424133652.GA19610@amd.pavel.ucw.cz>
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

On Thu 2014-04-24 08:03:04, Daniel Vetter wrote:
> On Thu, Apr 24, 2014 at 7:50 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > That says that i915.ko failed to initialise the GPU (or rather the GPU
> > wasn't responding) and bailed during module load. The key line here is
> >
> > [drm:init_ring_common] *ERROR* render ring initialization failed ctl
> > 0001f001 head 00002034 tail 00000000 start 0012f000
> >
> > Jiri has been seeing a similar issue creep in during resume, but it is
> > not reliable enough to bisect. Is your boot failure reliable enough to
> > bisect? Also drm-intel-nightly should mitigate this failure and allow
> > i915.ko to continue to load and run X, which would be worth testing to
> > make sure that works as intended.
> 
> Oh right, g4x going beserk :( Apparently something changed in 3.15
> somewhere which made this much more likely, but like Chris said in
> Jiri's case it's too unreliable to reproduce for a bisect. We've had
> this come&go pretty much ever since kms support was merged and never
> tracked it down.

So far I went back to 3.14, and yes, graphics works there.

Back to 3.15, put it to smaller monitor. This time, top 30% of screen
works, and last working scanline is copied to the rest 60% of
screen. [With the exception of mouse cursor, that somehow affects that
magically.]

> The bug is https://bugs.freedesktop.org/show_bug.cgi?id=76554
> 
> Like Chris said please test latest drm-intel-nighlty from
> http://cgit.freedesktop.org/drm-intel to make sure that the recently
> merged mitigation measures work properly. But those won't get your gpu
> back, only the display and it's only for 3.16. We're still hunting a
> proper fix for 3.15.

So you know where the bug is or not?

> And if you can indeed reliably reproduce this a bisect could be really useful.

I'm confused. And yes, it seems reliable. But I'm not sure if I see
same bug you are talking about.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
