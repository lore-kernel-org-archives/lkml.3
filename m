Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaLHHrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:47:52 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:18696 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007AbaLHHrv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:47:51 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
        "'riel@redhat.com'" <riel@redhat.com>,
        "'nasa4836@gmail.com'" <nasa4836@gmail.com>,
        "'sasha.levin@oracle.com'" <sasha.levin@oracle.com>
Date: Mon, 8 Dec 2014 15:47:47 +0800
Subject: [PATCH] mm:add VM_BUG_ON() for page_mapcount()
Thread-Topic: [PATCH] mm:add VM_BUG_ON() for page_mapcount()
Thread-Index: AdAQaYTRBP+XSfzeRTCVl77g86jARgACuLQwAJFpAgA=
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B313F5@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E688B313F1@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E688B313F1@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add VM_BUG_ON() for slab page,
because _mapcount is an union with slab struct in struct page,
avoid access _mapcount if this page is a slab page.
Also remove the unneeded bracket.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 include/linux/mm.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 11b65cf..34124c4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -373,7 +373,8 @@ static inline void reset_page_mapcount(struct page *page)
 
 static inline int page_mapcount(struct page *page)
 {
-	return atomic_read(&(page)->_mapcount) + 1;
+	VM_BUG_ON(PageSlab(page));
+	return atomic_read(&page->_mapcount) + 1;
 }
 
 static inline int page_count(struct page *page)
-- 
2.1.3
