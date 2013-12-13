Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab3LMK6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:58:16 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:5122 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568Ab3LMK6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:58:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwRAAjnqlJ5LHyk/2dsb2JhbABZgwo4gwShJwOPOYVPgR8XdIIlAQEFOhwjEAgDDgoJJQ8FJQMhE4gDwwkXFo8AB4Q2BJgUikyHSYM+KA
Date: Fri, 13 Dec 2013 21:58:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [HANG 3.13-rc3] blk-mq/virtio: mkfs.ext4 hangs in
 blk_mq_wait_for_tags
Message-ID: <20131213105811.GT10988@dastard>
References: <20131209223905.GU31386@dastard>
 <CACVXFVNLqEQpoKPS-r9Lj_hJek5FnCGMagkMt+LUUxt8c3XCbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNLqEQpoKPS-r9Lj_hJek5FnCGMagkMt+LUUxt8c3XCbA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 09:57:48AM +0800, Ming Lei wrote:
> On Tue, Dec 10, 2013 at 6:39 AM, Dave Chinner <david@fromorbit.com> wrote:
> > Hi Jens,
> >
> > Another day, another blkmq/virtio problem. Running mkfs.ext4 on a
> > sparse 100TB VM file image, it hangs hard while writing superblock
> > information:
> >
> > $ tests/fsmark-50-test-ext4.sh
> > mke2fs 1.43-WIP (20-Jun-2013)
> > Filesystem label=
> > OS type: Linux
> > Block size=4096 (log=2)
> > Fragment size=4096 (log=2)
> > Stride=0 blocks, Stripe width=0 blocks
> > 1677721600 inodes, 26843545600 blocks
> > 1342177280 blocks (5.00%) reserved for the super user
> > First data block=0
> > 819200 block groups
> > 32768 blocks per group, 32768 fragments per group
> > 2048 inodes per group
> > Superblock backups stored on blocks:
> >         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
> >         4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
> >         102400000, 214990848, 512000000, 550731776, 644972544, 1934917632,
> >         2560000000, 3855122432, 5804752896, 12800000000, 17414258688
> >
> > Allocating group tables: done
> > Writing inode tables: done
> > Creating journal (32768 blocks): done
> > Writing superblocks and filesystem accounting information:
> >
> > It writes a few superblocks, then hangs. Immediately after it stops
> > updating that last line, I see this:
> >
> > root@test4:~# echo w > /proc/sysrq-trigger
> 
> It might be helpful to do below and post the result before the sysrq-trigger:
> 
>          cat    /sys/class/block/vda/mq/0/tags

I would, but for some reason I can't reproduce it now. I'm running a
slightly more recent kernel than a few days ago, and it isn't
hanging now....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
