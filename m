Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaJOFL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:11:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:45548 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaJOFL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:11:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,721,1406617200"; 
   d="scan'208";a="614676118"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Andi Kleen <ak@linux.intel.com>, tj@kernel.org
Subject: [PATCH 1/8] percpu: Add a DEFINE_PER_CPU_2PAGE_ALIGNED
Date: Tue, 14 Oct 2014 22:11:44 -0700
Message-Id: <1413349911-3620-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
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
index cfd5604..e6e7f38 100644
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

