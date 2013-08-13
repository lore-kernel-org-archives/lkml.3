Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967Ab3HMRZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:25:53 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:24722 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758572Ab3HMRZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:25:05 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 03/10] staging: ozwpan: Simply if condition
Date: Tue, 13 Aug 2013 18:24:23 +0100
Message-ID: <1376414670-23257-4-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376414670-23257-1-git-send-email-rupesh.gujare@atmel.com>
References: <1376414670-23257-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making code simpler for readability.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 5a417c8..4b658d4 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -478,7 +478,7 @@ static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 			struct urb *urb, u8 req_id)
 {
 	struct oz_urb_link *urbl;
-	struct oz_endpoint *ep;
+	struct oz_endpoint *ep = NULL;
 	int err = 0;
 
 	if (ep_addr >= OZ_NB_ENDPOINTS) {
@@ -506,11 +506,12 @@ static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 		oz_free_urb_link(urbl);
 		return 0;
 	}
-	if (in_dir && port->in_ep[ep_addr])
+
+	if (in_dir)
 		ep = port->in_ep[ep_addr];
-	else if (!in_dir && port->out_ep[ep_addr])
+	else
 		ep = port->out_ep[ep_addr];
-	else {
+	if (!ep) {
 		err = -ENOMEM;
 		goto out;
 	}
-- 
1.7.9.5

