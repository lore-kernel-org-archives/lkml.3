Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab3BYWfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:35:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759614Ab3BYWT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:19:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [ 03/58] x86-32, mm: Remove reference to resume_map_numa_kva()
Date: Mon, 25 Feb 2013 14:18:59 -0800
Message-Id: <20130225221636.807768154@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
 


