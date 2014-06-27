Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaF0ERC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 00:17:02 -0400
Received: from m97134.qiye.163.com ([220.181.97.134]:35362 "EHLO
	m97134.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaF0ERA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 00:17:00 -0400
X-Greylist: delayed 907 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jun 2014 00:16:59 EDT
From: Minfei Huang <huangminfei@ucloud.cn>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minfei Huang <huangminfei@ucloud.cn>
Subject: [PATCH] dm-io: Prevent the danging point of the sync io callback function
Date: Fri, 27 Jun 2014 12:01:30 +0800
Message-Id: <1403841690-4401-1-git-send-email-huangminfei@ucloud.cn>
X-Mailer: git-send-email 1.9.1
X-CM-TRANSID: huCowED52U2b7KxTgu33AA--.6485S3
X-Coremail-Antispam: 1Uf129KBjvJXoW3WF4kWw15Cr1UZrWxJFWfGrg_yoW7XF4rpF
	W3Wr4jkr48tr4UXr4Utr4rAr15tr47Aa47GrZ3tw1rXF15Ww1DAF18JrWUWryDXr1rJFy7
	Jw4qqr4vqryUGaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRxMa8UUUUU=
X-CM-SenderInfo: xkxd0wxplqwvnl6xuzxrxghubq/1tbiGxy3QVIUzQG+MAAAs1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG: unable to handle kernel NULL pointer dereference at 0000000000000046
IP: [<ffffffffa0009cef>] dec_count+0x5f/0x80 [dm_mod]
PGD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/scsi_host/host0/proc_name

Pid: 2708, comm: kcopyd Tainted: G        W  --------------- H  2.6.32-279.19.5.el6.ucloud.x86_64 #1 Dell Inc. PowerEdge R720xd/0DCWD1
RIP: 0010:[<ffffffffa0009cef>]  [<ffffffffa0009cef>] dec_count+0x5f/0x80 [dm_mod]
RSP: 0018:ffff880100603c30  EFLAGS: 00010246
RAX: 0000000000000046 RBX: ffff8817968a5c30 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8817968a5c00
RBP: ffff880100603c50 R08: 0000000000000000 R09: 0000000000000000
R10: ffff880caa594cc0 R11: 0000000000000000 R12: ffff8817968a5c80
R13: ffffffff81013963 R14: 0000000000001000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880100600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000046 CR3: 000000020c309000 CR4: 00000000001426e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kcopyd (pid: 2708, threadinfo ffff88180cd26000, task ffff881841c9aa80)
Stack:
 ffff880100603c40 ffff880aa8b32300 0000000000000000 ffff8817968a5c00
<d> ffff880100603c80 ffffffffa000a12a 0000000000000000 ffff880aa8b32300
<d> 0000000000000000 ffff880caa594cc0 ffff880100603c90 ffffffff811bcf6d
Call Trace:
 <IRQ>
 [<ffffffffa000a12a>] endio+0x4a/0x70 [dm_mod]
 [<ffffffff811bcf6d>] bio_endio+0x1d/0x40
 [<ffffffff81260beb>] req_bio_endio+0x9b/0xe0
 [<ffffffff81263114>] blk_update_request+0x104/0x500
 [<ffffffff81263331>] ? blk_update_request+0x321/0x500
 [<ffffffff81263537>] blk_update_bidi_request+0x27/0xa0
 [<ffffffff8126419f>] blk_end_bidi_request+0x2f/0x80
 [<ffffffff81264240>] blk_end_request+0x10/0x20
 [<ffffffff81375c6f>] scsi_io_completion+0xaf/0x6c0
 [<ffffffff8136cb92>] scsi_finish_command+0xc2/0x130
 [<ffffffff813763e5>] scsi_softirq_done+0x145/0x170
 [<ffffffff812698ed>] blk_done_softirq+0x8d/0xa0
 [<ffffffff81074c5f>] __do_softirq+0xdf/0x210
 [<ffffffff8100c2cc>] call_softirq+0x1c/0x30
 [<ffffffff8100df9d>] do_softirq+0xad/0xe0
 [<ffffffff81074995>] irq_exit+0x95/0xa0
 [<ffffffff81510515>] do_IRQ+0x75/0xf0
 [<ffffffff8100ba53>] ret_from_intr+0x0/0x16

The value of rdi register(0xffff8817968a5c00) is the io pointer,
If the sync io, the address of io point must be alloc from stack.
SO
crash> struct thread_info ffff8817968a4000
struct thread_info {
  task = 0xffff88180cd9a580,
  exec_domain = 0xffffffff81a98ac0,
 ...
}

crash> struct task_struct 0xffff88180cd9a580
struct task_struct {
  state = 2,
  stack = 0xffff8817968a4000,
 ...
}

It shows value exactly when use the value of io address.

The io address in callback function will become the danging point,
cause by the thread of sync io wakes up by other threads
and return to relieve the io address,

Signed-off-by: Minfei Huang <huangminfei@ucloud.cn>
---
 drivers/md/dm-io.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 3842ac7..f992913 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -38,6 +38,7 @@ struct io {
 	void *context;
 	void *vma_invalidate_address;
 	unsigned long vma_invalidate_size;
+	atomic_t wakeup;
 } __attribute__((aligned(DM_IO_MAX_REGIONS)));
 
 static struct kmem_cache *_dm_io_cache;
@@ -121,10 +122,16 @@ static void dec_count(struct io *io, unsigned int region, int error)
 			invalidate_kernel_vmap_range(io->vma_invalidate_address,
 						     io->vma_invalidate_size);
 
-		if (io->sleeper)
-			wake_up_process(io->sleeper);
+		if (io->sleeper) {
+			struct task_struct *sleeper = io->sleeper;
 
-		else {
+			atomic_set(&io->wakeup, 1);
+/*
+ * The thread may be waked up by other threads,
+ * if then the sync io point will become the dangling pointer
+ */
+			wake_up_process(sleeper);
+		} else {
 			unsigned long r = io->error_bits;
 			io_notify_fn fn = io->callback;
 			void *context = io->context;
@@ -401,12 +408,14 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 	io->vma_invalidate_address = dp->vma_invalidate_address;
 	io->vma_invalidate_size = dp->vma_invalidate_size;
 
+	atomic_set(&io->wakeup, 0);
+
 	dispatch_io(rw, num_regions, where, dp, io, 1);
 
 	while (1) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 
-		if (!atomic_read(&io->count))
+		if (atomic_read(&io->wakeup))
 			break;
 
 		io_schedule();
@@ -442,6 +451,8 @@ static int async_io(struct dm_io_client *client, unsigned int num_regions,
 	io->vma_invalidate_address = dp->vma_invalidate_address;
 	io->vma_invalidate_size = dp->vma_invalidate_size;
 
+	atomic_set(&io->wakeup, 0);
+
 	dispatch_io(rw, num_regions, where, dp, io, 0);
 	return 0;
 }
-- 
1.7.1


