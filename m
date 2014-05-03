Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaECPLQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 11:11:16 -0400
Received: from mx02.posteo.de ([89.146.194.165]:46890 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751202AbaECPLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 11:11:15 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: standby24x7@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] staging: rtl8821ae: mark pointer in pci_iounmap as __iomem
Date: Sat,  3 May 2014 17:10:48 +0200
Message-Id: <1399129848-1833-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_iounmap is used that way in drivers/net/wireless/rtlwifi and this
fixes sparse warnings.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 drivers/staging/rtl8821ae/pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8821ae/pci.c b/drivers/staging/rtl8821ae/pci.c
index a562aa6..d934ecb 100644
--- a/drivers/staging/rtl8821ae/pci.c
+++ b/drivers/staging/rtl8821ae/pci.c
@@ -2416,7 +2416,7 @@ fail3:
 	ieee80211_free_hw(hw);
 
 	if (rtlpriv->io.pci_mem_start != 0)
-		pci_iounmap(pdev, (void *)rtlpriv->io.pci_mem_start);
+		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
 
 fail2:
 	pci_release_regions(pdev);
@@ -2479,7 +2479,7 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
 
 	list_del(&rtlpriv->list);
 	if (rtlpriv->io.pci_mem_start != 0) {
-		pci_iounmap(pdev, (void *)rtlpriv->io.pci_mem_start);
+		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
 		pci_release_regions(pdev);
 	}
 
-- 
1.7.10.4

