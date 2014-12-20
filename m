Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaLTMrM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:47:12 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:65472 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbaLTMrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:47:11 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8192e: rtl8192e: rtl_pm.c:  Remove some unused functions
Date: Sat, 20 Dec 2014 13:49:58 +0100
Message-Id: <1419079798-32650-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
rtl8192E_save_state() rtl8192E_enable_wake()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_pm.c |   14 --------------
 drivers/staging/rtl8192e/rtl8192e/rtl_pm.h |    2 --
 2 files changed, 16 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_pm.c b/drivers/staging/rtl8192e/rtl8192e/rtl_pm.c
index 8e1a5d5..0b4f764 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_pm.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_pm.c
@@ -22,12 +22,6 @@
 #include "r8190P_rtl8256.h"
 #include "rtl_pm.h"
 
-int rtl8192E_save_state(struct pci_dev *dev, pm_message_t state)
-{
-	printk(KERN_NOTICE "r8192E save state call (state %u).\n", state.event);
-	return -EAGAIN;
-}
-
 
 int rtl8192E_suspend(struct pci_dev *pdev, pm_message_t state)
 {
@@ -124,11 +118,3 @@ out:
 	return 0;
 }
 
-
-int rtl8192E_enable_wake(struct pci_dev *dev, pm_message_t state, int enable)
-{
-	printk(KERN_NOTICE "r8192E enable wake call (state %u, enable %d).\n",
-	       state.event, enable);
-	return -EAGAIN;
-}
-
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_pm.h b/drivers/staging/rtl8192e/rtl8192e/rtl_pm.h
index e5299fc..7bfe448 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_pm.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_pm.h
@@ -23,9 +23,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 
-int rtl8192E_save_state(struct pci_dev *dev, pm_message_t state);
 int rtl8192E_suspend(struct pci_dev *dev, pm_message_t state);
 int rtl8192E_resume(struct pci_dev *dev);
-int rtl8192E_enable_wake(struct pci_dev *dev, pm_message_t state, int enable);
 
 #endif
-- 
1.7.10.4

