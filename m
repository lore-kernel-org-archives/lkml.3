Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab3LSAWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:22:24 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:47639 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367Ab3LSAWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:22:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokHAGo7slJ5LHyk/2dsb2JhbABSB4MKgzyxFYVdgRYXdIIlAQEBAwE6HCMFCwgDGAklDwUlAyETh3wHyk0XFo4uBkgHhDYEmBWSFYFtgVIogSwj
Date: Thu, 19 Dec 2013 11:22:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Nigel Cunningham <nigel@tuxonice.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system
 suspend/hibernation
Message-ID: <20131219002216.GT31386@dastard>
References: <201202172159.15396.rjw@sisk.pl>
 <CA+5PVA50UA1oP1jKgnQjHh8APp=cNWREw3bkfrkV1OW_Tg1g+A@mail.gmail.com>
 <201205252113.50900.rjw@sisk.pl>
 <CA+5PVA5GWsTdNky-K1-hu5_R55hdKfr-Oa26HpX=FdA1cRZsbQ@mail.gmail.com>
 <CA+5PVA7vsZPd9eXwN-Q+d8c9+0bAmVdr698vv+LFyrn+3iFOMA@mail.gmail.com>
 <20131217230843.GA2911@amd.pavel.ucw.cz>
 <20131217233152.GC20579@dastard>
 <20131218000128.GA3737@amd.pavel.ucw.cz>
 <20131218123952.GI31386@dastard>
 <20131218140842.GA20488@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218140842.GA20488@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 03:08:42PM +0100, Pavel Machek wrote:
> > > > I disagree - given the problem it is resolving leads to silent
> > > > filesystem corruption, this patch should be considered somewhat of a
> > > > priority to push...
> > > 
> > > Umm. Ok, I forgot what it does, really.
> > 
> > It ensures that the filesystem is in an quiescent state both in
> > memory and on disk, and it cannot be modified in memory or on disk
> > whilst the suspend image is being generated, or by log recovery
> > after a resume before the suspended image has been restored.
> 
> If someone attempts to run log recovery before resume, that's a bug
> and yes, it will corrupt filesystems. (Including ext3). Don't do that.

Freezing the filesystem prevents that accidental mount of the
filesystem from being an issue. It fixes a bug that:

> Documentation/power/swsusp.txt:
> 
>  * BIG FAT WARNING
>    *********************************************************
>  *
>  * If you touch anything on disk between suspend and resume...
>  *                              ...kiss your data goodbye.

Makes this a whole lot less dangerous.

> > > So... for few years now suspend corrupts data on XFS? And Fedora has
> > > the fix but it is not in mainline? That does not sound right...
> > 
> > The issues freezing the filesystem before the suspend image is
> > created affect every journalled filesystem linux supports, be
> > it XFS, ext4, reiser, btrfs, etc.
> 
> Did not it have some problems with ext3?

Please read more carefully: "affect every journalled filesystem
linux supports". So, ext3 is affected because it's a journalling
filesystem.  I didn't list every journalled filesystem Linux
supports - "etc" means there are more examples that aren't
explicitly listed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
