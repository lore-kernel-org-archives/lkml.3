Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab3BVIIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:08:10 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19516 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3BVIII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:08:08 -0500
X-IronPort-AV: E=Sophos;i="4.84,714,1355126400"; 
   d="scan'208";a="26429432"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Steve Muckle <smuckle@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH] ARM: vfp: fix fpsid register subarchitecture field mask width
Date: Fri, 22 Feb 2013 00:08:05 -0800
Message-Id: <1361520485-30269-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc0.16.g20a599e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Muckle <smuckle@codeaurora.org>

The subarchitecture field in the fpsid register is 7 bits wide.
The topmost bit is used to designate that the subarchitecture
designer is not ARM. We use this field to determine which VFP
version is supported by the CPU. Since the topmost bit is masked
off we detect non-ARM subarchitectures as supporting only
HWCAP_VFP and not HWCAP_VFPv3 as it should be for Qualcomm's
processors.

Use the proper width for the mask so that we report the correct
elf_hwcap of non-ARM designed processors.

Signed-off-by: Steve Muckle <smuckle@codeaurora.org>
[sboyd: Expanded on commit text]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/include/asm/vfp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/vfp.h b/arch/arm/include/asm/vfp.h
index f4ab34f..76d3f69 100644
--- a/arch/arm/include/asm/vfp.h
+++ b/arch/arm/include/asm/vfp.h
@@ -21,7 +21,7 @@
 #define FPSID_FORMAT_MASK	(0x3  << FPSID_FORMAT_BIT)
 #define FPSID_NODOUBLE		(1<<20)
 #define FPSID_ARCH_BIT		(16)
-#define FPSID_ARCH_MASK		(0xF  << FPSID_ARCH_BIT)
+#define FPSID_ARCH_MASK		(0x7F  << FPSID_ARCH_BIT)
 #define FPSID_PART_BIT		(8)
 #define FPSID_PART_MASK		(0xFF << FPSID_PART_BIT)
 #define FPSID_VARIANT_BIT	(4)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

