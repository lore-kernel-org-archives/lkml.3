Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaDORiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:38:13 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:51061 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752196AbaDORiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:38:07 -0400
Date: Tue, 15 Apr 2014 12:38:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: axboe@kernel.dk
cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: block: Replace __this_cpu_ptr with raw_cpu_ptr
Message-ID: <alpine.DEB.2.10.1404151236390.27497@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__this_cpu_ptr is being phased out use raw_cpu_ptr instead which was
introduced in 3.15-rc1.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/fs/ext4/mballoc.c
===================================================================
--- linux.orig/fs/ext4/mballoc.c	2014-04-14 13:24:55.153354620 -0500
+++ linux/fs/ext4/mballoc.c	2014-04-14 13:24:55.149354698 -0500
@@ -4091,7 +4091,7 @@
 	 * per cpu locality group is to reduce the contention between block
 	 * request from multiple CPUs.
 	 */
-	ac->ac_lg = __this_cpu_ptr(sbi->s_locality_groups);
+	ac->ac_lg = raw_cpu_ptr(sbi->s_locality_groups);

 	/* we're going to use group allocation */
 	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;
