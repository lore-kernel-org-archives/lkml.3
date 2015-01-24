Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbbAXTMD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 14:12:03 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:50572 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbbAXTMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 14:12:00 -0500
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH] staging: rtl8192u: r8192U_core: Fix compile issue when CONFIG_WIRELESS_EXT is not defined
Date: Sat, 24 Jan 2015 17:11:42 -0200
Message-Id: <1422126702-27357-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch gets rid of the following error when compiling r8192U_core.c
and CONFIG_WIRELESS_EXT is not defined:

drivers/staging/rtl8192u/r8192U_core.c: In function ‘rtl8192_usb_probe’:
drivers/staging/rtl8192u/r8192U_core.c:4697:5: error: ‘struct net_device’ has no member named ‘wireless_handlers’
  dev->wireless_handlers = (struct iw_handler_def *) &r8192_wx_handlers_def;
     ^

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/rtl8192u/r8192U_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index e031a25..396a11f 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -4694,7 +4694,9 @@ static int rtl8192_usb_probe(struct usb_interface *intf,
 
 	dev->netdev_ops = &rtl8192_netdev_ops;
 
+#ifdef CONFIG_WIRELESS_EXT
 	dev->wireless_handlers = (struct iw_handler_def *) &r8192_wx_handlers_def;
+#endif
 
 	dev->type = ARPHRD_ETHER;
 
-- 
2.1.0

