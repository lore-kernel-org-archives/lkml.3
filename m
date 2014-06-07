Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaFGXoQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 19:44:16 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:23501 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945AbaFGXoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 19:44:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqdtAN6ik1N5LGMPPGdsb2JhbABYgw2sKwEGmRABgQEXBAEBAQE4NYQDAQEFJxMcIxAIAxgJJQ8FJQMHGhOIQc1KFxaFR4kPB4MrgRYBA5ogiymLays
Date: Sun, 8 Jun 2014 09:44:11 +1000
From: Dave Chinner <david@fromorbit.com>
To: Joe Perches <joe@perches.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>, Pranith Kumar <pranith@gatech.edu>,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        tim.c.chen@linux.intel.com, davidlohr@hp.com, mingo@redhat.com,
        xfs@oss.sgi.com
Subject: Re: [RFC PATCH 1/1] cleanup: use bool as return type for
 rwsem_is_locked
Message-ID: <20140607234411.GA9508@dastard>
References: <5390D7E1.7060606@gatech.edu>
 <5391FFFD.1060901@gatech.edu>
 <53920446.7060505@gatech.edu>
 <20140607001819.GE4453@dastard>
 <53926406.4020200@gmail.com>
 <53926DC1.4050304@gmail.com>
 <1402108770.25112.5.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402108770.25112.5.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 07:39:30PM -0700, Joe Perches wrote:
> On Fri, 2014-06-06 at 21:41 -0400, Pranith Kumar wrote:
> > On 06/06/2014 08:59 PM, Pranith Kumar wrote:
> > > On 06/06/2014 08:18 PM, Dave Chinner wrote:
> > >> If you are going to change the return type to bool, then you should
> > >> also remove the manual "!!" conversions to a boolean return and let
> > >> the compiler do it in the most optimal way.
> > > Agreed, please find patch below:
> > Simplify the "!!" condition. This is much simpler. :)
> []
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> 
> > @@ -285,25 +285,25 @@ xfs_ilock_demote(
> >  }
> >  
> >  #if defined(DEBUG) || defined(XFS_WARN)
> > -int
> > +bool
> >  xfs_isilocked(
> >  	xfs_inode_t		*ip,
> >  	uint			lock_flags)
> >  {
> >  	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> >  		if (!(lock_flags & XFS_ILOCK_SHARED))
> > -			return !!ip->i_lock.mr_writer;
> > +			return (ip->i_lock.mr_writer != 0);
> 
> simpler still would be just removing the !! completely.
> I presume in no case would it make an actual difference
> in emitted code.
> 
> ie:
> 			return ip->i_lock.mr_writer;

Yup, that's exactly what I meant. Casting to a bool type does all
the work of squashing all non-zero values to 1...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
