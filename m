Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaJXTlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:41:18 -0400
Received: from gproxy4-pub.mail.unifiedlayer.com ([69.89.23.142]:47049 "HELO
	gproxy4-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752212AbaJXTlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:41:15 -0400
X-Authority-Analysis: v=2.1 cv=e5mVF8Z/ c=1 sm=1 tr=0
 a=9W6Fsu4pMcyimqnCr1W0/w==:117 a=9W6Fsu4pMcyimqnCr1W0/w==:17 a=cNaOj0WVAAAA:8
 a=f5113yIGAAAA:8 a=TBVoxVdAAAAA:8 a=QyXUC8HyAAAA:8 a=GhZ5P8ky69gA:10
 a=noBwr2J6l1kA:10 a=EyzB-ouc0Rh-Bwj7o7UA:9
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org
Cc: jroedel@suse.de
Subject: [PATCH 1/2] mm: export find_extend_vma and handle_mm_fault for driver use
Date: Fri, 24 Oct 2014 12:34:30 -0700
Message-Id: <1414179271-7621-1-git-send-email-jbarnes@virtuousgeek.org>
X-Mailer: git-send-email 1.9.1
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets drivers like the AMD IOMMUv2 driver handle faults a bit more
simply, rather than doing tricks with page refs and get_user_pages().

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 mm/memory.c | 1 +
 mm/mmap.c   | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 1cc6bfb..969ff0c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3378,6 +3378,7 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(handle_mm_fault);
 
 #ifndef __PAGETABLE_PUD_FOLDED
 /*
diff --git a/mm/mmap.c b/mm/mmap.c
index 7f85520..2ee7971 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2359,6 +2359,8 @@ find_extend_vma(struct mm_struct *mm, unsigned long addr)
 }
 #endif
 
+EXPORT_SYMBOL_GPL(find_extend_vma);
+
 /*
  * Ok - we have the memory areas we should free on the vma list,
  * so release them, and do the vma updates.
-- 
1.9.1

