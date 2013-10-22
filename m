Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3JVQNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:13:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:61399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab3JVQND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:13:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="396828244"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        x86@kernel.org
Subject: [PATCH 02/11] asmlinkage: Make __iowrite32_copy visible
Date: Tue, 22 Oct 2013 09:12:17 -0700
Message-Id: <1382458346-24811-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This is a assembler function on x86, so it should be visible.

Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/io.h b/include/linux/io.h
index f4f42fa..8a18e75 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -24,7 +24,7 @@
 
 struct device;
 
-void __iowrite32_copy(void __iomem *to, const void *from, size_t count);
+__visible void __iowrite32_copy(void __iomem *to, const void *from, size_t count);
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
 
 #ifdef CONFIG_MMU
-- 
1.8.3.1

