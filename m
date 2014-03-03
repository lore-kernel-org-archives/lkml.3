Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbaCCUrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 15:47:01 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:52041 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbaCCUq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 15:46:59 -0500
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Johannes Thumshirn <morbidrsa@gmail.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH 1/2] drivers: mcb: Fix build error discovered by 0-day bot
Date: Mon,  3 Mar 2014 21:46:48 +0100
Message-Id: <1393879609-3284-1-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Thumshirn <morbidrsa@gmail.com>

Make mcb depend on HAS_IOMEM and mcb-pci depend on PCI. This fixes build errors
discovered by the 0-day kernel build testing system.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
 drivers/mcb/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mcb/Kconfig b/drivers/mcb/Kconfig
index b8f5d46..87d5a46 100644
--- a/drivers/mcb/Kconfig
+++ b/drivers/mcb/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig MCB
 	   tristate "MCB support"
-	   default m
+	   depends on HAS_IOMEM
 	   help
 
 	   The MCB (MEN Chameleon Bus) is a Bus specific to MEN Mikroelektronik
@@ -18,6 +18,7 @@ if MCB
 config MCB_PCI
 	   tristate "PCI based MCB carrier"
 	   default m
+	   depends on PCI
 	   help
 
 	   This is a MCB carrier on a PCI device. Both PCI attached on-board
-- 
1.8.5.3

