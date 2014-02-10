Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaBJKvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:51:52 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:28807 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151AbaBJKvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:51:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoPAHCu+FJ5LGaB/2dsb2JhbABZgww4qTQDkQyFX4EOF3SCJQEBBScTHCMQCAMYCSUPBSUDIROIBMkYFo5nB4Q4AQOYKpIig0Eo
Date: Mon, 10 Feb 2014 21:51:45 +1100
From: Dave Chinner <david@fromorbit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, hch@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com, zab@redhat.com, jack@suse.cz, luto@amacapital.net,
        mszeredi@suse.cz
Subject: Re: [PATCH 00/13] cross rename v4
Message-ID: <20140210105145.GW13997@dastard>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 05:48:58PM +0100, Miklos Szeredi wrote:
> Changes since the last version (based on Al's review):
> 
>  - cross-rename: fix locking of nondirectories for NFSv4
>  - ext4: split cross-rename and plain rename into separate functions
>  - introduce i_op->rename2 with flags, don't touch ->rename
>  - last (optional) patch to merge ->rename2 back into ->rename
> 
> The splitting of the ext4 implemetation was indeed a good idea as it uncovered a
> memory leak and small inconsistencies with the merged implementation.
> 
> Splitting out rename2 will lessen the code churn, but I think is ugly.  However
> this is a question of taste, last patch can be ommitted without loss of
> functionality.
> 
> Bruce, could you please review the locking and delegation thing in patch #8
> "vfs: add cross-rename"?
> 
> Git tree is here:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git cross-rename

Miklos, can you please write an xfstest for this new API? That way
we can verify that the behaviour is as documented, and we can ensure
that when we implement it on other filesystems it works exactly the
same on all filesystems?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
