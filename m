Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664Ab3GDHTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 03:19:33 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:53514 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645Ab3GDHTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:19:30 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 3/4] arm: atmel: sama5: enable kernel uncompress info output
Date: Thu,  4 Jul 2013 15:16:41 +0800
Message-Id: <1372922202-28606-4-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372922202-28606-1-git-send-email-voice.shen@atmel.com>
References: <1372922202-28606-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enable kernel uncompress info output, which will show as following:
---8>---
Uncompressing Linux... done, booting the kernel.
---<8---

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
 arch/arm/mach-at91/include/mach/uncompress.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/mach-at91/include/mach/uncompress.h b/arch/arm/mach-at91/include/mach/uncompress.h
index 5659f7c..fe097e6 100644
--- a/arch/arm/mach-at91/include/mach/uncompress.h
+++ b/arch/arm/mach-at91/include/mach/uncompress.h
@@ -94,6 +94,15 @@ static const u32 uarts_sam9x5[] = {
 	0,
 };
 
+static const u32 uarts_sama5[] = {
+	AT91_BASE_DBGU1,
+	SAMA5D3_BASE_USART0,
+	SAMA5D3_BASE_USART1,
+	SAMA5D3_BASE_USART2,
+	SAMA5D3_BASE_USART3,
+	0,
+};
+
 static inline const u32* decomp_soc_detect(void __iomem *dbgu_base)
 {
 	u32 cidr, socid;
@@ -123,6 +132,9 @@ static inline const u32* decomp_soc_detect(void __iomem *dbgu_base)
 
 	case ARCH_ID_AT91SAM9X5:
 		return uarts_sam9x5;
+
+	case ARCH_ID_SAMA5D3:
+		return uarts_sama5;
 	}
 
 	/* at91sam9g10 */
-- 
1.7.9.5

