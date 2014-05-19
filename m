Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbaESQYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:24:15 -0400
Received: from isis.lip6.fr ([132.227.60.2]:63139 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309AbaESQXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:23:51 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: benoit.taine@lip6.fr, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: rts5208: Use pci_device_id rather than DEFINE_PCI_DEVICE_TABLE
Date: Mon, 19 May 2014 18:24:26 +0200
Message-Id: <1400516666-17303-1-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Mon, 19 May 2014 18:23:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances kernel style usage for the rts5208 driver.
We should prefer `struct pci_device_id` over `DEFINE_PCI_DEVICE_TABLE` to meet
kernel coding style guidelines. This issue was reported by checkpatch.

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
 drivers/staging/rts5208/rtsx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index d2d1345..c0a0e60 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -1030,7 +1030,7 @@ static void rtsx_remove(struct pci_dev *pci)
 }
 
 /* PCI IDs */
-static DEFINE_PCI_DEVICE_TABLE(rtsx_ids) = {
+static const struct pci_device_id rtsx_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x5208),
 		PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x5288),

