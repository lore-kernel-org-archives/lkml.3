Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaKKJNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 04:13:54 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:38552 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaKKJNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 04:13:52 -0500
Message-ID: <5461D343.60803@huawei.com>
Date: Tue, 11 Nov 2014 17:13:39 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Linux MM <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
CC: <wangnan0@huawei.com>
Subject: [PATCH] memory-hotplug: remove redundant call of page_to_pfn
References: <1415697184-26409-1-git-send-email-zhenzhang.zhang@huawei.com>
In-Reply-To: <1415697184-26409-1-git-send-email-zhenzhang.zhang@huawei.com>
X-Forwarded-Message-Id: <1415697184-26409-1-git-send-email-zhenzhang.zhang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.77]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020209.5461D34E.0137,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 33d34fd3bdc8e32130f576a369758c89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The start_pfn can be obtained directly by
phys_index << PFN_SECTION_SHIFT.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 drivers/base/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 7c5d871..85be040 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -228,8 +228,8 @@ memory_block_action(unsigned long phys_index, unsigned long action, int online_t
 	struct page *first_page;
 	int ret;

-	first_page = pfn_to_page(phys_index << PFN_SECTION_SHIFT);
-	start_pfn = page_to_pfn(first_page);
+	start_pfn = phys_index << PFN_SECTION_SHIFT;
+	first_page = pfn_to_page(start_pfn);

 	switch (action) {
 		case MEM_ONLINE:
-- 
1.8.1.4


.




