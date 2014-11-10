Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaKJX4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:56:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:56594 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaKJXzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:55:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,356,1413270000"; 
   d="scan'208";a="605613523"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/8] percpu: Add a DEFINE_PER_CPU_2PAGE_ALIGNED
Date: Mon, 10 Nov 2014 15:55:32 -0800
Message-Id: <1415663739-25525-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Needed in a followon patch which needs to naturally align a 8K stack.
I just put it into the page aligned section. This may cause an extra
4K hole if we're unlucky.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/percpu-defs.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 420032d..cd174e7 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -163,6 +163,10 @@
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
1.9.3

