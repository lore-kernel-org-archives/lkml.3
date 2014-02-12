Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaBLGaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 01:30:20 -0500
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:35158 "HELO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750840AbaBLGaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 01:30:18 -0500
From: Vinayak Kale <vkale@apm.com>
To: patches@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, linux@arm.linux.org.uk, nico@linaro.org,
        catalin.marinas@arm.com, Dave.Martin@arm.com, will.deacon@arm.com,
        dirk.behme@gmail.com, Vinayak Kale <vkale@apm.com>
Subject: [PATCH RESEND] arm: add DSB after icache flush in __flush_icache_all()
Date: Wed, 12 Feb 2014 12:00:01 +0530
Message-Id: <1392186601-25625-1-git-send-email-vkale@apm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DSB after icache flush to complete the cache maintenance operation.

Signed-off-by: Vinayak Kale <vkale@apm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
---
KernelVersion: 3.14-rc1

PS:
- This patch is tested for ARM-v7.

 arch/arm/include/asm/cacheflush.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index ee753f1..ab91ebb 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -212,6 +212,7 @@ extern void copy_to_user_page(struct vm_area_struct *, struct page *,
 static inline void __flush_icache_all(void)
 {
 	__flush_icache_preferred();
+	dsb();
 }
 
 /*
-- 
1.7.9.5

