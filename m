Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaEAWpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:45:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:26683 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbaEAWpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:45:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,967,1389772800"; 
   d="scan'208";a="426563672"
From: Andi Kleen <andi@firstfloor.org>
To: hpa@zytor.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] Revert "lto: Make asmlinkage __visible"
Date: Fri,  2 May 2014 00:44:36 +0200
Message-Id: <1398984278-29319-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1398984278-29319-1-git-send-email-andi@firstfloor.org>
References: <1398984278-29319-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

As requested by Linus, revert adding __visible to asmlinkage.
Instead we add __visible explicitely to all the symbols
that need it.

This reverts commit 128ea04a9885af9629059e631ddf0cab4815b589.
---
 include/linux/linkage.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 34a513a..a6a42dd 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -12,9 +12,9 @@
 #endif
 
 #ifdef __cplusplus
-#define CPP_ASMLINKAGE extern "C" __visible
+#define CPP_ASMLINKAGE extern "C"
 #else
-#define CPP_ASMLINKAGE __visible
+#define CPP_ASMLINKAGE
 #endif
 
 #ifndef asmlinkage
-- 
1.8.5.2

