Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab3GPA13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:27:29 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:8024 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755368Ab3GPA11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:27:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4NALCS5FF5LK4r/2dsb2JhbABagwa9KIEihA4EAYERF3SCIwEBBTocMwgDGAkaCw8FJQMhARKID7ZNFo4xgSSDC20Dl1uKI4crgVmBSyo
Date: Tue, 16 Jul 2013 10:27:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file:
 fs/xfs/xfs_dir2_sf.c, line: 358
Message-ID: <20130716002703.GB3920@dastard>
References: <20130712023930.GA6473@redhat.com>
 <20130713020030.GG3438@dastard>
 <20130715195800.GD1706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715195800.GD1706@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 03:58:00PM -0400, Dave Jones wrote:
> On Sat, Jul 13, 2013 at 12:00:30PM +1000, Dave Chinner wrote:
>  
>  > > [   97.162665] XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file: fs/xfs/xfs_dir2_sf.c, line: 358
>  > ....
>  > 
>  > So, it's not clear what has caused this yet. Is it reproducable?
> 
> Just hit it again on the same machine.
> 
>  > would be good to get a trace of lookup vs addname events from XFS,
>  > too (i.e. all the xfs_dir* and xfs_da* events) so we can see if the
>  > correct lookups were done prior to the failing addname operation...
>  
> <- xfs tracing noob. Got a recipe I can cut-n-paste ?
> Or a patch if that's necessary..

Just use your usual method of pulling tracepoints out of the kernel,
be it with perf or (my preferred method) trace-cmd:

# trace-cmd record -e xfs_dir\* -e xfs_da\* <command that dies>
....
# trace-cmd report > trace.report.out

The trace.report.out file is what I'd like to see. The report file
could be large, so compressing it might be an idea...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
