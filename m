Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3CNV5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:57:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61016 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3CNV46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:56:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Grant Grundler <grundler@parisc-linux.org>, netdev@vger.kernel.org
Subject: [PATCH] ethernet/tulip: DE4x5 needs VIRT_TO_BUS
Date: Thu, 14 Mar 2013 22:56:42 +0100
Message-Id: <1363298204-8014-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363298204-8014-1-git-send-email-arnd@arndb.de>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:z5zSgV3hV60gvN0GayKCOGtKfR8TzfoCILkSTvBwdrX
 RrEDEDCmdYWMGkgi7fQhFXcYTQaoa6bG/DD70Ke33hKDXouk03
 FfkUWRKfttPh1AulRUpXsrfUJ0uE6wt/2vRf5VFCi5fiBFI5Ga
 GrDiNXr/E1dYHGfJWd5Zgw5jQsUS4eucFw8y0op2Dd4fDAzhH4
 RXhYmk9xQeqIShTSuRxx2uhmIlvonlmPDajC2qJbKPFw0+L5M+
 IKIFNRzEOa4rMZQ7WYd16VPj6ugLC3Ks/ol0lhGyahHWy+7ZS3
 ypcEE4S09Bl7kxBeb1ureDflaCn1iZhHBFB1jX7NsqWXUuTEq9
 YBzcKcj2EtypubQpuNYiH04pisfa962IbUnqUOhnQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The automated ARM build tests have shown that the tulip de4x5 driver
uses the old-style virt_to_bus() interface on some architectures.

Alpha, Sparc and PowerPC did not hit this problem, because they
use a different code path, and most other architectures actually
do provide VIRT_TO_BUS.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: netdev@vger.kernel.org
---
Please apply for 3.9 or 3.10, this one is not urgent

 drivers/net/ethernet/dec/tulip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/dec/tulip/Kconfig b/drivers/net/ethernet/dec/tulip/Kconfig
index 0c37fb2..1df33c7 100644
--- a/drivers/net/ethernet/dec/tulip/Kconfig
+++ b/drivers/net/ethernet/dec/tulip/Kconfig
@@ -108,6 +108,7 @@ config TULIP_DM910X
 config DE4X5
 	tristate "Generic DECchip & DIGITAL EtherWORKS PCI/EISA"
 	depends on (PCI || EISA)
+	depends on VIRT_TO_BUS || ALPHA || PPC || SPARC
 	select CRC32
 	---help---
 	  This is support for the DIGITAL series of PCI/EISA Ethernet cards.
-- 
1.8.1.2

