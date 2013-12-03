Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab3LCXoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:44:08 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:41830 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755585Ab3LCXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:39:06 -0500
Message-Id: <20131203233258.572451268@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:32:58 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 26/41] md: Replace __this_cpu_ptr with raw_cpu_ptr
References: <20131203233232.928771708@linux.com>
Content-Disposition: inline; filename=this_drivers_md
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__this_cpu_ptr is being phased out.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/md/dm-stats.c
===================================================================
--- linux.orig/drivers/md/dm-stats.c	2013-12-02 16:07:54.904491557 -0600
+++ linux/drivers/md/dm-stats.c	2013-12-02 16:07:54.904491557 -0600
@@ -548,7 +548,7 @@ void dm_stats_account_io(struct dm_stats
 		 * A race condition can at worst result in the merged flag being
 		 * misrepresented, so we don't have to disable preemption here.
 		 */
-		last = __this_cpu_ptr(stats->last);
+		last = raw_cpu_ptr(stats->last);
 		stats_aux->merged =
 			(bi_sector == (ACCESS_ONCE(last->last_sector) &&
 				       ((bi_rw & (REQ_WRITE | REQ_DISCARD)) ==

