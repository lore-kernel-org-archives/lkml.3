Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab3CMBcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 21:32:07 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15463 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab3CMBcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 21:32:04 -0400
X-IronPort-AV: E=Sophos;i="4.84,833,1355126400"; 
   d="scan'208";a="29184076"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 1/3] ARM: Clear IDIVT hwcap if CONFIG_ARM_THUMB=n
Date: Tue, 12 Mar 2013 18:31:59 -0700
Message-Id: <1363138321-27849-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
In-Reply-To: <1363138321-27849-1-git-send-email-sboyd@codeaurora.org>
References: <1363138321-27849-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't advertise support for the SDIV/UDIV thumb instructions if
the kernel is not compiled with support for thumb userspace. This
is in line with how we remove the THUMB hwcap in these
configurations.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f6cbb2..e2c8bbf 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -484,7 +484,7 @@ static void __init setup_processor(void)
 		 list->elf_name, ENDIANNESS);
 	elf_hwcap = list->elf_hwcap;
 #ifndef CONFIG_ARM_THUMB
-	elf_hwcap &= ~HWCAP_THUMB;
+	elf_hwcap &= ~(HWCAP_THUMB | HWCAP_IDIVT);
 #endif
 
 	feat_v6_fixup();
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

