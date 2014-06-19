Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbaFSQVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:21:48 -0400
Received: from imap.thunk.org ([74.207.234.97]:47927 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213AbaFSQVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:21:47 -0400
Date: Thu, 19 Jun 2014 12:21:44 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: BUG: scheduling while atomic in blk_mq codepath?
Message-ID: <20140619162144.GC4907@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Jens Axboe <axboe@fb.com>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20140619153550.GA12836@thunk.org>
 <53A308DE.7080000@fb.com>
 <20140619160801.GB4907@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619160801.GB4907@thunk.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 12:08:01PM -0400, Theodore Ts'o wrote:
> > The other issue, not sure, not a lot of detail. It may be fixed by the pull
> > request I sent out yesterday. You can try pulling in:
> > 
> > git://git.kernel.dk/linux-block.git for-linus
> 
> Thanks, I'll give that a try.

I tried merging in your for-linus branch in v3.16-rc1, and I'm seeing
the following.  On a 32-bit x86 3.15 kernel, run: "mke2fs -t ext3
/dev/vdc" where /dev/vdc is a 5 gig virtio partition.

The boot 3.16-rc1 with linux-block.git's for_linus branch merged in.
(Or 3.16-rc1 by itself):

root@candygram:~# e2fsck -fy /dev/vdc
e2fsck 1.43-WIP (4-Feb-2014)
Pass 1: Checking inodes, blocks, and sizes
[   22.872217] random: nonblocking pool is initialized
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Error reading block 262144 (Attempt to read block from filesystem resulted in short read) while reading inode and block bitmaps.  Ignore error? yes

Force rewrite? yes

Block bitmap differences:  +(262144--262657)
Fix? yes


/dev/vdc: ***** FILE SYSTEM WAS MODIFIED *****
/dev/vdc: 11/327680 files (0.0% non-contiguous), 55935/1310720 blocks

With the 3.15 kernel, this works fine.

						- Ted
