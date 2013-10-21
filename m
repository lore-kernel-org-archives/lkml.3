Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3JUI6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:58:44 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:34046 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab3JUI6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:58:42 -0400
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: tj@kernel.org, cl@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: weiyang@linux.vnet.ibm.com
Subject: [PATCH 3/3] percpu: little optimization on calculating pcpu_unit_size
Date: Mon, 21 Oct 2013 16:58:13 +0800
Message-Id: <1382345893-6644-3-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
References: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102108-0260-0000-0000-000003D2B9FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcpu_unit_size exactly equals to ai->unit_size.

This patch assign this value instead of calculating from pcpu_unit_pages. Also
it reorder them to make it looks more friendly to audience.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
---
 mm/percpu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 4f710a4f..74677e0 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1300,8 +1300,8 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	pcpu_unit_offsets = unit_off;
 
 	/* determine basic parameters */
-	pcpu_unit_pages = ai->unit_size >> PAGE_SHIFT;
-	pcpu_unit_size = pcpu_unit_pages << PAGE_SHIFT;
+	pcpu_unit_size = ai->unit_size;
+	pcpu_unit_pages = pcpu_unit_size >> PAGE_SHIFT;
 	pcpu_atom_size = ai->atom_size;
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk) +
 		BITS_TO_LONGS(pcpu_unit_pages) * sizeof(unsigned long);
-- 
1.7.5.4

