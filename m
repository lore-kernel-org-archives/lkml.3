Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3KUV7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:59:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab3KUV7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:59:02 -0500
Date: Thu, 21 Nov 2013 16:43:35 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org
Subject: [PATCH] mm/bootmem.c: remove unused 'limit' variable
Message-ID: <20131121164335.066fd6aa@redhat.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Luiz capitulino <lcapitulino@redhat.com>
---
 mm/bootmem.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 90bd350..31d303e 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -655,9 +655,7 @@ restart:
 void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
 					unsigned long goal)
 {
-	unsigned long limit = 0;
-
-	return ___alloc_bootmem_nopanic(size, align, goal, limit);
+	return ___alloc_bootmem_nopanic(size, align, goal, 0);
 }
 
 static void * __init ___alloc_bootmem(unsigned long size, unsigned long align,
@@ -691,9 +689,7 @@ static void * __init ___alloc_bootmem(unsigned long size, unsigned long align,
 void * __init __alloc_bootmem(unsigned long size, unsigned long align,
 			      unsigned long goal)
 {
-	unsigned long limit = 0;
-
-	return ___alloc_bootmem(size, align, goal, limit);
+	return ___alloc_bootmem(size, align, goal, 0);
 }
 
 void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
-- 
1.8.3.1

