Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab3CZTz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:55:28 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:59862 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759943Ab3CZTz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:55:26 -0400
Date: Tue, 26 Mar 2013 12:55:23 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree (akpm
 and block tree related)
Message-ID: <20130326195523.GB24935@google.com>
References: <20130326170554.f9f113fa24a1e5ec6d5d1ee6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326170554.f9f113fa24a1e5ec6d5d1ee6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 05:05:54PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build
> produced this warning:
> 
> fs/bio.c: In function 'submit_bio_wait':
> fs/bio.c:786:17: warning: assignment from incompatible pointer type [enabled by default]
> 
> This is due to an interaction between commit 9e882242c ("block: Add
> submit_bio_wait(), remove from md") from the block tree and commit
> "block: prep work for batch completion" from the akpm tree.

In hindsight maybe it would've been better if the batch completion stuff
had gone in via Jens' tree, though I'm sure there would've still been
some conflicts.

What's the procedure for me to fix these? I can send you a fixup patch
but if you've pushed this version of linux-next somewhere public I'm not
sure where to look.

> 
> In fact we are getting several more warnings due to that patch in the
> akpm tree:
> 
> drivers/md/bcache/writeback.c: In function 'write_dirty':
> drivers/md/bcache/writeback.c:276:20: warning: assignment from incompatible pointer type [enabled by default]
> drivers/md/bcache/writeback.c: In function 'read_dirty':
> drivers/md/bcache/writeback.c:350:21: warning: assignment from incompatible pointer type [enabled by default]
> drivers/md/bcache/movinggc.c: In function 'read_moving':
> drivers/md/bcache/movinggc.c:160:18: warning: assignment from incompatible pointer type [enabled by default]
> drivers/md/bcache/request.c: In function 'bch_insert_data_loop':
> drivers/md/bcache/request.c:518:16: warning: assignment from incompatible pointer type [enabled by default]
> drivers/md/bcache/request.c: In function 'do_bio_hook':
> drivers/md/bcache/request.c:684:18: warning: assignment from incompatible pointer type [enabled by default]
> drivers/md/bcache/request.c: In function 'cached_dev_cache_miss':
> drivers/md/bcache/request.c:926:19: warning: assignment from incompatible pointer type [enabled by default]
> drivers/md/bcache/request.c:957:29: warning: assignment from incompatible pointer type [enabled by default]
> drivers/md/bcache/debug.c: In function 'bch_data_verify':
> drivers/md/bcache/debug.c:208:19: warning: assignment from incompatible pointer type [enabled by default]
> drivers/md/bcache/super.c: In function 'bch_write_bdev_super':
> drivers/md/bcache/super.c:257:17: warning: assignment from incompatible pointer type [enabled by default]
> drivers/md/bcache/super.c: In function 'bcache_write_super':
> drivers/md/bcache/super.c:295:18: warning: assignment from incompatible pointer type [enabled by default]
> drivers/md/bcache/super.c: In function 'uuid_io':
> drivers/md/bcache/super.c:333:18: warning: assignment from incompatible pointer type [enabled by default]
> drivers/md/bcache/super.c: In function 'prio_io':
> drivers/md/bcache/super.c:492:17: warning: assignment from incompatible pointer type [enabled by default]
> 
> There are probably more ...
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


