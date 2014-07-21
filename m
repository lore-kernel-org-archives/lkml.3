Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbaGUOKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:10:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41837 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383AbaGUOK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:10:29 -0400
Date: Mon, 21 Jul 2014 16:10:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140721141027.GA16042@amd.pavel.ucw.cz>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
 <20140721120053.GA14069@amd.pavel.ucw.cz>
 <20140721123613.GL30979@8bytes.org>
 <20140721130629.GA15122@amd.pavel.ucw.cz>
 <20140721133800.GM30979@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721133800.GM30979@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > That would just cover the problem that the bitmap data structure and the
> > > algorithm in swsusp_free do not scale well on bigmem machines.
> > 
> > And is it a problem? Hibernation of 12TB machine will take 6 hours if
> > you back your swap with SSDs.
> > 
> > Does not scale == burns additional 60 seconds of CPU time. I think we
> > can live with that...
> 
> Problem is that these 76s are burned every time, whether you just use
> 500MB or the full 12TB of the machine.

On 12TB machine, how much memory is used after boot finishes? I
suspect it is not 500MB.

> Next problem is that the bitmaps are allocated (and need to be freed)
> without even being sure that a resume will happen.

Could we fix that instead? Allocating bitmaps before we see
hibernation signature is a bug.

[How long does 12TB machine boot?]

> > ...because noone sane will hibernate 12TB machine.
> 
> And Linux is only made for sane people? Thats pretty new to me ;-)

Yeah, but please don't optimize for insane people :-).

> > Yes, that's why I propose to apply just patch 6 -- to avoid soft
> > lockup warnings.
> 
> Only patch 6 would wrap the problem with the soft lockups, but the other
> patches actually improve the resume and boot situation on those
> machines.

Yeah. Provide timings for 12TB machine suspending/resuming and we may
talk about it.

#6 is bugfix. We should take it. Rest is performance improvement for
insane config. I don't think we should take it.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
