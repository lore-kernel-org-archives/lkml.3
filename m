Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaACDW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 22:22:29 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33763 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaACDW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 22:22:28 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s033MMVA017237, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8152: fix the wrong return value
Date: Fri, 3 Jan 2014 11:21:56 +0800
Message-ID: <1388719316-5702-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value should be the boolean value, not the error code.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Spotted-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/usb/r8152.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index e3d878c..13fabbb 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2708,7 +2708,7 @@ static bool rtl_ops_init(struct r8152 *tp, const struct usb_device_id *id)
 			ops->unload		= rtl8153_unload;
 			break;
 		default:
-			ret = -EFAULT;
+			ret = false;
 			break;
 		}
 		break;
-- 
1.8.4.2

