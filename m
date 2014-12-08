Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaLHJ6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:58:23 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:4073 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840AbaLHJ6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:58:22 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Hillf Danton'" <hillf.zj@alibaba-inc.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 8 Dec 2014 17:58:14 +0800
Subject: [PATCH V2] mm:add VM_BUG_ON() for page_mapcount()
Thread-Topic: [PATCH V2] mm:add VM_BUG_ON() for page_mapcount()
Thread-Index: AdASyaRYNK5Lt1HlQ1KFwSk6V3BFwAAA8Bmw
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B313F9@CNBJMBX05.corpusers.net>
References: <010b01d012ca$05244060$0f6cc120$@alibaba-inc.com>
In-Reply-To: <010b01d012ca$05244060$0f6cc120$@alibaba-inc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB89wUWf024238

This patch add VM_BUG_ON_PAGE() for slab page,
because _mapcount is an union with slab struct in struct page,
avoid access _mapcount if this page is a slab page.
Also remove the unneeded bracket.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 include/linux/mm.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b464611..a117527 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -449,7 +449,8 @@ static inline void page_mapcount_reset(struct page *page)
 
 static inline int page_mapcount(struct page *page)
 {
-	return atomic_read(&(page)->_mapcount) + 1;
+	VM_BUG_ON_PAGE(PageSlab(page), page);
+	return atomic_read(&page->_mapcount) + 1;
 }
 
 static inline int page_count(struct page *page)
-- 
2.1.3
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
