Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab3HWRdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:33:50 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:12917 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab3HWRdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:33:49 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 1/6] staging: ozwpan: Check for correct config number.
Date: Fri, 23 Aug 2013 18:33:28 +0100
Message-ID: <1377279213-17074-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for valid config number before completing set interface.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index ab93b74..83ed64c 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -909,7 +909,7 @@ static void oz_hcd_complete_set_interface(struct oz_port *port, struct urb *urb,
 	struct usb_hcd *hcd = port->ozhcd->hcd;
 	int rc = 0;
 
-	if (rcode == 0) {
+	if ((rcode == 0) && (port->config_num > 0)) {
 		struct usb_host_config *config;
 		struct usb_host_interface *intf;
 		oz_dbg(ON, "Set interface %d alt %d\n", if_num, alt);
-- 
1.7.9.5

