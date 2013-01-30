Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab3A3JlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:41:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56640 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab3A3JlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:41:21 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shli@fusionio.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm/nommu: Use get_nr_swap_pages()
Date: Wed, 30 Jan 2013 10:41:12 +0100
Message-Id: <1359538872-29910-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:4sU8zfQrpnJeN+SqvgIcTgyUfYMvsEGEs3JuJDUNn1q
 0ffu78HrmpryRDoamkiXfZktshdS4HTXLx4tKYVRS4tSh8dvb9
 eQNZKcrf5LM8OI0L/7Ljj1kcKYrjBOxTS4zzPIEEd5b6Vv4buH
 DInvki+8lTIXsd9wKy3P6Fc4F37B6J58pYBBHAzisIA47u0eSu
 N3+K3TSI1DKUJ/wUFrwdnCTIi+6yoFuPFHggobdMSvz7HQHvaV
 nb05QK64dgDwtOYNMD5eGvjiymFv2O0bRlSpDw0pMX6u3oNWni
 DuEFoE6vs3YO716ml6UNZNx9GZp/kg06tLdmUIXnokrFeZ4mHG
 PywQo/Ju6E8tOwrDMZsvD1djE70yQyK4Z07aOUqrbwAUZZdkL+
 XmD1otdP/ezn1l6xVTfJk5DPEd5KgVzNfMMZG2xf4wTKkaJuGB
 Kd9so
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a build failure introduced by commit ac07b1f ("swap: add per-
partition lock for swapfile") which changed the access pattern of the
nr_swap_pages variable but failed to update the no-MMU case.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 mm/nommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index b7fdaa7..bf74898 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1906,7 +1906,7 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 		 */
 		free -= global_page_state(NR_SHMEM);
 
-		free += nr_swap_pages;
+		free += get_nr_swap_pages();
 
 		/*
 		 * Any slabs which are created with the
-- 
1.8.1.2

