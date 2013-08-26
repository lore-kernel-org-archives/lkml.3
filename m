Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab3HZTVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 15:21:54 -0400
Received: from mail-ph.de-nserver.de ([85.158.179.214]:41148 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3HZTVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 15:21:52 -0400
X-Fcrdns: No
Message-ID: <521BAACB.4070003@profihost.ag>
Date: Mon, 26 Aug 2013 21:21:47 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: bcache: Fix a writeback performance regression
References: <520C788A.1060208@profihost.ag> <520DFAB4.1050402@profihost.ag> <52114614.4070509@profihost.ag> <20130819222718.GA32104@kmo-pixel> <52132243.8050803@profihost.ag> <521323D1.1070503@profihost.ag> <20130821234715.GA4630@moria.home.lan> <5215A130.9080508@profihost.ag> <20130822054336.GA14935@kmo-pixel> <5215A8A8.90900@profihost.ag> <20130822060215.GB14935@kmo-pixel> <5215BEA4.6040101@profihost.ag>
In-Reply-To: <5215BEA4.6040101@profihost.ag>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,

a new one under 3.10:

2013-08-26 21:05:30     INFO: task ceph-osd:8939 blocked for more than 
120 seconds.
2013-08-26 21:05:30     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2013-08-26 21:05:30     ceph-osd D ffffffff8160f760 0 8939 1 0x00000000
2013-08-26 21:05:30     ffff880bd9a61820 0000000000000086 
ffff880bd9a61fd8 0000000000012c80
2013-08-26 21:05:30     ffff880bd9a60010 0000000000012c80 
0000000000012c80 0000000000012c80
2013-08-26 21:05:30     ffff880bd9a61fd8 0000000000012c80 
ffff880bd7abb1c0 ffff880c48dee380
2013-08-26 21:05:29     [<ffffffff811e8128>] xfs_vm_readpages+0x18/0x20
2013-08-26 21:05:29     [<ffffffff810f1da3>] read_pages+0x43/0x100
2013-08-26 21:05:29     [<ffffffff810e64df>] ? __page_cache_alloc+0x9f/0xc0
2013-08-26 21:05:29     [<ffffffff810f1fab>] 
__do_page_cache_readahead+0x14b/0x160
2013-08-26 21:05:29     [<ffffffff810f1fdc>] ra_submit+0x1c/0x20
2013-08-26 21:05:29     [<ffffffff810f22a5>] ondemand_readahead+0x115/0x240
2013-08-26 21:05:29     [<ffffffff810f249e>] 
page_cache_sync_readahead+0x2e/0x40
2013-08-26 21:05:29     [<ffffffff810e7a5e>] T.1003+0x33e/0x430
2013-08-26 21:05:29     [<ffffffff810e7c30>] 
generic_file_aio_read+0xe0/0x220
2013-08-26 21:05:29     [<ffffffff811efd0a>] xfs_file_aio_read+0x15a/0x2a0
2013-08-26 21:05:29     [<ffffffff8114095a>] do_sync_read+0x7a/0xb0
2013-08-26 21:05:29     [<ffffffff81140df1>] vfs_read+0xb1/0x130
2013-08-26 21:05:29     [<ffffffff81141757>] SyS_pread64+0x97/0xa0
2013-08-26 21:05:29     [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
2013-08-26 21:05:29     INFO: task ceph-osd:8896 blocked for more than 
120 seconds.
2013-08-26 21:05:29     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2013-08-26 21:05:29     ceph-osd D ffffffff8160f760 0 8896 1 0x00000000
2013-08-26 21:05:29     ffff880bd9a9dc28 0000000000000086 
ffff880bd9a9dfd8 0000000000012c80
2013-08-26 21:05:29     ffff880bd9a9c010 0000000000012c80 
0000000000012c80 0000000000012c80
2013-08-26 21:05:29     ffff880bd9a9dfd8 0000000000012c80 
ffff880bd79298e0 ffff880c48dd6380
2013-08-26 21:05:29     Call Trace:
2013-08-26 21:05:29     [<ffffffff810e60f0>] ? __lock_page+0x70/0x70
2013-08-26 21:05:28     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2013-08-26 21:05:28     ceph-osd D ffffffff8160f760 0 8798 1 0x00000000
2013-08-26 21:05:28     ffff880bd998b740 0000000000000086 
ffff880bd998bfd8 0000000000012c80
2013-08-26 21:05:28     ffff880bd998a010 0000000000012c80 
0000000000012c80 0000000000012c80
2013-08-26 21:05:28     ffff880bd998bfd8 0000000000012c80 
ffff880bd99c0000 ffff880c48dd6380
2013-08-26 21:05:28     Call Trace:
2013-08-26 21:05:28     [<ffffffff81524874>] schedule+0x24/0x70
2013-08-26 21:05:28     [<ffffffff81525d7d>] 
rwsem_down_read_failed+0x9d/0xe5
2013-08-26 21:05:28     [<ffffffff812aa0a4>] 
call_rwsem_down_read_failed+0x14/0x30
2013-08-26 21:05:28     [<ffffffff81523a42>] ? down_read+0x12/0x20
2013-08-26 21:05:28     [<ffffffffa01ead62>] btree_read_async+0xa2/0x1a0 
[bcache]
2013-08-26 21:05:28     [<ffffffffa01f7b73>] closure_queue+0x43/0x60 
[bcache]
2013-08-26 21:05:28     [<ffffffffa01eb903>] T.1050+0x63/0x70 [bcache]
2013-08-26 21:05:28     [<ffffffffa01ed6ea>] 
cached_dev_make_request+0x20a/0x350 [bcache]
2013-08-26 21:05:28     [<ffffffff81281952>] generic_make_request+0xc2/0x100
2013-08-26 21:05:28     [<ffffffff812819f7>] submit_bio+0x67/0x130
2013-08-26 21:05:28     [<ffffffff8117b240>] do_mpage_readpage+0x2a0/0x660
2013-08-26 21:05:28     [<ffffffff81101cee>] ? 
__inc_zone_page_state+0x2e/0x30
2013-08-26 21:05:28     [<ffffffff810e6581>] ? 
add_to_page_cache_locked+0x81/0x110
2013-08-26 21:05:28     [<ffffffff8117b76a>] mpage_readpages+0xfa/0x150
2013-08-26 21:05:28     [<ffffffff811e90c0>] ? 
xfs_get_blocks_direct+0x20/0x20
2013-08-26 21:05:28     [<ffffffff811e90c0>] ? 
xfs_get_blocks_direct+0x20/0x20
2013-08-26 21:05:28     [<ffffffff810eeda3>] ? 
__alloc_pages_nodemask+0x123/0x240
2013-08-26 21:05:27     [<ffffffff8115bf93>] ? __close_fd+0x43/0x80
2013-08-26 21:05:27     [<ffffffff8116dabe>] SyS_fdatasync+0xe/0x20
2013-08-26 21:05:27     [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
2013-08-26 21:05:27     INFO: task ceph-osd:8746 blocked for more than 
120 seconds.
2013-08-26 21:05:27     "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2013-08-26 21:05:27     ceph-osd D ffffffff8160f760 0 8746 1 0x00000000
2013-08-26 21:05:27     ffff880c2dde1d38 0000000000000086 
ffff880c2dde1fd8 0000000000012c80
2013-08-26 21:05:27     ffff880c2dde0010 0000000000012c80 
0000000000012c80 0000000000012c80
2013-08-26 21:05:27     ffff880c2dde1fd8 0000000000012c80 
ffff880c239eb1c0 ffff880c48dd6380
2013-08-26 21:05:27     Call Trace:
2013-08-26 21:05:27     [<ffffffff81524874>] schedule+0x24/0x70
2013-08-26 21:05:27     [<ffffffff81522bbd>] schedule_timeout+0x16d/0x200
2013-08-26 21:05:27     [<ffffffff81068eba>] ? 
__queue_delayed_work+0xaa/0x1a0
2013-08-26 21:05:27     [<ffffffff81068d19>] ? 
try_to_grab_pending+0x109/0x190
2013-08-26 21:05:27     [<ffffffff815251e5>] wait_for_completion+0x95/0x110
2013-08-26 21:05:27     [<ffffffff8107fd00>] ? try_to_wake_up+0x2a0/0x2a0
2013-08-26 21:05:27     [<ffffffff81167797>] ? bdi_queue_work+0x77/0xc0
2013-08-26 21:05:27     [<ffffffff81167863>] 
writeback_inodes_sb_nr+0x83/0xb0
2013-08-26 21:05:27     [<ffffffff811678ea>] writeback_inodes_sb+0x5a/0x70
2013-08-26 21:05:27     [<ffffffff8116dd0a>] __sync_filesystem+0x4a/0x50
2013-08-26 21:05:27     [<ffffffff8116dd42>] sync_filesystem+0x32/0x60
2013-08-26 21:05:27     [<ffffffff8116ddc0>] SyS_syncfs+0x50/0x90
2013-08-26 21:05:27     [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
2013-08-26 21:05:27     INFO: task ceph-osd:8798 blocked for more than 
120 seconds.

Stefan

Am 22.08.2013 09:32, schrieb Stefan Priebe - Profihost AG:
> great!
>
> Everything seems to work fine now! Except read_dirty always going to
> negative values after a reboot.
>
> Stefan
>
> Am 22.08.2013 08:02, schrieb Kent Overstreet:
>> On Thu, Aug 22, 2013 at 07:59:04AM +0200, Stefan Priebe wrote:
>>>
>>>> schedule_timeout() is not the same as
>>>> schedule_timeout_interruptible().
>>>
>>> just search and replace? So i can try on my own.
>>
>> The one in read_dirty(), line ~330
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
