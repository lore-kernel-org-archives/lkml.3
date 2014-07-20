Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaGTEGZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 00:06:25 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:61463 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaGTEGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 00:06:23 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: linux@arm.linux.org.uk
Cc: bhelgaas@google.com, wangyijing@huawei.com, jason@lakedaemon.net,
        thierry.reding@gmail.com, yinghai@kernel.org, m-karicheri2@ti.com,
        thomas.petazzoni@free-electrons.com, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm: Fix me in bios32.c
Date: Sun, 20 Jul 2014 00:06:19 -0400
Message-Id: <1405829179-19476-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixs a fix me in bios32.c for pci_fixup_it8152 as this if
statement is incorrect needs to be checked against the class bits
not the whole address for the two or conditions and since they don't
have define statements outside of their numeratical value.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/arm/kernel/bios32.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 17a26c1..b2217af 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -254,11 +254,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CONTAQ, PCI_DEVICE_ID_CONTAQ_82C693, pci_
 static void pci_fixup_it8152(struct pci_dev *dev)
 {
 	int i;
-	/* fixup for ITE 8152 devices */
-	/* FIXME: add defines for class 0x68000 and 0x80103 */
 	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_HOST ||
-	    dev->class == 0x68000 ||
-	    dev->class == 0x80103) {
+	   (dev->class >> 8) == 0x680 ||
+	   (dev->class >> 8) == 0x801) {
 		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
 			dev->resource[i].start = 0;
 			dev->resource[i].end   = 0;
-- 
1.9.1

