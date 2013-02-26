Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760655Ab3B0BWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:22:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759827Ab3BZX47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:56:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [ 002/150] x86-32, mm: Remove reference to resume_map_numa_kva()
Date: Tue, 26 Feb 2013 15:54:19 -0800
Message-Id: <20130226235524.246484699@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit bb112aec5ee41427e9b9726e3d57b896709598ed upstream.

Remove reference to removed function resume_map_numa_kva().

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20130131005616.1C79F411@kernel.stglabs.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/mmzone_32.h |    6 ------
 arch/x86/power/hibernate_32.c    |    2 --
 2 files changed, 8 deletions(-)

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
--- a/arch/x86/power/hibernate_32.c
+++ b/arch/x86/power/hibernate_32.c
@@ -129,8 +129,6 @@ static int resume_physical_mapping_init(
 		}
 	}
 
-	resume_map_numa_kva(pgd_base);
-
 	return 0;
 }
 


