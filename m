Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaBKVOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:14:36 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54364 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbaBKVOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:14:34 -0500
From: Laura Abbott <lauraa@codeaurora.org>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Laura Abbott <lauraa@codeaurora.org>, linux-kernel@vger.kernel.org,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robherring2@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCHv3 1/2] mm/memblock: add memblock_get_current_limit
Date: Tue, 11 Feb 2014 13:14:24 -0800
Message-Id: <1392153265-14439-2-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1392153265-14439-1-git-send-email-lauraa@codeaurora.org>
References: <1392153265-14439-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Appart from setting the limit of memblock, it's also useful to be able
to get the limit to avoid recalculating it every time. Add the function
to do so.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 include/linux/memblock.h |    2 ++
 mm/memblock.c            |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 1ef6636..8a20a51 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -252,6 +252,8 @@ static inline void memblock_dump_all(void)
 void memblock_set_current_limit(phys_addr_t limit);
 
 
+phys_addr_t memblock_get_current_limit(void);
+
 /*
  * pfn conversion functions
  *
diff --git a/mm/memblock.c b/mm/memblock.c
index 39a31e7..7fe5354 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1407,6 +1407,11 @@ void __init_memblock memblock_set_current_limit(phys_addr_t limit)
 	memblock.current_limit = limit;
 }
 
+phys_addr_t __init_memblock memblock_get_current_limit(void)
+{
+	return memblock.current_limit;
+}
+
 static void __init_memblock memblock_dump(struct memblock_type *type, char *name)
 {
 	unsigned long long base, size;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

