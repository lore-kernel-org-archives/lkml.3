Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbaENPlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:41:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:42203 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbaENPlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:41:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1053,1389772800"; 
   d="scan'208";a="531849170"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] drm: Missed clflushopt in drm_clflush_virt_range
Date: Wed, 14 May 2014 09:41:12 -0600
Message-Id: <1400082072-22482-1-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this commit:

2a0788dc9bc4 x86: Use clflushopt in drm_clflush_virt_range

If clflushopt is available on the system, we use it instead of clflush
in drm_clflush_virt_range.  There were two calls to clflush in this
function, but only one was changed to clflushopt.  This patch changes
the other clflush call to clflushopt.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: H Peter Anvin <h.peter.anvin@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/gpu/drm/drm_cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index 534cb89..041b73b 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -138,7 +138,7 @@ drm_clflush_virt_range(char *addr, unsigned long length)
 		char *end = addr + length;
 		mb();
 		for (; addr < end; addr += boot_cpu_data.x86_clflush_size)
-			clflush(addr);
+			clflushopt(addr);
 		clflushopt(end - 1);
 		mb();
 		return;
-- 
1.9.0

