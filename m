Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab3H1Lnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:43:53 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:30598 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab3H1Lnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:43:51 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <sergei.shtylyov@cogentembedded.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [v2 PATCH 3/3] staging: ozwpan: Return error, if PD is not connected.
Date: Wed, 28 Aug 2013 12:43:16 +0100
Message-ID: <1377690196-4516-3-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377690196-4516-1-git-send-email-rupesh.gujare@atmel.com>
References: <1377690196-4516-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return error if we receive write(), while PD is not connected.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozcdev.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 50722ea..6ccb64f 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -162,6 +162,8 @@ static ssize_t oz_cdev_write(struct file *filp, const char __user *buf,
 	spin_unlock_bh(&g_cdev.lock);
 	if (pd == NULL)
 		return -ENXIO;
+	if (!(pd->state & OZ_PD_S_CONNECTED))
+		return -EAGAIN;
 	eb = &pd->elt_buff;
 	ei = oz_elt_info_alloc(eb);
 	if (ei == NULL) {
-- 
1.7.9.5

