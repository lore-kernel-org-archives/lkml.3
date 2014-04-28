Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443AbaD1WOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:14:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:50681 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562AbaD1WMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:12:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,946,1389772800"; 
   d="scan'208";a="425089703"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        tj@kernel.org
Subject: [PATCH 1/7] percpu: Add a DEFINE_PER_CPU_2PAGE_ALIGNED
Date: Mon, 28 Apr 2014 15:12:35 -0700
Message-Id: <1398723161-21968-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Needed in a followon patch which needs to naturally align a 8K stack.
I just put it into the page aligned section. This may cause an extra
4K hole if we're unlucky.

Cc: tj@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/percpu-defs.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index a5fc7d0..5b2f5b0 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -142,6 +142,10 @@
 	DEFINE_PER_CPU_SECTION(type, name, "..page_aligned")		\
 	__aligned(PAGE_SIZE)
 
+#define DEFINE_PER_CPU_2PAGE_ALIGNED(type, name)			\
+	DEFINE_PER_CPU_SECTION(type, name, "..page_aligned")		\
+	__aligned(2*PAGE_SIZE)
+
 /*
  * Declaration/definition used for per-CPU variables that must be read mostly.
  */
-- 
1.9.0

