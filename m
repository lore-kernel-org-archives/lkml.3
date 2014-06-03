Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbaFCO0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:26:00 -0400
Received: from imap.thunk.org ([74.207.234.97]:47936 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932692AbaFCOZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:25:57 -0400
Date: Tue, 3 Jun 2014 10:25:21 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Daniel Phillips <daniel@phunq.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
Message-ID: <20140603142521.GA12890@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>,
	Daniel Phillips <daniel@phunq.net>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jens Axboe <axboe@kernel.dk>
References: <538B9DEE.20800@phunq.net>
 <20140602031526.GS14410@dastard>
 <538CD855.90804@phunq.net>
 <20140603033322.GA14410@dastard>
 <538D72B7.3010700@phunq.net>
 <20140603075209.GD14410@dastard>
 <20140603140531.GB30706@quack.suse.cz>
 <20140603141444.GA21273@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603141444.GA21273@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 07:14:44AM -0700, Christoph Hellwig wrote:
> Honestly I think doing per-bdi writeback has been a major mistake.  As
> you said it only even matters when we have filesystems on multiple
> partitions on a single device, and even then only in a simple setup,
> as soon as we use LVM or btrfs this sort of sharing stops to happen
> anyway.  I don't even see much of a benefit except that we prevent
> two flushing daemons to congest a single device for that special case
> of multiple filesystems on partitions of the same device, and that could
> be solved in other ways.

To be fair, back when per-bdi writeback was introduced, having
multiple partitions on a single disk was far more common, and the use
of LVM was much less common.  These days, many more systems using one
big root filesystem, and or using flash where the parallel writes can
actually be a good thing (since there isn't a single disk head which
has to seek all over the HDD), the case for keeping per-bdi writeback
is much weaker, if not non-existent.

Cheers,

					- Ted
