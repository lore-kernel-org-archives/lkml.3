Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab3FCPeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:34:08 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:40255 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab3FCPeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:34:03 -0400
Message-ID: <51ACB764.2000808@gmail.com>
Date: Mon, 03 Jun 2013 23:33:56 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Joonsoo Kim <js1304@gmail.com>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] mm, vmalloc: Call setup_vmalloc_vm instead of insert_vmalloc_vm
References: <51ACB6DB.6040809@gmail.com>
In-Reply-To: <51ACB6DB.6040809@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Here we pass flags with only VM_ALLOC bit set, it is unnecessary
to call clear_vm_unlist to clear VM_UNLIST bit. So use setup_vmalloc_vm
instead of insert_vmalloc_vm.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/vmalloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6580c76..edbfad0 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2503,8 +2503,8 @@ found:
 
 	/* insert all vm's */
 	for (area = 0; area < nr_vms; area++)
-		insert_vmalloc_vm(vms[area], vas[area], VM_ALLOC,
-				  pcpu_get_vm_areas);
+		setup_vmalloc_vm(vms[area], vas[area], VM_ALLOC,
+				 pcpu_get_vm_areas);
 
 	kfree(vas);
 	return vms;
-- 
1.7.1

