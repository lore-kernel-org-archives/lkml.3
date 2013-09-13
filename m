Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3IMUoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 16:44:10 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:58690 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab3IMUoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:44:07 -0400
From: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
To: Karsten Keil <isdn@linux-pingi.de>, Masanari Iida <standby24x7@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
Subject: [PATCH 1/1] isdn: hfcpci_softirq: get func return to suppress compiler warning
Date: Fri, 13 Sep 2013 14:44:19 -0300
Message-Id: <1379094259-6237-1-git-send-email-antonio.alecrim@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 7f910c7..5b8df75b 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2295,7 +2295,9 @@ _hfcpci_softirq(struct device *dev, void *arg)
 static void
 hfcpci_softirq(void *arg)
 {
-	(void) driver_for_each_device(&hfc_driver.driver, NULL, arg,
+	int ret;
+
+	ret = driver_for_each_device(&hfc_driver.driver, NULL, arg,
 				      _hfcpci_softirq);
 
 	/* if next event would be in the past ... */
-- 
1.8.3.1

