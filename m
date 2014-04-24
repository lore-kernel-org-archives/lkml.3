Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbaDXN4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:56:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbaDXN4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:56:53 -0400
Date: Thu, 24 Apr 2014 15:56:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Pavel Machek <pavel@ucw.cz>
cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc2: i915 regression: only top 20% of screen works in X
In-Reply-To: <20140424133652.GA19610@amd.pavel.ucw.cz>
Message-ID: <alpine.LRH.2.00.1404241555440.1491@twin.jikos.cz>
References: <20140423202248.GA3621@amd.pavel.ucw.cz> <CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com> <20140423220952.GA3627@amd.pavel.ucw.cz> <20140424055023.GA31221@nuc-i3427.alporthouse.com> <CAKMK7uFAgHJ-kYJEcDCvNm3B4ELKC8CFK8iP+-SL7bdT5-VQHA@mail.gmail.com>
 <20140424133652.GA19610@amd.pavel.ucw.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014, Pavel Machek wrote:

> > > [drm:init_ring_common] *ERROR* render ring initialization failed ctl
> > > 0001f001 head 00002034 tail 00000000 start 0012f000
> > >
> > > Jiri has been seeing a similar issue creep in during resume, but it is
> > > not reliable enough to bisect. Is your boot failure reliable enough to
> > > bisect? Also drm-intel-nightly should mitigate this failure and allow
> > > i915.ko to continue to load and run X, which would be worth testing to
> > > make sure that works as intended.
> > 
> > Oh right, g4x going beserk :( Apparently something changed in 3.15
> > somewhere which made this much more likely, but like Chris said in
> > Jiri's case it's too unreliable to reproduce for a bisect. We've had
> > this come&go pretty much ever since kms support was merged and never
> > tracked it down.
> 
> So far I went back to 3.14, and yes, graphics works there.
> 
> Back to 3.15, put it to smaller monitor. This time, top 30% of screen
> works, and last working scanline is copied to the rest 60% of
> screen. [With the exception of mouse cursor, that somehow affects that
> magically.]
> 
> > The bug is https://bugs.freedesktop.org/show_bug.cgi?id=76554
> > 
> > Like Chris said please test latest drm-intel-nighlty from
> > http://cgit.freedesktop.org/drm-intel to make sure that the recently
> > merged mitigation measures work properly. But those won't get your gpu
> > back, only the display and it's only for 3.16. We're still hunting a
> > proper fix for 3.15.
> 
> So you know where the bug is or not?

No, but there is a workaround for cases kernel finds out that it cannot 
execute GPU commands (because the rings failed to initialize), and instead 
it falls back to CPU rendering directly into the framebuffer.

So it's highly sub-optimal, but works around the complete wreckage.

-- 
Jiri Kosina
SUSE Labs

