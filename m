Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761884Ab3DBJyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:54:03 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40161
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759586Ab3DBJyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:54:00 -0400
Date: Tue, 2 Apr 2013 11:53:53 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Fengguang Wu <fengguang.wu@intel.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [GIT PULL] writeback: convert writeback to unbound workqueue
Message-ID: <20130402095353.GB4667@kernel.dk>
References: <20130402030933.GB6255@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402030933.GB6255@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01 2013, Tejun Heo wrote:
> Hello, Jens.
> 
> This is the pull request for the earlier patchset[1] with the same
> name.  It's only three patches (the first one was committed to
> workqueue tree) but the merge strategy is a bit involved due to the
> dependencies.
> 
> * Because the conversion needs features from wq/for-3.10,
>   block/for-3.10/core is based on rc3, and wq/for-3.10 has conflicts
>   with rc3, I pulled mainline (rc5) into wq/for-3.10 to prevent those
>   workqueue conflicts from flaring up in block tree.
> 
> * Resolving the issue that Jan and Dave raised about debugging
>   requires arch-wide changes.  The patchset is being worked on[2] but
>   it'll have to go through -mm after these changes show up in -next,
>   and not included in this pull request.
> 
> The three commits are located in the following git branch.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git writeback-workqueue
> 
> Pulling it into block/for-3.10/core produces a conflict in
> drivers/md/raid5.c between the following two commits.
> 
>   e3620a3ad5 ("MD RAID5: Avoid accessing gendisk or queue structs when not available")
>   2f6db2a707 ("raid5: use bio_reset()")
> 
> The conflict is trivial - one removes an "if ()" conditional while the
> other removes "rbi->bi_next = NULL" right above it.  We just need to
> remove both.  The merged branch is available at
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git block-test-merge
> 
> so that you can use it for verification.  The test merge commit has
> proper merge description.
> 
> While these changes are a bit of pain to route, they make code simpler
> and even have, while minute, measureable performance gain[3] even on a
> workload which isn't particularly favorable to showing the benefits of
> this conversion.

Thanks, pulled in for testing. We'll need the debug change in before
sending this upstream, though. I agree with Jan/Dave that this is
required functionality, for debugging purposes.

-- 
Jens Axboe

