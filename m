Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3H1Lnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:43:51 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:30584 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3H1Lnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:43:49 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <sergei.shtylyov@cogentembedded.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [v2 PATCH 2/3] staging: ozwpan: Change error number.
Date: Wed, 28 Aug 2013 12:43:15 +0100
Message-ID: <1377690196-4516-2-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377690196-4516-1-git-send-email-rupesh.gujare@atmel.com>
References: <1377690196-4516-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Incorrect error number was returned here (EPERM), ENXIO is more
appropriate.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozcdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 03b41ee..50722ea 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -161,7 +161,7 @@ static ssize_t oz_cdev_write(struct file *filp, const char __user *buf,
 		oz_pd_get(pd);
 	spin_unlock_bh(&g_cdev.lock);
 	if (pd == NULL)
-		return -1;
+		return -ENXIO;
 	eb = &pd->elt_buff;
 	ei = oz_elt_info_alloc(eb);
 	if (ei == NULL) {
-- 
1.7.9.5

