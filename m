Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722Ab3EBNqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:46:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37339 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759622Ab3EBNqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:46:49 -0400
Date: Thu, 2 May 2013 15:46:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oneukum@suse.de>
Cc: Colin Cross <ccross@android.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 03/10] freezer: add new freezable helpers using
 freezer_do_not_count()
Message-ID: <20130502134646.GA24576@amd.pavel.ucw.cz>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
 <1367271946-7239-4-git-send-email-ccross@android.com>
 <20130502124826.GE22618@amd.pavel.ucw.cz>
 <4717747.DX2SLP8TIR@linux-5eaq.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4717747.DX2SLP8TIR@linux-5eaq.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-05-02 15:05:13, Oliver Neukum wrote:
> On Thursday 02 May 2013 14:48:26 Pavel Machek wrote:
> > On Mon 2013-04-29 14:45:39, Colin Cross wrote:
> > > Freezing tasks will wake up almost every userspace task from
> > > where it is blocking and force it to run until it hits a
> > > call to try_to_sleep(), generally on the exit path from the syscall
> > > it is blocking in.  On resume each task will run again, usually
> > > restarting the syscall and running until it hits the same
> > > blocking call as it was originally blocked in.
> > 
> > Ok, so you are optimizing suspend at the cost of runtime operations,
> > right?
> > 
> > Would it make sense to do suspends entirely without freezer in your
> > configurations? With the right drivers, it should work ok.
> 
> Right now drivers now that they will not be busy when runtime
> suspend happens. The freezer has the same effect for system PM.
> If you remove that certainty it becomes impossible for simple drivers
> to declare their devices busy upon open and do no synchronization
> between IO and PM.

I know. Drivers can mostly ignore suspend.

But android people do suspend multiple times a second, and are
optimizing freezer. I'm suggesting they should take a look at their
drivers, and perhaps they can optimize freezer out totally.

(Or perhaps switch to n900-like solution, and avoid suspend
entirely. They keep machines functioning in suspend mode. That aint no
suspend.)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
