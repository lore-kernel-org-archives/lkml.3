Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab3FROMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:12:32 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:64508 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855Ab3FROMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:12:31 -0400
Message-ID: <51C06AC9.2010505@gmail.com>
Date: Tue, 18 Jun 2013 22:12:25 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: Remove unused function __put_page
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

This function is nowhere used, and it has a confusing name with
put_page in mm/swap.c. So better to remove it.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/internal.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 8562de0..4390ac6 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -32,11 +32,6 @@ static inline void set_page_refcounted(struct page *page)
 	set_page_count(page, 1);
 }
 
-static inline void __put_page(struct page *page)
-{
-	atomic_dec(&page->_count);
-}
-
 static inline void __get_page_tail_foll(struct page *page,
 					bool get_page_head)
 {
-- 
1.7.1
