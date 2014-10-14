Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbaJNMAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:00:03 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23377 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbaJNL7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:59:55 -0400
X-AuditID: cbfee68e-f79b46d000002b74-d9-543d103802db
From: Heesub Shin <heesub.shin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjennings@variantweb.net>
Cc: Nitin Gupta <ngupta@vflare.org>, Dan Streetman <ddstreet@ieee.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sunae Seo <sunae.seo@samsung.com>,
        Heesub Shin <heesub.shin@samsung.com>
Subject: [RFC PATCH 5/9] mm/zbud: encode zbud handle using struct page
Date: Tue, 14 Oct 2014 20:59:24 +0900
Message-id: <1413287968-13940-6-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
References: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t8zTV1LAdsQg3sXGS3mrF/DZvHykKbF
	hbbdLBYHZy9hsri8aw6bxb01/1ktNrTMYrf4dPQRm0Xj7ndsDpweTyccZPLY9GkSu8eJGb9Z
	PPq2rGL0uP6tyGPnp82sHp83yQWwR3HZpKTmZJalFunbJXBl/Pk1kaVgokxFy6Y/rA2MR8S6
	GDk4JARMJDbeNexi5AQyxSQu3FvPBmILCSxjlGh+bwoRN5HoOvKNvYuRCyi+iFFi1coVTBBF
	7UwS+9cGgcxhE9CWOLQtGCQsIhApsf3hRxaQemaBY4wS2+49YwVJCAu4SSy5s5odxGYRUJV4
	0ToBzOYVcJfYfvcfO8QyOYmTxyaD1XMKeEgsmb2DBWKXu8T52f1MIEMlBHaxS9z9dR9qkIDE
	t8mHWCCekZXYdIAZYo6kxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRES
	B307GG8esD7EKMDBqMTDKxFuEyLEmlhWXJl7iNEUaMNEZinR5HxgtOWVxBsamxlZmJqYGhuZ
	W5opifMmSP0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDofzjg8bmTh9acaeXrmsv4Srs6
	r3qjlv5ia/d3/emrDSVzol59VW841fLh3NRZfFNmcB2Z18i/lulJWJLu2wa3K3t9Gp2L313Y
	YqT6fckX7lj73zF+5XLbT+VM/VcTfioo876IuZP4EjG5syqXjopqzTd5mlsZpL5Zxnn/xruP
	Z6xrjxbZk8WmxFKckWioxVxUnAgA/fymI34CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAV0LAdsQg74FVhZz1q9hs3h5SNPi
	QttuFouDs5cwWVzeNYfN4t6a/6wWG1pmsVt8OvqIzaJx9zs2B06PpxMOMnls+jSJ3ePEjN8s
	Hn1bVjF6XP9W5LHz02ZWj8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0t
	LcyVFPISc1NtlVx8AnTdMnOALlNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAG
	EtYxZvz5NZGlYKJMRcumP6wNjEfEuhg5OSQETCS6jnxjh7DFJC7cW8/WxcjFISSwiFFi1coV
	TCAJIYF2Jon9a4O6GDk42AS0JQ5tCwYJiwhESmx/+JEFpJ5Z4BijxLZ7z1hBEsICbhJL7qwG
	G8oioCrxonUCmM0r4C6x/e4/qGVyEiePTQar5xTwkFgyewcLxC53ifOz+5kmMPIuYGRYxSia
	WpBcUJyUnmukV5yYW1yal66XnJ+7iREcac+kdzCuarA4xCjAwajEw1sQaRMixJpYVlyZe4hR
	goNZSYRXgcM2RIg3JbGyKrUoP76oNCe1+BCjKdBVE5mlRJPzgUkgryTe0NjEzMjSyMzYxNzY
	WEmc92CrdaCQQHpiSWp2ampBahFMHxMHp1QDo5H0tD9tLjx7fi4vfmNpZ2fbmPD/PPvCp3t3
	7/eV5A84/OVzcMS1w8qveGTyhVQmCOotOLln/tbTpZeev7jXfCBvLqf7hJtpmxLLM79LqWy5
	rjWFW8nEQ3PNTE01vdNPT7NnTJn95WrLualGjfvuzg8wdbHQn7PxxMUZPOdKPywUVd1Z2NYQ
	NUOJpTgj0VCLuag4EQCImr5IygIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for further patches, this patch changes the way of
