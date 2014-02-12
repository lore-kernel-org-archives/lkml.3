Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbaBLDlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 22:41:15 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40165 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaBLDlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 22:41:14 -0500
Date: Tue, 11 Feb 2014 20:41:09 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, joern@logfs.org, logfs@logfs.org
Subject: Re: [null_blk] INFO: trying to register non-static key.
Message-ID: <20140212034109.GB9739@kernel.dk>
References: <20140212024728.GA10263@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212024728.GA10263@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12 2014, Fengguang Wu wrote:
> Hi Jens,
> 
> I got the below dmesg and the first bad commit is
> 
> commit f2298c0403b0dfcaef637eba0c02c4a06d7a25ab
> Author:     Jens Axboe <axboe@kernel.dk>
> CommitDate: Fri Oct 25 11:56:00 2013 +0100

Hmm dunno, the below looks more like a logfs issue, given the calltrace.
The fact that null_blk is the device used is probably less interesting.

> [   18.158432] VFS: could not find a valid V7 on nullb0.
> [   18.159280] LogFS: Start mount 1
> [   18.159732] LogFS: Start unmounting
> [   18.160368] INFO: trying to register non-static key.
> [   18.160986] the code is fine but needs lockdep annotation.
> [   18.161675] turning off the locking correctness validator.
> [   18.162341] CPU: 0 PID: 634 Comm: mount Not tainted 3.14.0-rc2-wl-01363-gf8a1366 #2
> [   18.163266]  0000000000000000 ffff88000b839c00 ffffffff827922a5 ffff88000b839cb8
> [   18.163516]  ffffffff810c0202 ffff88000bac1008 ffff88000b839c98 ffff88000b839c58
> [   18.163516]  0000000000000002 ffff88000bb4f000 ffff880000000000 ffffffff00000001
> [   18.163516] Call Trace:
> [   18.163516]  [<ffffffff827922a5>] dump_stack+0x19/0x1b
> [   18.163516]  [<ffffffff810c0202>] __lock_acquire+0x252/0x1d80
> [   18.163516]  [<ffffffff8115cc10>] ? writeback_inodes_sb_nr+0xc0/0xe0
> [   18.163516]  [<ffffffff81296146>] ? logfs_get_wblocks+0x76/0x90
> [   18.163516]  [<ffffffff810c2590>] lock_acquire+0x70/0x90
> [   18.163516]  [<ffffffff81296146>] ? logfs_get_wblocks+0x76/0x90
> [   18.163516]  [<ffffffff827a26f1>] mutex_lock_nested+0x61/0x380
> [   18.163516]  [<ffffffff81296146>] ? logfs_get_wblocks+0x76/0x90
> [   18.163516]  [<ffffffff81296146>] logfs_get_wblocks+0x76/0x90
> [   18.163516]  [<ffffffff81293024>] logfs_sync_fs+0x14/0x30
> [   18.163516]  [<ffffffff81160929>] sync_filesystem+0x59/0xb0
> [   18.163516]  [<ffffffff8129a327>] logfs_kill_sb+0x27/0xf0
> [   18.163516]  [<ffffffff81137afd>] deactivate_locked_super+0x2d/0x50
> [   18.163516]  [<ffffffff8129b1f3>] logfs_mount+0x763/0x7e0
> [   18.163516]  [<ffffffff811391d0>] mount_fs+0x10/0xe0
> [   18.163516]  [<ffffffff81153f49>] vfs_kern_mount+0x69/0x140
> [   18.163516]  [<ffffffff827a5efc>] ? _raw_read_unlock+0x2c/0x50
> [   18.163516]  [<ffffffff81156354>] do_mount+0x934/0xb90
> [   18.163516]  [<ffffffff81111462>] ? might_fault+0x52/0xb0
> [   18.163516]  [<ffffffff811040a5>] ? strndup_user+0x35/0x50
> [   18.163516]  [<ffffffff811568fc>] SyS_mount+0x8c/0xd0
> [   18.163516]  [<ffffffff827a713b>] system_call_fastpath+0x1a/0x1f

-- 
Jens Axboe

