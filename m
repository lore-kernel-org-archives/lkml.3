Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab3CYELD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 00:11:03 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42621 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3CYEKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 00:10:37 -0400
X-AuditID: 9c930197-b7c9dae000006959-70-514fce3a72f2
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [RFC PATCH 3/6] ARM, crashkernel: correct total_mem size in reserve_crashkernel()
Date: Mon, 25 Mar 2013 13:11:11 +0900
Message-Id: <1364184674-13798-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364184674-13798-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364184674-13798-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is some platforms which have highmem, so this equation
doesn't represent total_mem size properly.
In addition, max_low_pfn's meaning is different in other architecture and
it is scheduled to be changed, so remove related code to max_low_pfn.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 99ffe87..1149988 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -655,14 +655,6 @@ static int __init init_machine_late(void)
 late_initcall(init_machine_late);
 
 #ifdef CONFIG_KEXEC
-static inline unsigned long long get_total_mem(void)
-{
-	unsigned long total;
-
-	total = max_low_pfn - min_low_pfn;
-	return total << PAGE_SHIFT;
-}
-
 /**
  * reserve_crashkernel() - reserves memory are for crash kernel
  *
@@ -677,7 +669,7 @@ static void __init reserve_crashkernel(void)
 	unsigned long limit = 0;
 	int ret;
 
-	total_mem = get_total_mem();
+	total_mem = memblock_phys_mem_size();
 	ret = parse_crashkernel(boot_command_line, total_mem,
 				&crash_size, &crash_base);
 	if (ret != 0 || crash_size == 0)
-- 
1.7.9.5

