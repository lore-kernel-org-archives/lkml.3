Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab3HMRan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:30:43 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:53509 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab3HMRak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:30:40 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 09/10] staging: ozwpan: Swap arguments of oz_ep_alloc() to match kmalloc()
Date: Tue, 13 Aug 2013 18:29:25 +0100
Message-ID: <1376414966-23525-5-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376414966-23525-1-git-send-email-rupesh.gujare@atmel.com>
References: <1376414966-23525-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swap arguments of oz_ep_alloc() to match kmalloc() for better readability.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 0fd3fea..0b21c9f 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -327,7 +327,7 @@ static void oz_empty_link_pool(void)
  * allocated it immediately follows the endpoint structure.
  * Context: softirq
  */
-static struct oz_endpoint *oz_ep_alloc(gfp_t mem_flags, int buffer_size)
+static struct oz_endpoint *oz_ep_alloc(int buffer_size, gfp_t mem_flags)
 {
 	struct oz_endpoint *ep =
 		kzalloc(sizeof(struct oz_endpoint)+buffer_size, mem_flags);
@@ -673,7 +673,7 @@ struct oz_port *oz_hcd_pd_arrived(void *hpd)
 	/* Allocate an endpoint object in advance (before holding hcd lock) to
 	 * use for out endpoint 0.
 	 */
-	ep = oz_ep_alloc(GFP_ATOMIC, 0);
+	ep = oz_ep_alloc(0, GFP_ATOMIC);
 	spin_lock_bh(&ozhcd->hcd_lock);
 	if (ozhcd->conn_port >= 0) {
 		spin_unlock_bh(&ozhcd->hcd_lock);
@@ -1268,7 +1268,7 @@ static int oz_build_endpoints_for_interface(struct usb_hcd *hcd,
 			}
 		}
 
-		ep = oz_ep_alloc(mem_flags, buffer_size);
+		ep = oz_ep_alloc(buffer_size, mem_flags);
 		if (!ep) {
 			oz_clean_endpoints_for_interface(hcd, port, if_ix);
 			return -ENOMEM;
-- 
1.7.9.5

