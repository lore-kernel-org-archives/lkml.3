Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab3DBLQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:16:15 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:51569 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932534Ab3DBLQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:16:13 -0400
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: [PATCH v2 1/2] usb: gadget: fusb300_udc: add FUSB300_EPSET0_STL_CLR for clearing EP0 stall
Date: Tue,  2 Apr 2013 11:15:28 +0000
Message-Id: <1364901328-21405-1-git-send-email-yhchen@faraday-tech.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1361516979-7340-1-git-send-email-yhchen@faraday-tech.com>
References: <1361516979-7340-1-git-send-email-yhchen@faraday-tech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The final version of fusb300 controller adds EPSET0_STL_CLR
for clearing EP0 stall and also removes EPSET0_EPn_TX0BYTE.

fusb300_udc driver is tested on FARADAY platform a369 with
FUSB300 FPGA v1.8

Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
---

v2:
split patch

 drivers/usb/gadget/fusb300_udc.c |    2 +-
 drivers/usb/gadget/fusb300_udc.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/fusb300_udc.c b/drivers/usb/gadget/fusb300_udc.c
index 72cd5e6..c20cc58 100644
--- a/drivers/usb/gadget/fusb300_udc.c
+++ b/drivers/usb/gadget/fusb300_udc.c
@@ -394,7 +394,7 @@ static void fusb300_clear_epnstall(struct fusb300 *fusb300, u8 ep)
 
 	if (reg & FUSB300_EPSET0_STL) {
 		printk(KERN_DEBUG "EP%d stall... Clear!!\n", ep);
-		reg &= ~FUSB300_EPSET0_STL;
+		reg |= FUSB300_EPSET0_STL_CLR;
 		iowrite32(reg, fusb300->reg + FUSB300_OFFSET_EPSET0(ep));
 	}
 }
diff --git a/drivers/usb/gadget/fusb300_udc.h b/drivers/usb/gadget/fusb300_udc.h
index 542cd83..ccae1b5 100644
--- a/drivers/usb/gadget/fusb300_udc.h
+++ b/drivers/usb/gadget/fusb300_udc.h
@@ -111,8 +111,8 @@
 /*
  * * EPn Setting 0 (EPn_SET0, offset = 020H+(n-1)*30H, n=1~15 )
  * */
+#define FUSB300_EPSET0_STL_CLR		(1 << 3)
 #define FUSB300_EPSET0_CLRSEQNUM	(1 << 2)
-#define FUSB300_EPSET0_EPn_TX0BYTE	(1 << 1)
 #define FUSB300_EPSET0_STL		(1 << 0)
 
 /*
-- 
1.7.4.1

