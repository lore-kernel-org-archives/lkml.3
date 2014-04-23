Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaDWMGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:06:46 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:57810 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaDWMGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:06:45 -0400
From: Anders Darander <anders.darander@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Anders Darander <anders.darander@gmail.com>
Subject: [PATCH][linux-next]  staging/rtl8821ae: fix sparse address space warning
Date: Wed, 23 Apr 2014 14:06:25 +0200
Message-Id: <1398254785-2484-1-git-send-email-anders.darander@gmail.com>
X-Mailer: git-send-email 2.0.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When unmapping the pci memory, the pointer was explicitly casted to void*,
thus omitting the __iomem designation.

Signed-off-by: Anders Darander <anders.darander@gmail.com>
---
 drivers/staging/rtl8821ae/pci.c | 4 ++--
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
2.0.0.rc0

