Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaEOCuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 22:50:04 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:34432 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaEOCuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 22:50:00 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53742B55.1060507@lge.com>
Date: Thu, 15 May 2014 11:49:57 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Barry Song <Baohua.Song@csr.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: =?EUC-KR?B?IsDMsMfIoy/DpcDTv6yxuL/4L1NXIFBsYXRmb3JtKL+sKUFPVMbAKGd1bmg=?=
	 =?EUC-KR?B?by5sZWVAbGdlLmNvbSki?= <gunho.lee@lge.com>,
        gurugio@gmail.com
Subject: [PATCH] [RFC] ARM: MM: remove phy_base field of struct
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's not a big deal but I've found that phy_base field of struct
l2x0_regs is not used anywhere.
I've removed it on my board. It seems to be working fine.

Why do we need physical address of L2 cache controller?
Is it removable?


------------------------ 8< --------------------------
>From cc0d98f4ef8b6f8f139a7c6179ed0b03e9ad7d07 Mon Sep 17 00:00:00 2001
From: Gioh Kim <gioh.kim@lge.com>
Date: Thu, 15 May 2014 11:26:20 +0900
Subject: [PATCH] [RFC] ARM: MM: remove phy_base field of struct l2x0_regs

Remove unused field, phy_base of struct l2x0_regs

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 arch/arm/include/asm/hardware/cache-l2x0.h |    1 -
 arch/arm/kernel/asm-offsets.c              |    1 -
 arch/arm/mm/cache-l2x0.c                   |    2 --
 3 files changed, 4 deletions(-)

diff --git a/arch/arm/include/asm/hardware/cache-l2x0.h
b/arch/arm/include/asm/hardware/cache-l2x0.h
index 6795ff7..6dec6da 100644
--- a/arch/arm/include/asm/hardware/cache-l2x0.h
+++ b/arch/arm/include/asm/hardware/cache-l2x0.h
@@ -118,7 +118,6 @@ static inline int l2x0_of_init(u32 aux_val, u32
aux_mask)
 #endif

 struct l2x0_regs {
-       unsigned long phy_base;
        unsigned long aux_ctrl;
        /*
         * Whether the following registers need to be saved/restored
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 85598b5..9b0ff94 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -100,7 +100,6 @@ int main(void)
   DEFINE(S_FRAME_SIZE,         sizeof(struct pt_regs));
   BLANK();
 #ifdef CONFIG_CACHE_L2X0
-  DEFINE(L2X0_R_PHY_BASE,      offsetof(struct l2x0_regs, phy_base));
   DEFINE(L2X0_R_AUX_CTRL,      offsetof(struct l2x0_regs, aux_ctrl));
   DEFINE(L2X0_R_TAG_LATENCY,   offsetof(struct l2x0_regs, tag_latency));
   DEFINE(L2X0_R_DATA_LATENCY,  offsetof(struct l2x0_regs, data_latency));
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 7abde2c..728d644 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -985,8 +985,6 @@ int __init l2x0_of_init(u32 aux_val, u32 aux_mask)
        if (!l2x0_base)
                return -ENOMEM;

-       l2x0_saved_regs.phy_base = res.start;
-
        data = of_match_node(l2x0_ids, np)->data;

        /* L2 configuration can only be changed if the cache is disabled */
--
1.7.9.5
