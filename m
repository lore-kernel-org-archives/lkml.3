Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3FKO5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 10:57:35 -0400
Received: from multi.imgtec.com ([194.200.65.239]:39611 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab3FKO5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 10:57:33 -0400
From: Markos Chandras <markos.chandras@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH] drivers/net/ethernet/3com: Drop EISA dependency from VORTEX
Date: Tue, 11 Jun 2013 15:57:22 +0100
Message-ID: <1370962642-12097-1-git-send-email-markos.chandras@imgtec.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_11_15_57_31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Vortex driver depends on PCI with optional support for EISA.

This fixes build problems when EISA is selected but not PCI.

drivers/net/ethernet/3com/3c59x.c:1031:2: error: implicit declaration of
function 'pci_iomap' [-Werror=implicit-function-declaration]
drivers/net/ethernet/3com/3c59x.c:1044:3: error: implicit declaration of
function 'pci_iounmap' [-Werror=implicit-function-declaration]

Cc: David S. Miller <davem@davemloft.net>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
---
 drivers/net/ethernet/3com/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/3com/Kconfig b/drivers/net/ethernet/3com/Kconfig
index 1c71c76..5c67f44 100644
--- a/drivers/net/ethernet/3com/Kconfig
+++ b/drivers/net/ethernet/3com/Kconfig
@@ -66,7 +66,7 @@ config PCMCIA_3C589
 
 config VORTEX
 	tristate "3c590/3c900 series (592/595/597) \"Vortex/Boomerang\" support"
-	depends on (PCI || EISA) && HAS_IOPORT
+	depends on PCI && HAS_IOPORT
 	select NET_CORE
 	select MII
 	---help---
-- 
1.8.2.1


