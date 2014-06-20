Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbaFTThv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:37:51 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:58497 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966128AbaFTTb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:31:56 -0400
Message-Id: <20140620193126.279406340@linux.com>
Date: Fri, 20 Jun 2014 14:31:27 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 12/31] md: Replace __this_cpu_ptr with raw_cpu_ptr
References: <20140620193115.547427118@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_drivers_md
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__this_cpu_ptr is being phased out.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/md/dm-stats.c
===================================================================
--- linux.orig/drivers/md/dm-stats.c	2014-06-16 15:40:37.491590719 -0500
+++ linux/drivers/md/dm-stats.c	2014-06-16 15:40:37.491590719 -0500
@@ -548,7 +548,7 @@
 		 * A race condition can at worst result in the merged flag being
 		 * misrepresented, so we don't have to disable preemption here.
 		 */
-		last = __this_cpu_ptr(stats->last);
+		last = raw_cpu_ptr(stats->last);
 		stats_aux->merged =
 			(bi_sector == (ACCESS_ONCE(last->last_sector) &&
 				       ((bi_rw & (REQ_WRITE | REQ_DISCARD)) ==

