Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab3HVBtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 21:49:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60692 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab3HVBtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 21:49:14 -0400
Message-ID: <52156E0B.7020705@gmail.com>
Date: Thu, 22 Aug 2013 09:48:59 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tile: add null check for kzalloc in tile/kernel/setup.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Should check the return value of kzalloc first to avoid the null pointer.
Then can dereference the non-null pointer to access the fields of struct resource.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 arch/tile/kernel/setup.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index eceb834..7d4138c 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -1548,6 +1548,8 @@ insert_non_bus_resource(void)
 {
 	struct resource *res =
 		kzalloc(sizeof(struct resource), GFP_ATOMIC);
+	if (!res)
+		return NULL;
 	res->name = "Non-Bus Physical Address Space";
 	res->start = (1ULL << 32);
 	res->end = -1LL;
@@ -1565,6 +1567,8 @@ insert_ram_resource(u64 start_pfn, u64 end_pfn)
 {
 	struct resource *res =
 		kzalloc(sizeof(struct resource), GFP_ATOMIC);
+	if (!res)
+		return NULL;
 	res->name = "System RAM";
 	res->start = start_pfn << PAGE_SHIFT;
 	res->end = (end_pfn << PAGE_SHIFT) - 1;
-- 
1.7.10.4
