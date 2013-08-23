Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab3HWPLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:11:20 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:50980 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3HWPLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:11:19 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <sergei.shtylyov@cogentembedded.com>, <dan.carpenter@oracle.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 1/3] staging: ozwpan: Remove memset
Date: Fri, 23 Aug 2013 16:11:00 +0100
Message-ID: <1377270662-10379-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we are initialising structure, we do not require
memset().

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozpd.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 06004c8..5d24af3 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -268,7 +268,6 @@ void oz_pd_destroy(struct oz_pd *pd)
 	if (hrtimer_active(&pd->heartbeat))
 		hrtimer_cancel(&pd->heartbeat);
 
-	memset(&pd->workitem, 0, sizeof(pd->workitem));
 	INIT_WORK(&pd->workitem, oz_pd_free);
 	ret = schedule_work(&pd->workitem);
 
-- 
1.7.9.5

