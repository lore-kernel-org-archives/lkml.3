Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaEHO6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:58:19 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:57979 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbaEHO5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:57:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Magnus Damm <damm@opensource.se>,
        linux-pci@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH] pci: rcar host needs OF
Date: Thu,  8 May 2014 16:56:25 +0200
Message-Id: <1399560990-1402858-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:g5pNar+1CE0cjp4VuCWBezghFh1pP8Rmfqv60cBnpiN
 nu6niX28JsJXj2YiLSpyAjkx4EIAMcQm2f9C47AIoc7EI4GzqA
 s7MhYie0HX5gkG/BNI1WVdE+kEcwqefnHUdFRu4xMshXcc98j9
 Z/cLXCKEBOjXOEOkdJKALpiwveQnEDadeB9DzFeY01y2wG0Ew4
 2PlqwMiS2bmmrP8SERxPyzqhzEgWqiqjgigUQqLXBvgRfntkkf
 nZIHzJ7yq4ebJF3W3gQGeovs4Rbb26ndcKbvtsK6q0q2iYP1L2
 MKgNm4fkLPMOLzki167NZ+X9QIOtAqu8nyxDrrtPgpP5CtSJX6
 cbO0SKLioMAcQycah35BFUKdw2KTxdHmeX5yhoE5i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pci-rcar driver is enabled for compile tests, and this has
now shown that the driver cannot build without CONFIG_OF,
following the inclusion of f8f2fe7355fb "PCI: rcar: Use new OF
interrupt mapping when possible":

drivers/built-in.o: In function `rcar_pci_map_irq':
:(.text+0x1cc7c): undefined reference to `of_irq_parse_and_map_pci'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Magnus Damm <damm@opensource.se>
Cc: linux-pci@vger.kernel.org
Cc: linux-sh@vger.kernel.org
---
 drivers/pci/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
index fbbef0b..4675f47 100644
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@ -27,7 +27,7 @@ config PCI_TEGRA
 
 config PCI_RCAR_GEN2
 	bool "Renesas R-Car Gen2 Internal PCI controller"
-	depends on ARCH_SHMOBILE || (ARM && COMPILE_TEST)
+	depends on ARCH_SHMOBILE || (ARM && OF && COMPILE_TEST)
 	help
 	  Say Y here if you want internal PCI support on R-Car Gen2 SoC.
 	  There are 3 internal PCI controllers available with a single
-- 
1.8.3.2

