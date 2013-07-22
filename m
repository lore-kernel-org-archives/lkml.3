Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab3GVPsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:48:22 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:42369 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab3GVPsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:48:21 -0400
From: Fabio Coatti <fabio.coatti@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 3.10.2 Trace: Freezing of tasks failed
Date: Mon, 22 Jul 2013 17:48:16 +0200
Message-ID: <2218989.ZIPS7tkB8B@calvin>
User-Agent: KMail/4.10.5 (Linux/3.10.2; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I just installed 3.10.2 and I started to see this kind of messages:
===============================================
[lun lug 22 15:45:28 2013] PM: Syncing filesystems ... done.
[lun lug 22 15:45:28 2013] Freezing user space processes ... 
[lun lug 22 15:45:48 2013] Freezing of tasks failed after 20.00 seconds (1 
tasks refusing to freeze, wq_busy=0):
[lun lug 22 15:45:48 2013] mc              D ffff8801a24adf80     0 16470  
30425 0x00000004
[lun lug 22 15:45:48 2013]  ffff8801a24adb80 0000000000000002 0000000000000000 
ffff880233732dc0
[lun lug 22 15:45:48 2013]  ffff8801580c9fd8 0000000000011f00 ffff8801580c9fd8 
ffff8801a24adb80
[lun lug 22 15:45:48 2013]  000000000000000e 000000000000000e ffffea0002871b80 
0000000000000001
[lun lug 22 15:45:48 2013] Call Trace:
[lun lug 22 15:45:48 2013]  [<ffffffff810dfd7b>] ? cgroup_freezing+0x20/0x25
[lun lug 22 15:45:48 2013]  [<ffffffff810c7698>] ? 
freezing_slow_path+0x20/0x41
[lun lug 22 15:45:48 2013]  [<ffffffff8109c388>] ? recalc_sigpending+0x3b/0x41
[lun lug 22 15:45:48 2013]  [<ffffffff8109cc02>] ? 
__set_task_blocked+0x5d/0x64
[lun lug 22 15:45:48 2013]  [<ffffffff8109ea3b>] ? 
__set_current_blocked+0x2d/0x43
[lun lug 22 15:45:48 2013]  [<ffffffffa003ac0a>] ? 
__fuse_request_send+0x1c4/0x282 [fuse]
[lun lug 22 15:45:48 2013]  [<ffffffff810aa934>] ? 
abort_exclusive_wait+0x79/0x79
[lun lug 22 15:45:48 2013]  [<ffffffffa003f121>] ? fuse_send_write+0x10e/0x121 
[fuse]
[lun lug 22 15:45:48 2013]  [<ffffffffa0040876>] ? 
fuse_perform_write+0x303/0x40f [fuse]
[lun lug 22 15:45:48 2013]  [<ffffffffa0040bd0>] ? 
fuse_file_aio_write+0x24e/0x297 [fuse]
[lun lug 22 15:45:48 2013]  [<ffffffff81139f3f>] ? do_sync_write+0x69/0x8c
[lun lug 22 15:45:48 2013]  [<ffffffff810b562b>] ? get_vtime_delta+0xd/0x59
[lun lug 22 15:45:48 2013]  [<ffffffff8113a930>] ? vfs_write+0xbd/0x162
[lun lug 22 15:45:48 2013]  [<ffffffff8113ac9d>] ? SyS_write+0x45/0x77
[lun lug 22 15:45:48 2013]  [<ffffffff81700991>] ? tracesys+0xd4/0xd9

[lun lug 22 15:45:48 2013] Restarting tasks ... done.
[lun lug 22 15:45:48 2013] video LNXVIDEO:01: Restoring backlight state
===============================================

Machine:

Linux calvin 3.10.2 #1 SMP PREEMPT Mon Jul 22 13:41:43 CEST 2013 x86_64 
Intel(R) Core(TM) i5-3427U CPU @ 1.80GHz GenuineIntel GNU/Linux
gcc (Gentoo 4.7.3 p1.0, pie-0.5.5) 4.7.3

I didn't dug into details yet (for lack of time, sorry, maybe later) but if 
more info are needed just let me know (CC: me as I'm not on mailing list)

--
Fabio
