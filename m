Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab3GZOEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:04:05 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:54134 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab3GZOEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:04:00 -0400
From: Alexandru Juncu <alexj@rosedu.org>
To: ralf@linux-mips.org, jchandra@broadcom.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Alexandru Juncu <alexj@rosedu.org>
Subject: [PATCH] MIPS:Netlogic: Remove redundant value in operation.
Date: Fri, 26 Jul 2013 17:03:35 +0300
Message-Id: <1374847415-28449-1-git-send-email-ajuncu@ixiacom.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandru Juncu <alexj@rosedu.org>

Removed parameters checked twice in logical OR operation.
Suggested by coccinelle and manually verified.

Signed-off-by: Alexandru Juncu <alexj@rosedu.org>
---
 arch/mips/netlogic/xlp/usb-init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/mips/netlogic/xlp/usb-init.c b/arch/mips/netlogic/xlp/usb-init.c
index ef3897e..d5378ef 100644
--- a/arch/mips/netlogic/xlp/usb-init.c
+++ b/arch/mips/netlogic/xlp/usb-init.c
@@ -75,8 +75,7 @@ static void nlm_usb_intr_en(int node, int port)
 	port_addr = nlm_get_usb_regbase(node, port);
 	val = nlm_read_usb_reg(port_addr, USB_INT_EN);
 	val = USB_CTRL_INTERRUPT_EN  | USB_OHCI_INTERRUPT_EN |
-		USB_OHCI_INTERRUPT1_EN | USB_CTRL_INTERRUPT_EN	|
-		USB_OHCI_INTERRUPT_EN | USB_OHCI_INTERRUPT2_EN;
+		USB_OHCI_INTERRUPT1_EN | USB_OHCI_INTERRUPT2_EN;
 	nlm_write_usb_reg(port_addr, USB_INT_EN, val);
 }
 
-- 
1.8.1.2

