Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaBNU3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:29:04 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:40700 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169AbaBNUT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:19:58 -0500
Message-Id: <20140214201906.376384012@linux.com>
Date: Fri, 14 Feb 2014 14:19:04 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 23/48] block: Replace __this_cpu_ptr with raw_cpu_ptr
References: <20140214201841.826179349@linux.com>
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
--- linux.orig/fs/ext4/mballoc.c	2014-02-03 13:22:58.795551096 -0600
+++ linux/fs/ext4/mballoc.c	2014-02-03 13:22:58.785551304 -0600
@@ -4090,7 +4090,7 @@
 	 * per cpu locality group is to reduce the contention between block
 	 * request from multiple CPUs.
 	 */
-	ac->ac_lg = __this_cpu_ptr(sbi->s_locality_groups);
+	ac->ac_lg = raw_cpu_ptr(sbi->s_locality_groups);
 
 	/* we're going to use group allocation */
 	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;

