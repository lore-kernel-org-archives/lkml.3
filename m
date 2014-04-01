Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaDARov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 13:44:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:8955 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbaDARot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 13:44:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,774,1389772800"; 
   d="scan'208";a="504496640"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/4] Revert "lto: Make asmlinkage __visible"
Date: Tue,  1 Apr 2014 19:32:34 +0200
Message-Id: <1396373557-3387-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1396373557-3387-1-git-send-email-andi@firstfloor.org>
References: <1396373557-3387-1-git-send-email-andi@firstfloor.org>
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

