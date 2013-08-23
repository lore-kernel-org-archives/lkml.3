Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab3HWPL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:11:28 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:36875 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3HWPL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:11:26 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <sergei.shtylyov@cogentembedded.com>, <dan.carpenter@oracle.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 2/3] staging: ozwpan: Fix wrong error check.
Date: Fri, 23 Aug 2013 16:11:01 +0100
Message-ID: <1377270662-10379-2-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377270662-10379-1-git-send-email-rupesh.gujare@atmel.com>
References: <1377270662-10379-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

schedule_work() returns true if succeeded & false on failure,
error check was doing exactly reverse.
Also removes extra variable.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozpd.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 5d24af3..d39a3df 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -261,17 +261,13 @@ void oz_pd_free(struct work_struct *work)
  */
 void oz_pd_destroy(struct oz_pd *pd)
 {
-	int ret;
-
 	if (hrtimer_active(&pd->timeout))
 		hrtimer_cancel(&pd->timeout);
 	if (hrtimer_active(&pd->heartbeat))
 		hrtimer_cancel(&pd->heartbeat);
 
 	INIT_WORK(&pd->workitem, oz_pd_free);
-	ret = schedule_work(&pd->workitem);
-
-	if (ret)
+	if (!schedule_work(&pd->workitem))
 		oz_pd_dbg(pd, ON, "failed to schedule workitem\n");
 }
 
-- 
1.7.9.5

