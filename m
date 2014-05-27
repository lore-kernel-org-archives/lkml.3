Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaE0VJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:09:22 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53017 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaE0VJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:09:20 -0400
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: mathias.nyman@intel.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH] usb: pci_quirks: fix sparse 'symbol not declared' warning
Date: Tue, 27 May 2014 23:09:14 +0200
Message-Id: <1401224954-14109-1-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes the following sparse warning:

drivers/usb/host/pci-quirks.c:
    - 252: warning: symbol 'usb_hcd_amd_remote_wakeup_quirk' was not
      declared. Should it be static?

This function is exported so the fix was to add it's declaration to the
header file.

Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
---
 drivers/usb/host/pci-quirks.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/pci-quirks.h b/drivers/usb/host/pci-quirks.h
index 638e88f..c622ddf 100644
--- a/drivers/usb/host/pci-quirks.h
+++ b/drivers/usb/host/pci-quirks.h
@@ -5,6 +5,7 @@
 void uhci_reset_hc(struct pci_dev *pdev, unsigned long base);
 int uhci_check_and_reset_hc(struct pci_dev *pdev, unsigned long base);
 int usb_amd_find_chipset_info(void);
+int usb_hcd_amd_remote_wakeup_quirk(struct pci_dev *pdev);
 bool usb_amd_hang_symptom_quirk(void);
 bool usb_amd_prefetch_quirk(void);
 void usb_amd_dev_put(void);
-- 
1.8.1.2

