Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaDOLxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:53:44 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57077 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbaDOLuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:50:46 -0400
From: Mohit Kumar <mohit.kumar@st.com>
To: <spear-devel@list.st.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Pratyush Anand <pratyush.anand@st.com>, Mohit Kumar <mohit.kumar@st.com>,
        <stable@vger.kernel.org>
Subject: [PATCH V8 2/9] SPEAr13XX: Fix static mapping table
Date: Tue, 15 Apr 2014 17:19:44 +0530
Message-ID: <d6886e0f97dff12932cf89cb33721ac86c3a8e8b.1397555158.git.mohit.kumar@st.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <cover.1397555158.git.mohit.kumar@st.com>
References: <cover.1397555158.git.mohit.kumar@st.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-14_01:2014-04-14,2014-04-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratyush Anand <pratyush.anand@st.com>

SPEAr13XX was using virtual address space 0xFE000000 to map physical address
space 0xB3000000. pci_remap_io uses 0xFEE00000 as virtual address. So
change 0xFE000000 to 0xF9000000.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Mohit Kumar <mohit.kumar@st.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: spear-devel@list.st.com
Cc: stable@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-spear/include/mach/spear.h |    4 ++--
 arch/arm/mach-spear/spear13xx.c          |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-spear/include/mach/spear.h b/arch/arm/mach-spear/include/mach/spear.h
index 5cdc53d..f2d6a01 100644
--- a/arch/arm/mach-spear/include/mach/spear.h
+++ b/arch/arm/mach-spear/include/mach/spear.h
@@ -52,10 +52,10 @@
 #ifdef CONFIG_ARCH_SPEAR13XX
 
 #define PERIP_GRP2_BASE				UL(0xB3000000)
-#define VA_PERIP_GRP2_BASE			IOMEM(0xFE000000)
+#define VA_PERIP_GRP2_BASE			IOMEM(0xF9000000)
 #define MCIF_SDHCI_BASE				UL(0xB3000000)
 #define SYSRAM0_BASE				UL(0xB3800000)
-#define VA_SYSRAM0_BASE				IOMEM(0xFE800000)
+#define VA_SYSRAM0_BASE				IOMEM(0xF9800000)
 #define SYS_LOCATION				(VA_SYSRAM0_BASE + 0x600)
 
 #define PERIP_GRP1_BASE				UL(0xE0000000)
diff --git a/arch/arm/mach-spear/spear13xx.c b/arch/arm/mach-spear/spear13xx.c
index 7aa6e8c..89212ff 100644
--- a/arch/arm/mach-spear/spear13xx.c
+++ b/arch/arm/mach-spear/spear13xx.c
@@ -52,7 +52,7 @@ void __init spear13xx_l2x0_init(void)
 /*
  * Following will create 16MB static virtual/physical mappings
  * PHYSICAL		VIRTUAL
- * 0xB3000000		0xFE000000
+ * 0xB3000000		0xF9000000
  * 0xE0000000		0xFD000000
  * 0xEC000000		0xFC000000
  * 0xED000000		0xFB000000
-- 
1.7.0.1

