Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaB1Ari (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 19:47:38 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:26602 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaB1Arg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 19:47:36 -0500
X-AuditID: cbfee690-b7f266d00000287c-0a-530fdca4cef8
Message-id: <1393548357.4705.75.camel@kjgkr>
Subject: [BUG] deadlock on rename_lock
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Al Viro <viro@ZenIV.linux.org.uk>, Waiman Long <Waiman.Long@hp.com>
Cc: "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>
Date: Fri, 28 Feb 2014 09:45:57 +0900
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t8zfd0ld/iDDSYsk7S4vGsOm8X5v8dZ
	LR6esnVg9ti1bSeTx+dNch6bnrxlCmCO4rJJSc3JLEst0rdL4Mpo/1lTsFO/Ytak/ewNjFvU
	uxg5OCQETCRenLLrYuQEMsUkLtxbz9bFyMUhJLCMUeLqsQ3MEAkTiS1TTzBCJKYzSnzcegWq
	6hWjxM0pV1hBqngFdCRu/LnLBGILC6hJfHu4ixFkA5uAtsTm/QYgYSEBRYm3+++ClYsIuEsc
	37qCHcRmFrCXmLv2IwuIzSKgKvFx6UpGEJtfQFTi8MLtzBA16hKT5i2COkhJYnd7J1SvvMTm
	NW+ZIU4QlPgx+R4LyG0SAovYJRqnT4YaKiDxbfIhFoiPZSU2HYCaIylxcMUNlgmMYrOQrJiF
	ZOwsJGMXMDKvYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAiJmgk7GO8dsD7EmAy0ciKzlGhy
	PjDq8kriDY3NjCxMTUyNjcwtzUgTVhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	UTuHZe2ND+s+bRU//dAsdcLnqM8+Z5wkNgk+uvjeli//CzND5dNT/63kja54bT8n37Tnwyz+
	19Xv9oc4/17WFcU6KcK9Orgu/dSyhTnbed1crBP+n2KKlhP1OLz3RPcDFU6BR0ucOcyvbZo0
	deLhitAXh2+GcRtqza0QP3hP9aJ09IRH+67wbFViKc5INNRiLipOBACo8vCCsAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQd0ld/iDDZ7fE7G4vGsOm8X5v8dZ
	LR6esnVg9ti1bSeTx+dNch6bnrxlCmCOamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDU
	NbS0MFdSyEvMTbVVcvEJ0HXLzAFapKRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfI
	AA0krGPMaP9ZU7BTv2LWpP3sDYxb1LsYOTkkBEwktkw9wQhhi0lcuLeerYuRi0NIYDqjxMet
	V6CcV4wSN6dcYQWp4hXQkbjx5y4TiC0soCbx7eEuoG4ODjYBbYnN+w1AwkICihJv998FKxcR
	cJc4vnUFO4jNLGAvMXftRxYQm0VAVeLj0pVgi/kFRCUOL9zODFGjLjFp3iJmiIOUJHa3d0L1
	yktsXvOWGeIEQYkfk++xTGAUmIWkZRaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vO
	z93ECI7KZ1I7GFc2WBxiFOBgVOLhneDJHyzEmlhWXJl7iFGCg1lJhNd3DlCINyWxsiq1KD++
	qDQntfgQYzLQFxOZpUST84EJI68k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakF
	qUUwW5g4OKUaGA+blkf2316f4/CIodq5WvmoKNPeTv+be+4+kJcv+f0/8aS48BylwP/WBgxe
	h9+4/OjLPLJxmvfs262TbDcbeOV7RV677pcwv0C39neQdsOB0sgkD9WM+M//XpR0Tj178u3B
	jeU1bt1Xz+effDijQXnjk3kXme4uOJJ5e9mC+1+c8nW3M+29Uq7EUpyRaKjFXFScCAB/e8np
	DgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

In the following configuration, I met a deadlock condition like below.

Kernel: 3.14-rc3
Workload: fsstress with 10 threads
Reproducible scenario: N/A

Is it related to this patch?
commit 1370e97bb2eb1ef2df7355204e5a4ba13e12b861
Author: Waiman Long <Waiman.Long@hp.com>
Date:   Thu Sep 12 10:55:34 2013 -0400

    seqlock: Add a new locking reader type 

In d_walk(),
                /*   
                 * might go back up the wrong parent if we have had a
rename
                 * or deletion
                 */
                if (this_parent != child->d_parent ||
                         (child->d_flags & DCACHE_DENTRY_KILLED) ||

--> I suspect that the upper conditions can trigger rename_retry even
though rename_retry was done once before.

                         need_seqretry(&rename_lock, seq)) {
                        spin_unlock(&this_parent->d_lock);
                        rcu_read_unlock();
                        goto rename_retry;
                }    

Thanks,

=============================================
[ INFO: possible recursive locking detected ]
3.14.0-rc3.f2fs+ #10 Tainted: G           O
---------------------------------------------
fsstress/10709 is trying to acquire lock:
 (rename_lock){+.+...}, at: [<ffffffff811cdfbd>] d_walk+0x4d/0x3c0
 
but task is already holding lock:
 (rename_lock){+.+...}, at: [<ffffffff811cdfbd>] d_walk+0x4d/0x3c0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(rename_lock);
  lock(rename_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by fsstress/10709:
 #0:  (sb_writers#11){.+.+.+}, at: [<ffffffff811d84d4>] mnt_want_write
+0x24/0x50
 #1:  (&type->i_mutex_dir_key#3/1){+.+.+.}, at: [<ffffffff811c4c44>]
do_rmdir+0x134/0x1f0
 #2:  (&type->i_mutex_dir_key#3){+.+.+.}, at: [<ffffffff811c4a47>]
vfs_rmdir+0x57/0x120
 #3:  (rename_lock){+.+...}, at: [<ffffffff811cdfbd>] d_walk+0x4d/0x3c0

stack backtrace:
CPU: 3 PID: 10709 Comm: fsstress Tainted: G           O 3.14.0-rc3.f2fs+
#10
Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z77
Extreme4, BIOS P2.30 09/21/2012
 ffffffff82173620 ffff88002b1f1bc8 ffffffff81719b27 0000000000000007
 ffffffff82173620 ffff88002b1f1cc8 ffffffff810a72f5 ffff88002b1f1bf8
 0000000000021810 ffff880036cb8000 0000000000000000 ffff88002b1f1d48
Call Trace:
 [<ffffffff81719b27>] dump_stack+0x4e/0x68
 [<ffffffff810a72f5>] __lock_acquire+0x715/0x1e20
 [<ffffffff810c59d8>] ? rcu_irq_exit+0x68/0xb0  
 [<ffffffff81726ddc>] ? retint_restore_args+0xe/0xe
 [<ffffffff810a905e>] lock_acquire+0x8e/0x110
 [<ffffffff811cdfbd>] ? d_walk+0x4d/0x3c0
 [<ffffffff811ce230>] ? d_walk+0x2c0/0x3c0
 [<ffffffff811cd190>] ? umount_collect+0x130/0x130
 [<ffffffff81725d7e>] _raw_spin_lock+0x3e/0x80  
 [<ffffffff811cdfbd>] ? d_walk+0x4d/0x3c0
 [<ffffffff811cdfbd>] d_walk+0x4d/0x3c0
 [<ffffffff811ce081>] ? d_walk+0x111/0x3c0
 [<ffffffff811cd190>] ? umount_collect+0x130/0x130
 [<ffffffff811ce8a8>] shrink_dcache_parent+0x68/0x80
 [<ffffffff811c4a97>] vfs_rmdir+0xa7/0x120
 [<ffffffff813365c9>] ? apparmor_path_rmdir+0x19/0x20 
 [<ffffffff811c4cd3>] do_rmdir+0x1c3/0x1f0
 [<ffffffff81388bbe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff811c80e6>] SyS_rmdir+0x16/0x20
 [<ffffffff8172fb12>] system_call_fastpath+0x16/0x1b
BUG: soft lockup - CPU#0 stuck for 22s! [fsstress:10715]
Modules linked in: f2fs(O) snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep i915 snd_pcm
snd_timer drm_kms_helper psmouse drm snd serio_raw soundcore
i2c_algo_bit lpc_ich mac_hid mxm_wmi tpm_tis video wmi lp parport tg3
ptp pps_core [last unloaded: f2fs]
irq event stamp: 11620621
hardirqs last  enabled at (11620621): [<ffffffff810a557d>]
debug_check_no_locks_freed+0x9d/0x170
hardirqs last disabled at (11620620): [<ffffffff810a5520>]
debug_check_no_locks_freed+0x40/0x170
softirqs last  enabled at (11617658): [<ffffffff810575e3>] __do_softirq
+0x1d3/0x2f0
softirqs last disabled at (11617625): [<ffffffff810579d5>] irq_exit
+0xb5/0xc0
CPU: 0 PID: 10715 Comm: fsstress Tainted: G           O 3.14.0-rc3.f2fs+
#10
Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z77
Extreme4, BIOS P2.30 09/21/2012
task: ffff880036fcc840 ti: ffff88000ecbe000 task.ti: ffff88000ecbe000
RIP: 0010:[<ffffffff8138771f>]  [<ffffffff8138771f>] delay_tsc+0x4f/0x80
RSP: 0018:ffff88000ecbfc88  EFLAGS: 00000202
RAX: 00000000be2c718a RBX: ffffffff81726ddc RCX: 000000000000001f
RDX: 0000000000035c36 RSI: 00000000be2c716b RDI: 0000000000000001
RBP: ffff88000ecbfc88 R08: 0000000000000000 R09: 0000000000000000
R10: 57ffe8b10853be00 R11: 0000000000000000 R12: ffff88000ecbfbf8
R13: ffff88007cfd4040 R14: ffff88000ecbe000 R15: ffff880036fcc840
FS:  00007f0bdf19d700(0000) GS:ffff88007ce00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5f111f09f1 CR3: 00000000188f0000 CR4: 00000000001407f0
Stack:
 ffff88000ecbfc98 ffffffff8138760f ffff88000ecbfcc8 ffffffff810acd64
 ffffffff81c045d0 ffffffff81c045b8 ffffffff81c045d0 ffff88003ee0dfd0
 ffff88000ecbfcf8 ffffffff81725d9e ffffffff811d0112 0000000000000000
Call Trace:
 [<ffffffff8138760f>] __delay+0xf/0x20
 [<ffffffff810acd64>] do_raw_spin_lock+0xf4/0x160
 [<ffffffff81725d9e>] _raw_spin_lock+0x5e/0x80
 [<ffffffff811d0112>] ? d_move+0x22/0x90
 [<ffffffff811d0112>] d_move+0x22/0x90
 [<ffffffff811c52ef>] vfs_rename+0x5ef/0x600
 [<ffffffff811c05bd>] ? lookup_real+0x1d/0x60
 [<ffffffff811c566d>] SYSC_renameat+0x36d/0x3c0
 [<ffffffff811d7f76>] ? mntput_no_expire+0x56/0x190
 [<ffffffff811d7f8e>] ? mntput_no_expire+0x6e/0x190
 [<ffffffff811d7f37>] ? mntput_no_expire+0x17/0x190
 [<ffffffff811d80d4>] ? mntput+0x24/0x40
 [<ffffffff81388bbe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff811c889b>] SyS_rename+0x1b/0x20
 [<ffffffff8172fb12>] system_call_fastpath+0x16/0x1b

	
-- 
Jaegeuk Kim
Samsung

