Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3GQOaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:30:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52843 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3GQOaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:30:12 -0400
X-AuditID: cbfee68e-b7f276d000002279-1f-51e6aa7276fb
From: Heesub Shin <heesub.shin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Dongjun Shin <d.j.shin@samsung.com>,
        Sunae Seo <sunae.seo@samsung.com>, Heesub Shin <heesub@gmail.com>,
        Heesub Shin <heesub.shin@samsung.com>
Subject: [PATCH] mm: zbud: fix condition check on allocation size
Date: Wed, 17 Jul 2013 23:30:10 +0900
Message-id: <1374071410-9337-1-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t8zTd2iVc8CDf7Pt7CYs34Nm8XLQ5oW
	Jy7WWhycvYTJYvOaRUwWl3fNYbO4t+Y/q8WhfavYLRp3v2Nz4PTYOesuu8emT5PYPU7M+M3i
	8eDQZhaPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyui8tZ2pYCV7xf17K5kaGH+xdjFyckgI
	mEhM/LWMHcIWk7hwbz1bFyMXh5DAMkaJ20+PsMEUfZrawQ6RWMQoMXXzbCYIp51JonHqA6AM
	BwebgLbEoW3BIA0iAroSq57vYgapYRb4xijxpXsLI0hCWMBRon36J7B1LAKqErf3f2UBsXkF
	3CSOHtgOdZKCxLIva8GaJQSms0vsmL2NFaJBQOLb5EMsIMskBGQlNh1ghqiXlDi44gbLBEbB
	BYwMqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzFCQrpvB+PNA9aHGJOBxk1klhJNzgfGRF5J
	vKGxmZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGKsVc9/Z
	x6xn6tdXv7jb9cbDFs2K2v+LXok+qCveWxkncn1mzdpva1LqL77ltijOefd1p0BJg0PPwxmP
	DR8bzN6vqfp77Z83iWsWpBaFR4ibqL2VSnz2uYtb7pFdRsbqR+1T0zfdteufzCL0ctVqkenr
	JifGl5q9KROw8irclNok6i2s92DKCiWW4oxEQy3mouJEAGWlyB5/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t9jAd2iVc8CDSYeMbaYs34Nm8XLQ5oW
	Jy7WWhycvYTJYvOaRUwWl3fNYbO4t+Y/q8WhfavYLRp3v2Nz4PTYOesuu8emT5PYPU7M+M3i
	8eDQZhaPvi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LI
	S8xNtVVy8QnQdcvMATpKSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5jR
	eWs7U8FK9or791YyNTD+Yu1i5OSQEDCR+DS1gx3CFpO4cG89WxcjF4eQwCJGiambZzNBOO1M
	Eo1THwBVcXCwCWhLHNoWDNIgIqArser5LmaQGmaBb4wSX7q3MIIkhAUcJdqnfwKbyiKgKnF7
	/1cWEJtXwE3i6IHtUJsVJJZ9Wcs8gZF7ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzg
	iHkmvYNxVYPFIUYBDkYlHt4JYU8DhVgTy4orcw8xSnAwK4nwHlzyLFCINyWxsiq1KD++qDQn
	tfgQYzLQ9onMUqLJ+cBoziuJNzQ2MTOyNDIzNjE3NiZNWEmc92CrdaCQQHpiSWp2ampBahHM
	FiYOTqkGxv5uBy4B+7UXzM3N5ilHOSSa7dsWb2ikGyt7hFnPu/qds/K/tiU5IrIs5sHVBq9X
	BJ2ysruR3Lzm5/2IN1uuFZRz9DXe/KzCtcT68ds/gdEdr9n8jPZPP78nzCX+zYzQ9u7ilL5c
	w0q/w2fuTrvd9tFg3Ytkycr6rUVsDA0z5LlM366+8HymEktxRqKhFnNRcSIA+uj10dwCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zbud_alloc() incorrectly verifies the size of allocation limit. It
should deny the allocation request greater than (PAGE_SIZE -
ZHDR_SIZE_ALIGNED - CHUNK_SIZE), not (PAGE_SIZE - ZHDR_SIZE_ALIGNED)
which has no remaining spaces for its buddy. There is no point in
spending the entire zbud page storing only a single page, since we don't
have any benefits.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 mm/zbud.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index 9bb4710..ad1e781 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -257,7 +257,7 @@ int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
 
 	if (size <= 0 || gfp & __GFP_HIGHMEM)
 		return -EINVAL;
-	if (size > PAGE_SIZE - ZHDR_SIZE_ALIGNED)
+	if (size > PAGE_SIZE - ZHDR_SIZE_ALIGNED - CHUNK_SIZE)
 		return -ENOSPC;
 	chunks = size_to_chunks(size);
 	spin_lock(&pool->lock);
-- 
1.8.3.2

