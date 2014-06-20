Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbaFTTj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:39:58 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:37679 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932674AbaFTTbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:31:36 -0400
Message-Id: <20140620193125.325765953@linux.com>
Date: Fri, 20 Jun 2014 14:31:19 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/31] block: Replace __this_cpu_ptr with raw_cpu_ptr
References: <20140620193115.547427118@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_block
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__this_cpu_ptr is being phased out use raw_cpu_ptr instead which was
introduced in 3.15-rc1.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/fs/ext4/mballoc.c
===================================================================
--- linux.orig/fs/ext4/mballoc.c	2014-05-21 22:47:11.772163618 -0500
+++ linux/fs/ext4/mballoc.c	2014-05-21 22:47:11.768163700 -0500
@@ -4101,7 +4101,7 @@
 	 * per cpu locality group is to reduce the contention between block
 	 * request from multiple CPUs.
 	 */
-	ac->ac_lg = __this_cpu_ptr(sbi->s_locality_groups);
+	ac->ac_lg = raw_cpu_ptr(sbi->s_locality_groups);
 
 	/* we're going to use group allocation */
 	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;

