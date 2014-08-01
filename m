Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbaHAOvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:51:23 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35552 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaHAOvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:51:22 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>,
        Yijing Wang <wangyijing@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Nicholas Krause <xerofoify@gmail.com>, Rostislav Lisovy <lisovy@gmail.com>
Subject: [PATCH] ARM: PCI: Use PCI_CLASS_* defines for PCI class
Date: Fri,  1 Aug 2014 16:51:11 +0200
Message-Id: <1406904671-19197-1-git-send-email-lisovy@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
---
 arch/arm/kernel/bios32.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 17a26c1..e511ad1 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -255,10 +255,9 @@ static void pci_fixup_it8152(struct pci_dev *dev)
 {
 	int i;
 	/* fixup for ITE 8152 devices */
-	/* FIXME: add defines for class 0x68000 and 0x80103 */
 	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_HOST ||
-	    dev->class == 0x68000 ||
-	    dev->class == 0x80103) {
+	    dev->class == (PCI_CLASS_BRIDGE_OTHER << 8) ||
+	    dev->class == ((PCI_CLASS_SYSTEM_DMA << 8) | 0x03)) {
 		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
 			dev->resource[i].start = 0;
 			dev->resource[i].end   = 0;
-- 
1.7.10.4

