Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbaDWI0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:26:09 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:7310 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755203AbaDWI0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:26:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao94AOF4V1N5LEcvPGdsb2JhbAA/GoMGT4MVqAMGlAmFYoEWFwMBAQEBODWCJQEBBAE6HCMFCwgDDgoJJQ8FJQMHGhMJiDAHDjbPDxaOQgeEOQSYdJRIgVEr
Date: Wed, 23 Apr 2014 18:25:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: Ivan Pantovic <gyro.ivan@gmail.com>
Cc: Speedy Milan <speedy.milan@gmail.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: rm -f * on large files very slow on XFS + MD RAID 6 volume of
 15x 4TB of HDDs (52TB)
Message-ID: <20140423082538.GR18672@dastard>
References: <CAHuzUScfp19c_th_pfsZs05+yDz34MuEH-P1f+FF1dcivfH=5Q@mail.gmail.com>
 <20140423021835.GI15995@dastard>
 <53576A7D.9020303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53576A7D.9020303@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 09:23:41AM +0200, Ivan Pantovic wrote:
> 
> >[root@drive-b ~]# xfs_db -r /dev/md0
> >xfs_db> frag
> >actual 11157932, ideal 11015175, fragmentation factor 1.28%
> >xfs_db>
> 
> this is current level of fragmentation ... is it bad?

http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25._Is_that_bad.3F

> some say over 1% is candidate for defrag? ...

Some say that over 70% is usually not a problem:

http://www.mythtv.org/wiki/XFS_Filesystem#Defragmenting_XFS_Partitions

i.e. the level that becomes are problem is highly workload specific.
So, you can't read *anything* in that number without know exactly
what is in your filesystem, how the application(s) interact with it
and so on. 

Besides, I was asking specifically about the files you removed, not
the files that remain in the filesystem. Given that you have 11
million inodes in the filesystem, you probably removed the only
significantly large files in the filesystem....

So, the files your removed are now free space, so free space
fragmentation is what we need to look at.  i.e. use the freesp
command to dump the histogram and summary of the free space...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
