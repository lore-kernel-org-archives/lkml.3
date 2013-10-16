Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447Ab3JPIqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:46:35 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46536 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760276Ab3JPIoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:44:22 -0400
X-AuditID: 9c930179-b7c78ae000003065-95-525e51df45ab
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 11/15] slab: remove SLAB_LIMIT
Date: Wed, 16 Oct 2013 17:44:08 +0900
Message-Id: <1381913052-23875-12-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's useless now, so remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 6ced1cc..c271d5b 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -163,8 +163,6 @@
  */
 static bool pfmemalloc_active __read_mostly;
 
-#define	SLAB_LIMIT	(((unsigned int)(~0U))-1)
-
 /*
  * struct slab
  *
@@ -626,8 +624,6 @@ static void cache_estimate(unsigned long gfporder, size_t buffer_size,
 		mgmt_size = 0;
 		nr_objs = slab_size / buffer_size;
 
-		if (nr_objs > SLAB_LIMIT)
-			nr_objs = SLAB_LIMIT;
 	} else {
 		/*
 		 * Ignore padding for the initial guess. The padding
@@ -648,9 +644,6 @@ static void cache_estimate(unsigned long gfporder, size_t buffer_size,
 		       > slab_size)
 			nr_objs--;
 
-		if (nr_objs > SLAB_LIMIT)
-			nr_objs = SLAB_LIMIT;
-
 		mgmt_size = slab_mgmt_size(nr_objs, align);
 	}
 	*num = nr_objs;
-- 
1.7.9.5