encoding zbud handle. Currently, zbud handle is actually just a virtual
address that is casted to unsigned long before return back. Exporting
the address to clients would be inappropriate if we use highmem pages
for zbud pages, which will be implemented by following patches.

Change the zbud handle to struct page* with the least significant bit
indicating the first or last. All other information are hidden in the
struct page.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 mm/zbud.c | 50 ++++++++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index 193ea4f..383bab0 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -240,35 +240,32 @@ static void free_zbud_page(struct zbud_header *zhdr)
 	__free_page(virt_to_page(zhdr));
 }
 
+static int is_last_chunk(unsigned long handle)
+{
+	return (handle & LAST) == LAST;
+}
+
 /*
  * Encodes the handle of a particular buddy within a zbud page
  * Pool lock should be held as this function accesses first|last_chunks
  */
-static unsigned long encode_handle(struct zbud_header *zhdr, enum buddy bud)
+static unsigned long encode_handle(struct page *page, enum buddy bud)
 {
-	unsigned long handle;
-	struct page *page = virt_to_page(zhdr);
+	return (unsigned long) page | bud;
+}
 
-	/*
-	 * For now, the encoded handle is actually just the pointer to the data
-	 * but this might not always be the case.  A little information hiding.
-	 * Add CHUNK_SIZE to the handle if it is the first allocation to jump
-	 * over the zbud header in the first chunk.
-	 */
-	handle = (unsigned long)zhdr;
-	if (bud == FIRST)
-		/* skip over zbud header */
-		handle += ZHDR_SIZE_ALIGNED;
-	else /* bud == LAST */
-		handle += PAGE_SIZE -
-				(get_num_chunks(page, LAST) << CHUNK_SHIFT);
-	return handle;
+/* Returns struct page of the zbud page where a given handle is stored */
+static struct page *handle_to_zbud_page(unsigned long handle)
+{
+	return (struct page *) (handle & ~LAST);
 }
 
 /* Returns the zbud page where a given handle is stored */
 static struct zbud_header *handle_to_zbud_header(unsigned long handle)
 {
-	return (struct zbud_header *)(handle & PAGE_MASK);
+	struct page *page = handle_to_zbud_page(handle);
+
+	return page_address(page);
 }
 
 /* Returns the number of free chunks in a zbud page */
@@ -395,7 +392,7 @@ found:
 		list_del(&page->lru);
 	list_add(&page->lru, &pool->lru);
 
-	*handle = encode_handle(zhdr, bud);
+	*handle = encode_handle(page, bud);
 	spin_unlock(&pool->lock);
 
 	return 0;
@@ -514,9 +511,9 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 		first_handle = 0;
 		last_handle = 0;
 		if (get_num_chunks(page, FIRST))
-			first_handle = encode_handle(zhdr, FIRST);
+			first_handle = encode_handle(page, FIRST);
 		if (get_num_chunks(page, LAST))
-			last_handle = encode_handle(zhdr, LAST);
+			last_handle = encode_handle(page, LAST);
 		spin_unlock(&pool->lock);
 
 		/* Issue the eviction callback(s) */
@@ -570,7 +567,16 @@ next:
  */
 void *zbud_map(struct zbud_pool *pool, unsigned long handle)
 {
-	return (void *)(handle);
+	size_t offset;
+	struct page *page = handle_to_zbud_page(handle);
+
+	if (is_last_chunk(handle))
+		offset = PAGE_SIZE -
+				(get_num_chunks(page, LAST) << CHUNK_SHIFT);
+	else
+		offset = ZHDR_SIZE_ALIGNED;
+
+	return (unsigned char *) page_address(page) + offset;
 }
 
 /**
-- 
1.9.1

