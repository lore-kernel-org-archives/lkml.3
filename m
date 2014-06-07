Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaFGCjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 22:39:36 -0400
Received: from smtprelay0075.hostedemail.com ([216.40.44.75]:42364 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752299AbaFGCje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 22:39:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3873:4321:5007:6120:7652:8531:10004:10400:10848:11026:11232:11473:11658:11914:12043:12295:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trick82_70662c2063f39
X-Filterd-Recvd-Size: 2124
Message-ID: <1402108770.25112.5.camel@joe-AO725>
Subject: Re: [RFC PATCH 1/1] cleanup: use bool as return type for
 rwsem_is_locked
From: Joe Perches <joe@perches.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Pranith Kumar <pranith@gatech.edu>,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        tim.c.chen@linux.intel.com, davidlohr@hp.com, mingo@redhat.com,
        xfs@oss.sgi.com
Date: Fri, 06 Jun 2014 19:39:30 -0700
In-Reply-To: <53926DC1.4050304@gmail.com>
References: <5390D7E1.7060606@gatech.edu> <5391FFFD.1060901@gatech.edu>
	 <53920446.7060505@gatech.edu> <20140607001819.GE4453@dastard>
	 <53926406.4020200@gmail.com> <53926DC1.4050304@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 21:41 -0400, Pranith Kumar wrote:
> On 06/06/2014 08:59 PM, Pranith Kumar wrote:
> > On 06/06/2014 08:18 PM, Dave Chinner wrote:
> >> If you are going to change the return type to bool, then you should
> >> also remove the manual "!!" conversions to a boolean return and let
> >> the compiler do it in the most optimal way.
> > Agreed, please find patch below:
> Simplify the "!!" condition. This is much simpler. :)
[]
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c

> @@ -285,25 +285,25 @@ xfs_ilock_demote(
>  }
>  
>  #if defined(DEBUG) || defined(XFS_WARN)
> -int
> +bool
>  xfs_isilocked(
>  	xfs_inode_t		*ip,
>  	uint			lock_flags)
>  {
>  	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
>  		if (!(lock_flags & XFS_ILOCK_SHARED))
> -			return !!ip->i_lock.mr_writer;
> +			return (ip->i_lock.mr_writer != 0);

simpler still would be just removing the !! completely.
I presume in no case would it make an actual difference
in emitted code.

ie:
			return ip->i_lock.mr_writer;


