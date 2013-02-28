Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab3B1Oqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:46:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41944 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab3B1Oqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 021/139] x86-32, mm: Remove reference to resume_map_numa_kva()
Date: Thu, 28 Feb 2013 14:42:51 +0000
Message-Id: <1362062689-2567-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit bb112aec5ee41427e9b9726e3d57b896709598ed upstream.

Remove reference to removed function resume_map_numa_kva().

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20130131005616.1C79F411@kernel.stglabs.ibm.com
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/include/asm/mmzone_32.h | 6 ------
 arch/x86/power/hibernate_32.c    | 2 --
 2 files changed, 8 deletions(-)

diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index eb05fb3..8a9b3e2 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -14,12 +14,6 @@ extern struct pglist_data *node_data[];
 
 #include <asm/numaq.h>
 
-extern void resume_map_numa_kva(pgd_t *pgd);
-
-#else /* !CONFIG_NUMA */
-
-static inline void resume_map_numa_kva(pgd_t *pgd) {}
-
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_DISCONTIGMEM
diff --git a/arch/x86/power/hibernate_32.c b/arch/x86/power/hibernate_32.c
index 74202c1..7d28c88 100644
--- a/arch/x86/power/hibernate_32.c
+++ b/arch/x86/power/hibernate_32.c
@@ -129,8 +129,6 @@ static int resume_physical_mapping_init(pgd_t *pgd_base)
 		}
 	}
 
-	resume_map_numa_kva(pgd_base);
-
 	return 0;
 }
 
-- 
1.8.1.2

