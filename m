Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbaLDPO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:14:29 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:41729 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbaLDPO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:14:28 -0500
Date: Thu, 4 Dec 2014 10:14:13 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.19] workqueue: cosmetic update in rescuer_thread()
Message-ID: <20141204151413.GF15219@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rescuer_thread() caches &rescuer->scheduled in a local variable
scheduled for convenience.  There's one WARN_ON_ONCE() which was using
&rescuer->scheduled directly.  Replace it with the local variable.

This patch causes no functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applying to wq/for-3.19.

Thanks.

 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2246,7 +2246,7 @@ repeat:
 		 * Slurp in all works issued via this workqueue and
 		 * process'em.
 		 */
-		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
+		WARN_ON_ONCE(!list_empty(scheduled));
 		list_for_each_entry_safe(work, n, &pool->worklist, entry)
 			if (get_work_pwq(work) == pwq)
 				move_linked_works(work, scheduled, &n);
