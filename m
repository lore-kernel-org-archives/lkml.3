Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaHQRhA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:37:00 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:53802 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712AbaHQRbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:31:08 -0400
Message-Id: <20140817173034.951213761@linux.com>
Date: Sun, 17 Aug 2014 12:30:36 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 13/35] [PATCH 13/36] md: Replace __this_cpu_ptr with raw_cpu_ptr
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0013-md-Replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__this_cpu_ptr is being phased out.

Signed-off-by: Christoph Lameter <cl@linux.com>
---
 drivers/md/dm-stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/md/dm-stats.c
===================================================================
--- linux.orig/drivers/md/dm-stats.c
+++ linux/drivers/md/dm-stats.c
@@ -548,7 +548,7 @@ void dm_stats_account_io(struct dm_stats
 		 * A race condition can at worst result in the merged flag being
 		 * misrepresented, so we don't have to disable preemption here.
 		 */
-		last = __this_cpu_ptr(stats->last);
+		last = raw_cpu_ptr(stats->last);
 		stats_aux->merged =
 			(bi_sector == (ACCESS_ONCE(last->last_sector) &&
 				       ((bi_rw & (REQ_WRITE | REQ_DISCARD)) ==

