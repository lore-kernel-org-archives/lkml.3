Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3DRNQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:16:30 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:47640 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab3DRNQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:16:29 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Denis Efremov <yefremov.denis@gmail.com>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] usb: otg: remove exported function from __init section
Date: Thu, 18 Apr 2013 17:13:31 +0400
Message-Id: <1366290811-2281-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol usb_bind_phy is exported and annotated __init.
It looks like section mismatch. Fix by removing
the __init annotation of usb_bind_phy.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 drivers/usb/otg/otg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/otg/otg.c b/drivers/usb/otg/otg.c
index 2bd03d2..77346cf 100644
--- a/drivers/usb/otg/otg.c
+++ b/drivers/usb/otg/otg.c
@@ -414,7 +414,7 @@ EXPORT_SYMBOL(usb_remove_phy);
  *
  * To be used by platform specific initialization code.
  */
-int __init usb_bind_phy(const char *dev_name, u8 index,
+int usb_bind_phy(const char *dev_name, u8 index,
 				const char *phy_dev_name)
 {
 	struct usb_phy_bind *phy_bind;
-- 
1.8.1.4

