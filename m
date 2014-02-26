Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaBZA2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:28:18 -0500
Received: from mailout11.t-online.de ([194.25.134.85]:38024 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBZA2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:28:16 -0500
X-Greylist: delayed 948 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Feb 2014 19:28:16 EST
Message-ID: <530D3165.8070501@t-online.de>
Date: Wed, 26 Feb 2014 01:12:21 +0100
From: Michael Mueller <malware@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Neil Brown <neilb@suse.de>
Subject: 3.14-rc4 blocks on LVM init
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: bjJEXoZLZhXkFbTLbYAozyRyE1AxotfqXGqfXchP0iRffvX0FW1pPCKZwoX3zt6wGI@t-dialin.net
X-TOI-MSGID: 05a3807b-1c82-4514-978b-264456068efd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with 3.14-rc4 my box does not finish initializing the LVM array. It 
hangs within the call to rw_header() on line 632 of dm-log.c. See 
backtrace at end. Please excuse typos within - had to type it from a 
screen shot.

The problem seems to be introduced by the commit 
003b5c5719f159f4f4bf97511c4702a0638313dd (block: Convert drivers to 
immutable biovecs).


Michael


INFO: task lvm:976 blocked for more than 120 seconds.
       Not tainted 3.14.0-rc4+ #5
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
lvm             D ffff8802110c0e48     0   976    947 0x00000000
  ffff8802110c0a30 0000000000000082 0000000000014300 0000000000014300
  ffff880212f7bfd8 ffff8802110c0a30 ffff88021dcd4b88 ffff880212f7bbc0
  0000000000000000 0000000000000001 ffffffffa016da40 0000000000000131
Call Trace:
  [<ffffffffa016da40>] ? table_load+0x330/0x330 [dm_mod]
  [<ffffffff814b0844>] ? io_schedule+0x94/0x130
  [<ffffffffa016f3c5>] ? sync_io+0x95/0x120 [dm_mod]
  [<ffffffff810b43d0>] ? dyntick_save_progress_counter+0x20/0x20
  [<ffffffff814b0900>] ? _cond_resched+0x20/0x40
  [<ffffffff814b0e5f>] ? wait_for_completion+0x1f/0x110
  [<ffffffffa016f62e>] ? dm_io+0x1de/0x210 [dm_mod]
  [<ffffffffa016ef50>] ? bio_next_page+0x30/0x30 [dm_mod]
  [<ffffffffa016edc0>] ? bio_get_page+0x40/0x40 [dm_mod]
  [<ffffffffa016da40>] ? table_load+0x330/0x330 [dm_mod]
  [<ffffffffa01f884a>] ? disk_resume+0x14a/0x2d0 [dm_log]
  [<ffffffff8105f03e>] ? put_online_cpus+0x1e/0x80
  [<ffffffffa0168bad>] ? dm_swap_table+0x3d/0x300 [dm_mod]
  [<ffffffffa01fe3e9>] ? mirror_resume+0x29/0x50 [dm_mirror]
  [<ffffffffa016b365>] ? dm_table_resume_targets+0x85/0xd0 [dm_mod]
  [<ffffffffa0169082>] ? dm_resume+0x32/0xe0 [dm_mod]
  [<ffffffffa016db63>] ? dev_suspend+0x123/0x220 [dm_mod]
  [<ffffffffa016e38d>] ? ctl_ioctl+0x1ed/0x420 [dm_mod]
  [<ffffffffa016e5ca>] ? dm_ctl_ioctl+0xa/0x10 [dm_mod]
  [<ffffffff8119366f>] ? do_vfs_ioctl+0x2cf/0x4b0
  [<ffffffff811f9878>] ? ipcget+0x138/0x1c0
  [<ffffffff811938d0>] ? SyS_ioctl+0x80/0xa0
  [<ffffffff811fd9e1>] ? SyS_semctl+0x1e1/0x270
  [<ffffffff814bb6b9>] ? system_call_fastpath+0x16/0x1b

