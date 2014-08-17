Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaHQRbB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:31:01 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:54808 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751641AbaHQRar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:30:47 -0400
Message-Id: <20140817173033.713518795@linux.com>
Date: Sun, 17 Aug 2014 12:30:28 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/35] [PATCH 05/36] block: Replace __this_cpu_ptr with raw_cpu_ptr
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0005-block-Replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__this_cpu_ptr is being phased out use raw_cpu_ptr instead which was
introduced in 3.15-rc1.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christoph Lameter <cl@linux.com>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/fs/ext4/mballoc.c
===================================================================
--- linux.orig/fs/ext4/mballoc.c
+++ linux/fs/ext4/mballoc.c
@@ -4129,7 +4129,7 @@ static void ext4_mb_group_or_file(struct
 	 * per cpu locality group is to reduce the contention between block
 	 * request from multiple CPUs.
 	 */
-	ac->ac_lg = __this_cpu_ptr(sbi->s_locality_groups);
+	ac->ac_lg = raw_cpu_ptr(sbi->s_locality_groups);
 
 	/* we're going to use group allocation */
 	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;

