Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaBZTKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:10:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:20204 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbaBZTJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:09:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,549,1389772800"; 
   d="scan'208";a="490301652"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/4] x86: Use clflushopt in drm_clflush_virt_range
Date: Wed, 26 Feb 2014 12:06:52 -0700
Message-Id: <1393441612-19729-5-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393441612-19729-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1393441612-19729-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If clflushopt is available on the system, use it instead of clflush in
drm_clflush_virt_range.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: H Peter Anvin <h.peter.anvin@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/gpu/drm/drm_cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index c518fb6..534cb89 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -139,7 +139,7 @@ drm_clflush_virt_range(char *addr, unsigned long length)
 		mb();
 		for (; addr < end; addr += boot_cpu_data.x86_clflush_size)
 			clflush(addr);
-		clflush(end - 1);
+		clflushopt(end - 1);
 		mb();
 		return;
 	}
-- 
1.7.10.4

