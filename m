Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaEUFgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:36:18 -0400
Received: from mail1.windriver.com ([147.11.146.13]:48590 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaEUFgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:36:17 -0400
From: Yong Zhang <yong.zhang@windriver.com>
To: <ralf@linux-mips.org>, <huawei.libin@huawei.com>
CC: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] MIPS: change type of asid_cache to unsigned long
Date: Wed, 21 May 2014 13:36:03 +0800
Message-ID: <1400650563-1033-1-git-send-email-yong.zhang@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asid_cache must be unsigned long otherwise on 64bit system
it will become 0 if the value in get_new_mmu_context()
reaches 0xffffffff and in the end the assumption of
ASID_FIRST_VERSION is not true anymore thus leads to
more dangerous things.

Reported-by: libin <huawei.libin@huawei.com>
Signed-off-by: Yong Zhang <yong.zhang@windriver.com>
---

V2<-V1: Add the reporter.

 arch/mips/include/asm/cpu-info.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/cpu-info.h b/arch/mips/include/asm/cpu-info.h
index f6299be..ebcc2ed 100644
--- a/arch/mips/include/asm/cpu-info.h
+++ b/arch/mips/include/asm/cpu-info.h
@@ -40,7 +40,7 @@ struct cache_desc {
 
 struct cpuinfo_mips {
 	unsigned int		udelay_val;
-	unsigned int		asid_cache;
+	unsigned long		asid_cache;
 
 	/*
 	 * Capability and feature descriptor structure for MIPS CPU
-- 
1.7.9.5

