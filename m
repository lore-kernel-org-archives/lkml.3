Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab3AaJ1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:27:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:29812 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab3AaJ1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:27:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,575,1355126400"; 
   d="scan'208";a="278976795"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH 1/3] namespaces: utsname: fix wrong comment about clone_uts_ns()
Date: Thu, 31 Jan 2013 17:28:30 +0800
Message-Id: <1359624512-23469-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the wrong comment about the return value of clone_uts_ns()

Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 kernel/utsname.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/utsname.c b/kernel/utsname.c
index 08b197e..a47fc5d 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -30,7 +30,7 @@ static struct uts_namespace *create_uts_ns(void)
 /*
  * Clone a new ns copying an original utsname, setting refcount to 1
  * @old_ns: namespace to clone
- * Return NULL on error (failure to kmalloc), new ns otherwise
+ * Return ERR_PTR(-ENOMEM) on error (failure to kmalloc), new ns otherwise
  */
 static struct uts_namespace *clone_uts_ns(struct user_namespace *user_ns,
 					  struct uts_namespace *old_ns)
-- 
1.7.7.6

