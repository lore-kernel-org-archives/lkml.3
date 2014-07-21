Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974AbaGUXFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 19:05:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53903 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaGUXFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 19:05:02 -0400
Date: Tue, 22 Jul 2014 01:05:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140721230500.GA7019@amd.pavel.ucw.cz>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
 <20140721120053.GA14069@amd.pavel.ucw.cz>
 <20140721123613.GL30979@8bytes.org>
 <20140721130629.GA15122@amd.pavel.ucw.cz>
 <20140721133800.GM30979@8bytes.org>
 <20140721141027.GA16042@amd.pavel.ucw.cz>
 <20140721160346.GP30979@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721160346.GP30979@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon 2014-07-21 18:03:46, Joerg Roedel wrote:
> On Mon, Jul 21, 2014 at 04:10:27PM +0200, Pavel Machek wrote:
> > > And Linux is only made for sane people? Thats pretty new to me ;-)
> > 
> > Yeah, but please don't optimize for insane people :-).
> 
> Thats rather discriminating, even more when you realize that 'insane' is
> a very subjective attribute.

You admitted you don't even have access to machine you are trying to
optimize for.

> > #6 is bugfix. We should take it. Rest is performance improvement for
> > insane config. I don't think we should take it.
> 
> Have you any other reason against these changes besides your
> proven-to-be-wrong disbelief that it is necessary?

Where you proven me wrong?

If kernel is preparing bitmaps before checking resume signature, that
is bug that costs you 60 seconds boot time on your 12TB machine. Fix
that bug. It will benefit everyone.

Software watchdog during hibernation on 12TB machine is a bug that
hits insane people. Ok, lets fix it.

Optimizing hibernation for memory-is-empty case is wrong. Linux tries
to use as much memory as it can.

Hibernating 12TB machine will take 5 hours or more. Redoing data
structures to save 60 seconds of 5 hour process is not worth
it. Nobody sane would hibernate 12TB machine.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
