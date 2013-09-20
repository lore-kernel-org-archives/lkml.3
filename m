Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3ITI2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 04:28:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab3ITI2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:28:11 -0400
Date: Fri, 20 Sep 2013 09:28:07 +0100
From: Mel Gorman <mgorman@suse.de>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Kent Overstreet <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix a regression where MS_SNAP_STABLE (stable pages
 snapshotting) was ignored
Message-ID: <20130920082807.GW22421@suse.de>
References: <20130920030602.GC4565@birch.djwong.org>
 <20130920080637.GV22421@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130920080637.GV22421@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 09:06:37AM +0100, Mel Gorman wrote:
> On Thu, Sep 19, 2013 at 08:06:02PM -0700, Darrick J. Wong wrote:
> > The "force" parameter in __blk_queue_bounce was being ignored, which means that
> > stable page snapshots are not always happening (on ext3).  This of course
> > leads to DIF disks reporting checksum errors, so fix this regression.
> > 
> > The regression was introduced in commit 6bc454d1 (bounce: Refactor
> > __blk_queue_bounce to not use bi_io_vec)
> > 
> > Reported-by: Mel Gorman <mgorman@suse.de>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I have no means of testing it but it looks right and thanks for checking
> DIF disks.
> 
> Acked-by: Mel Gorman <mgorman@suse.de>
> 

That said the two checks are now redundant. They could just be deleted
and depend entirely on the following check within the loop

                if (page_to_pfn(page) <= queue_bounce_pfn(q) && !force)
                        continue;

with an update to the comment explaining that the check is for pages
below the bounce pfn or for bios that require stable writes

-- 
Mel Gorman
SUSE Labs
