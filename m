Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaFVPLP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 11:11:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38187 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaFVPLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 11:11:13 -0400
Date: Sun, 22 Jun 2014 17:11:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: regression: 3.16, i915: less colors in X?, caused by
 773875bfb6737982903c42d1ee88cf60af80089c
Message-ID: <20140622151111.GA4090@amd.pavel.ucw.cz>
References: <alpine.LNX.2.00.1405151727380.16459@pobox.suse.cz>
 <CAKMK7uFEjDGSpdB0xDPL09GZ8N7aFrNA530HbRLyfTPx5SkLQw@mail.gmail.com>
 <20140607120614.GB5309@amd.pavel.ucw.cz>
 <20140607231124.GA3611@amd.pavel.ucw.cz>
 <CAKMK7uEALofLiEA3m-QKjygC=YZNjaEtUMfbpbXinMoim1ygkw@mail.gmail.com>
 <20140609102328.GA25332@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1406091302560.20782@pobox.suse.cz>
 <20140621202901.GA3840@amd.pavel.ucw.cz>
 <20140621210652.GA14025@nuc-i3427.alporthouse.com>
 <20140622142622.GA4107@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140622142622.GA4107@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I just test-booted 3.16-rc1, and background in X looked just wrong --
> > > very noticeable bands on the background gradient. I thought that maybe
> > > it is just my eyes, but I went back to older kernel, and background is
> > > ok now.
> > > 
> > > I'm trying to figure out how to ask X what color depth it is using...?
> > > 
> > > This is thinkpad x60 with Debian 6.0.9.
> > > 
> > > Any ideas?
> > 
> > That suggests that the panel dithering changed. Compare intel_reg_dumper
> > output for both kernels, especially PIPE.CONF.

intel_reg_dumper has so many dependencies that it is basically
impossible to get working :-(.

Anyway, this seems to be the problem; if I revert it, my colors are
back.

commit 773875bfb6737982903c42d1ee88cf60af80089c
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon Jan 27 10:00:30 2014 +0100

    drm/i915: Don't set the 8to6 dither flag when not scaling
    
    Apparently we really only need this when the pfit is enabled, at
    least
    I couldn't dicern any difference here. Furthermore the hacks we
    have
    to reconstruct this bit is a bit glaring, and probably only works
    because we can't move the lvds port to any other pipe than pipe B
    on
    gen2/3.
    
    So let's just rip this out.
    
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=77137 (the
    LVDS
    WARNING log, not the main "VGA can't be turned on" issue).
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
