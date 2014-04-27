Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaD0RHl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:07:41 -0400
Received: from linuxhacker.ru ([217.76.32.60]:47951 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbaD0RHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:39 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Cheng Shao <cheng_shao@xyratex.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 02/47] staging/lustre/ptlrpc: Remove log message about export timer update
Date: Sun, 27 Apr 2014 13:06:26 -0400
Message-Id: <1398618431-29757-3-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Shao <cheng_shao@xyratex.com>

Function ptlrpc_update_export_timer generates lots of D_HA level log
messages whenever the export timer gets updated. Those log messages
are found little use for issue investigations, and it will take space
in the Lustre log buffer. We are removing it now.

Xyratex-bug-id: MRP-733
Signed-off-by: Cheng Shao <cheng_shao@xyratex.com>
Reviewed-on: http://review.whamcloud.com/9147
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4590
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/service.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index 192adec..5873c03 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -1042,9 +1042,6 @@ static void ptlrpc_update_export_timer(struct obd_export *exp, long extra_delay)
 		return;
 
 	exp->exp_last_request_time = new_time;
-	CDEBUG(D_HA, "updating export %s at "CFS_TIME_T" exp %p\n",
-	       exp->exp_client_uuid.uuid,
-	       exp->exp_last_request_time, exp);
 
 	/* exports may get disconnected from the chain even though the
 	   export has references, so we must keep the spin lock while
-- 
1.8.5.3

