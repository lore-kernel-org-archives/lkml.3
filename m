Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaFGXLh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 19:11:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36626 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaFGXL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 19:11:26 -0400
Date: Sun, 8 Jun 2014 01:11:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: 3.15-rc: regression in suspend
Message-ID: <20140607231124.GA3611@amd.pavel.ucw.cz>
References: <20140513160926.GA3621@amd.pavel.ucw.cz>
 <20140513163734.GA4602@amd.pavel.ucw.cz>
 <20140513214155.GA5087@amd.pavel.ucw.cz>
 <alpine.LRH.2.00.1405141435510.30793@twin.jikos.cz>
 <20140514155759.GB9723@amd.pavel.ucw.cz>
 <20140514182046.GA13342@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1405151727380.16459@pobox.suse.cz>
 <CAKMK7uFEjDGSpdB0xDPL09GZ8N7aFrNA530HbRLyfTPx5SkLQw@mail.gmail.com>
 <20140607120614.GB5309@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140607120614.GB5309@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-06-07 14:06:14, Pavel Machek wrote:
> On Thu 2014-05-15 17:31:54, Daniel Vetter wrote:
> > On Thu, May 15, 2014 at 5:29 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> > >> > Note that X do work somehow after resume (I can't switch virtual
> > >> > desktops and dialog is stuck on screen, but it is not complete
> > >> > failure). I can do ctrl-alt-f1 and get to useful prompt.
> > >>
> > >> Oops. You were right. It seems it is duplicate after all.
> > >>
> > >> [drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head 00001020 tail 00000000 start 00003000
> > >
> > > Pavel, thanks a lot for testing.
> > >
> > > Adding Daniel and Chris to CC -- we have another incarnation of the bug
> > > that is being chased in 76554.
> > 
> > Someone succeeding at a bisect would be awesome ... Note that the only
> > key here is the ring init failure in dmesg.
> 
> Oh and... the machine has problems comming up after reboot (never seen
> those before 3.15). Sometimes, boot will hang with blank screen, and hard
> powerdown is needed...

Strange. It seems 3.15 with the patch reverted only boots in 30% or so
cases... And I've seen resume failure, too, so maybe I was just lucky
that it worked for a while.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
