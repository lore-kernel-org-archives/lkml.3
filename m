Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab3LSQBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:01:00 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:46644 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756121Ab3LSP7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:59:44 -0500
Message-Id: <20131219155032.973230919@linux.com>
Date: Thu, 19 Dec 2013 09:50:36 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 21/40] block: Replace __this_cpu_ptr with raw_cpu_ptr
References: <20131219155015.443763038@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_block
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Patch depends on another patch in this series that introduces raw_cpu_ops]

__this_cpu_ptr is being phased out.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/fs/ext4/mballoc.c
===================================================================
--- linux.orig/fs/ext4/mballoc.c	2013-12-02 16:07:53.574528512 -0600
+++ linux/fs/ext4/mballoc.c	2013-12-02 16:07:53.574528512 -0600
@@ -4085,7 +4085,7 @@ static void ext4_mb_group_or_file(struct
 	 * per cpu locality group is to reduce the contention between block
 	 * request from multiple CPUs.
 	 */
-	ac->ac_lg = __this_cpu_ptr(sbi->s_locality_groups);
+	ac->ac_lg = raw_cpu_ptr(sbi->s_locality_groups);
 
 	/* we're going to use group allocation */
 	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;
Index: linux/fs/buffer.c
===================================================================
--- linux.orig/fs/buffer.c	2013-12-02 16:07:53.574528512 -0600
+++ linux/fs/buffer.c	2013-12-02 16:07:53.574528512 -0600
@@ -1312,7 +1312,7 @@ static void bh_lru_install(struct buffer
 		}
 		while (out < BH_LRU_SIZE)
 			bhs[out++] = NULL;
-		memcpy(__this_cpu_ptr(&bh_lrus.bhs), bhs, sizeof(bhs));
+		memcpy(this_cpu_ptr(&bh_lrus.bhs), bhs, sizeof(bhs));
 	}
 	bh_lru_unlock();
 

