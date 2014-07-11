Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaGKT0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:26:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38030 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbaGKT0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:26:31 -0400
Date: Fri, 11 Jul 2014 21:26:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: 3.15-rc: regression in suspend
Message-ID: <20140711192629.GA20015@amd.pavel.ucw.cz>
References: <alpine.LNX.2.00.1405151727380.16459@pobox.suse.cz>
 <CAKMK7uFEjDGSpdB0xDPL09GZ8N7aFrNA530HbRLyfTPx5SkLQw@mail.gmail.com>
 <20140607120614.GB5309@amd.pavel.ucw.cz>
 <20140607231124.GA3611@amd.pavel.ucw.cz>
 <CAKMK7uEALofLiEA3m-QKjygC=YZNjaEtUMfbpbXinMoim1ygkw@mail.gmail.com>
 <20140609102328.GA25332@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1406091302560.20782@pobox.suse.cz>
 <20140625223522.GA5923@xo-6d-61-c0.localdomain>
 <alpine.LNX.2.00.1406271537000.21386@pobox.suse.cz>
 <20140707083908.GE5821@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707083908.GE5821@phenom.ffwll.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-07-07 10:39:08, Daniel Vetter wrote:
> On Fri, Jun 27, 2014 at 03:37:16PM +0200, Jiri Kosina wrote:
> > On Thu, 26 Jun 2014, Pavel Machek wrote:
> > 
> > > Ok, so I have set up machines for ktest / autobisect, and found out that 
> > > 3.16-rc1 no longer has that problem. Oh well, bisect would not be fun, 
> > > anyway...
> > 
> > I am still seeing the problem with 3.16-rc2.
> 
> I'm confused now. Is the bisect result
> 
> commit 773875bfb6737982903c42d1ee88cf60af80089c
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Mon Jan 27 10:00:30 2014 +0100
> 
>     drm/i915: Don't set the 8to6 dither flag when not scaling
> 
> now the culprit or not? Or do we have 2 different bugs at hand here?

Three different issues, it seems. Two ring initialization problems,
one went away in 3.16 (for me), second did not (suspend for jikos),
third -- trivial issue with 8to6 dither.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
