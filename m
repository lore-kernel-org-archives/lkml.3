Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3HVQjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:39:23 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:35924 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab3HVQjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:39:20 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 2/4] staging: ozwpan: Check error condition before creating endpoint.
Date: Thu, 22 Aug 2013 17:38:49 +0100
Message-ID: <1377189531-24950-2-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377189531-24950-1-git-send-email-rupesh.gujare@atmel.com>
References: <1377189531-24950-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check if interface number is correct before creating an end point.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 4682d78..d5a3900 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -1247,6 +1247,8 @@ static int oz_build_endpoints_for_interface(struct usb_hcd *hcd,
 	int request_heartbeat = 0;
 
 	oz_dbg(ON, "interface[%d] = %p\n", if_ix, intf);
+	if (if_ix >= port->num_iface || port->iface == NULL)
+		return -ENOMEM;
 	for (i = 0; i < intf->desc.bNumEndpoints; i++) {
 		struct usb_host_endpoint *hep = &intf->endpoint[i];
 		u8 ep_addr = hep->desc.bEndpointAddress;
-- 
1.7.9.5

