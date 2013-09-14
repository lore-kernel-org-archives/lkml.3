Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab3INUUp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 16:20:45 -0400
Received: from mail-ye0-f176.google.com ([209.85.213.176]:37971 "EHLO
	mail-ye0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab3INUUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 16:20:43 -0400
From: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
To: Karsten Keil <isdn@linux-pingi.de>, Masanari Iida <standby24x7@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
Subject: [PATCH 1/1] isdn: hfcpci_softirq: get func return to suppress compiler warning
Date: Sat, 14 Sep 2013 14:20:40 -0300
Message-Id: <1379179240-21927-1-git-send-email-antonio.alecrim@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 7f910c7..3c92780 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2295,8 +2295,8 @@ _hfcpci_softirq(struct device *dev, void *arg)
 static void
 hfcpci_softirq(void *arg)
 {
-	(void) driver_for_each_device(&hfc_driver.driver, NULL, arg,
-				      _hfcpci_softirq);
+	WARN_ON_ONCE(driver_for_each_device(&hfc_driver.driver, NULL, arg,
+				      _hfcpci_softirq) != 0);
 
 	/* if next event would be in the past ... */
 	if ((s32)(hfc_jiffies + tics - jiffies) <= 0)
-- 
1.8.3.1

