Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3EQOKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 10:10:44 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:44358 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab3EQOKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 10:10:43 -0400
Message-ID: <51963A5E.6000300@gmail.com>
Date: Fri, 17 May 2013 22:10:38 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Jiri Kosina <trivial@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [TRIVIAL PATCH] mm/sparse: Remove unused ret in sparse_index_init
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

The ret variable is not used in the function, so remove it and
directly return 0 at the end of the function.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/sparse.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 1c91f0d..9ac2f74 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -79,7 +79,6 @@ static int __meminit sparse_index_init(unsigned long section_nr, int nid)
 {
 	unsigned long root = SECTION_NR_TO_ROOT(section_nr);
 	struct mem_section *section;
-	int ret = 0;
 
 	if (mem_section[root])
 		return -EEXIST;
@@ -90,7 +89,7 @@ static int __meminit sparse_index_init(unsigned long section_nr, int nid)
 
 	mem_section[root] = section;
 
-	return ret;
+	return 0;
 }
 #else /* !SPARSEMEM_EXTREME */
 static inline int sparse_index_init(unsigned long section_nr, int nid)
-- 
1.7.1
