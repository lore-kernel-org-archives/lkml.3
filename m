Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab3AaWkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:40:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45073 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146Ab3AaWkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:40:43 -0500
Date: Thu, 31 Jan 2013 14:40:29 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-bb112aec5ee41427e9b9726e3d57b896709598ed@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dave@linux.vnet.ibm.com, stable@vger.kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dave@linux.vnet.ibm.com, tglx@linutronix.de, stable@vger.kernel.org,
        hpa@linux.intel.com
In-Reply-To: <20130131005616.1C79F411@kernel.stglabs.ibm.com>
References: <20130131005616.1C79F411@kernel.stglabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86-32, mm: Remove reference to resume_map_numa_kva(
 )
Git-Commit-ID: bb112aec5ee41427e9b9726e3d57b896709598ed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 14:40:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb112aec5ee41427e9b9726e3d57b896709598ed
Gitweb:     http://git.kernel.org/tip/bb112aec5ee41427e9b9726e3d57b896709598ed
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 31 Jan 2013 13:53:10 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 31 Jan 2013 14:12:30 -0800

x86-32, mm: Remove reference to resume_map_numa_kva()

Remove reference to removed function resume_map_numa_kva().

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20130131005616.1C79F411@kernel.stglabs.ibm.com
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
 
