Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3LROIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:08:45 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44301 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3LROIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:08:44 -0500
Date: Wed, 18 Dec 2013 15:08:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Nigel Cunningham <nigel@tuxonice.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system
 suspend/hibernation
Message-ID: <20131218140842.GA20488@amd.pavel.ucw.cz>
References: <201201281445.49377.rjw@sisk.pl>
 <201202172159.15396.rjw@sisk.pl>
 <CA+5PVA50UA1oP1jKgnQjHh8APp=cNWREw3bkfrkV1OW_Tg1g+A@mail.gmail.com>
 <201205252113.50900.rjw@sisk.pl>
 <CA+5PVA5GWsTdNky-K1-hu5_R55hdKfr-Oa26HpX=FdA1cRZsbQ@mail.gmail.com>
 <CA+5PVA7vsZPd9eXwN-Q+d8c9+0bAmVdr698vv+LFyrn+3iFOMA@mail.gmail.com>
 <20131217230843.GA2911@amd.pavel.ucw.cz>
 <20131217233152.GC20579@dastard>
 <20131218000128.GA3737@amd.pavel.ucw.cz>
 <20131218123952.GI31386@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218123952.GI31386@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I disagree - given the problem it is resolving leads to silent
> > > filesystem corruption, this patch should be considered somewhat of a
> > > priority to push...
> > 
> > Umm. Ok, I forgot what it does, really.
> 
> It ensures that the filesystem is in an quiescent state both in
> memory and on disk, and it cannot be modified in memory or on disk
> whilst the suspend image is being generated, or by log recovery
> after a resume before the suspended image has been restored.

If someone attempts to run log recovery before resume, that's a bug
and yes, it will corrupt filesystems. (Including ext3). Don't do that.

Documentation/power/swsusp.txt:

 * BIG FAT WARNING
   *********************************************************
 *
 * If you touch anything on disk between suspend and resume...
 *                              ...kiss your data goodbye.

> > So... for few years now suspend corrupts data on XFS? And Fedora has
> > the fix but it is not in mainline? That does not sound right...
> 
> The issues freezing the filesystem before the suspend image is
> created affect every journalled filesystem linux supports, be
> it XFS, ext4, reiser, btrfs, etc.

Did not it have some problems with ext3?

Regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
