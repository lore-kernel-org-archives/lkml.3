Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934527Ab3IDKmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 06:42:45 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:47298 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760292Ab3IDKmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:42:43 -0400
Message-ID: <52270E64.20401@huawei.com>
Date: Wed, 4 Sep 2013 18:41:40 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>, <james.hogan@imgtec.com>,
        <monstr@monstr.eu>, <benh@kernel.crashing.org>, <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Xishi Qiu <qiuxishi@huawei.com>, <microblaze-uclinux@itee.uq.edu.au>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 2/2] mm/driver: use __free_reserved_page() to simplify the
 code
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __free_reserved_page() to simplify the code in the others.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 drivers/video/acornfb.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/video/acornfb.c b/drivers/video/acornfb.c
index 6488a73..4ef302a 100644
--- a/drivers/video/acornfb.c
+++ b/drivers/video/acornfb.c
@@ -1205,9 +1205,7 @@ free_unused_pages(unsigned int virtual_start, unsigned int virtual_end)
 		 * the page.
 		 */
 		page = virt_to_page(virtual_start);
-		ClearPageReserved(page);
-		init_page_count(page);
-		free_page(virtual_start);
+		__free_reserved_page(page);
 
 		virtual_start += PAGE_SIZE;
 		mb_freed += PAGE_SIZE / 1024;
-- 
1.7.1


