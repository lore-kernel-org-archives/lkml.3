Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbaAKVPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 16:15:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58195 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaAKVPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 16:15:23 -0500
Date: Sat, 11 Jan 2014 22:15:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org,
        Linux-pm mailing list <linux-pm@vger.kernel.org>
Subject: Re: No freezing of kernel threads (was: Re: [GIT PULL] libata
 fixes for v3.13-rc5)
Message-ID: <20140111211521.GA12064@amd.pavel.ucw.cz>
References: <1667032.A7Knz5cBng@vostro.rjw.lan>
 <Pine.LNX.4.44L0.1312252211550.15064-100000@netrider.rowland.org>
 <20131226041856.GA16483@htj.dyndns.org>
 <1963765.T2MGFJrVrL@vostro.rjw.lan>
 <20131226160517.GB16483@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131226160517.GB16483@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Well, it looks like we don't really know why things are done the way they
> > are done at least in some cases, so in my personal view it would be good to
> > go through all of the kernel freezer users just for this reason alone.  We
> > can't really say which of them are legitimate without that and how difficult
> > it would be for them to switch over to using something more fine grained than
> > the freezer.
> 
> I'm a bit worried about things which may not be explicit.
> ie. something which is broken but sorta working because things like
> writeback and jbd are frozen.  I think I worry about that because I
> remember one argument for kernel freezer from way way back, that it's
> too hard to implement proper suspend/resume for all drivers and by
> freezing most kthreads things should mostly work, which sounded pretty
> crazy to me even back then.  Hopefully, we don't have much left
> depending on such magic.

Careful there. Hibernation depends on data on disk not changing after
freeze.

So you definitely do _not_ want writeback/jbd running while uswsusp
does its image writing.

(I wonder what happens if uswsusp needs to trigger writeback to free
memory. But I'm too scared to check :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
