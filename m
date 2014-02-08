Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaBHHzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:55:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:27308 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbaBHHxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:53:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="480008624"
From: Andi Kleen <ak@linux.intel.com>
To: akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/14] asmlinkage: Make __iowrite32_copy visible
Date: Sat,  8 Feb 2014 08:51:58 +0100
Message-Id: <1391845930-28580-2-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.8.5.2

