Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab3KNQuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:50:18 -0500
Received: from ms-10.1blu.de ([178.254.4.101]:46435 "EHLO ms-10.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757629Ab3KNQt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:49:58 -0500
X-Greylist: delayed 2015 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Nov 2013 11:49:58 EST
Message-ID: <1384445773.29057.5.camel@localhost.tld>
Subject: [PATCH] alx: Reset phy speed after resume
From: hahnjo <linux@hahnjo.de>
To: jcliburn@gmail.com, chris.snook@gmail.com, davem@davemloft.net,
        johannes@sipsolutions.net, wangyijing@huawei.com,
        maarten.lankhorst@canonical.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 14 Nov 2013 17:16:13 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Con-Id: 154395
X-Con-U: 0-hahnjo
X-Originating-IP: 79.233.150.236
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 27744b24f9291782c1342dbd6cac511e68da907c Mon Sep 17 00:00:00 2001
From: hahnjo <hahnjo@hahnjo.de>
Date: Tue, 12 Nov 2013 18:19:24 +0100
Subject: [PATCH] alx: Reset phy speed after resume

This fixes bug 62491 (https://bugzilla.kernel.org/show_bug.cgi?id=62491).
After resuming some users got the following error flooding the kernel log:
alx 0000:02:00.0: invalid PHY speed/duplex: 0xffff

Signed-off-by: Jonas Hahnfeld <linux@hahnjo.de>
---
 drivers/net/ethernet/atheros/alx/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index fc95b23..6305a5d 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1389,6 +1389,9 @@ static int alx_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct alx_priv *alx = pci_get_drvdata(pdev);
+	struct alx_hw *hw = &alx->hw;
+
+	alx_reset_phy(hw);
 
 	if (!netif_running(alx->dev))
 		return 0;
-- 
1.8.4.2



