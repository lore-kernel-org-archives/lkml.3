Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaDCRFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 13:05:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33770 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbaDCRFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:05:06 -0400
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
Subject: [PATCHv5 1/2] mm/memblock: add memblock_get_current_limit
Date: Thu,  3 Apr 2014 10:04:57 -0700
Message-Id: <1396544698-15596-2-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1396544698-15596-1-git-send-email-lauraa@codeaurora.org>
References: <1396544698-15596-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apart from setting the limit of memblock, it's also useful to be able
to get the limit to avoid recalculating it every time. Add the function
to do so.

Change-Id: I4f28dc1e549fd4c7fabf4e0dbd97871dbaa318ab
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 include/linux/memblock.h | 2 ++
 mm/memblock.c            | 5 +++++
 2 files changed, 7 insertions(+)

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

