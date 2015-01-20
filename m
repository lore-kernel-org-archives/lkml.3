Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbbATUWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:22:12 -0500
Received: from mail-bn1bon0133.outbound.protection.outlook.com ([157.56.111.133]:47809
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751557AbbATUWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:22:10 -0500
Date: Tue, 20 Jan 2015 14:02:00 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Rik van Riel <riel@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Jens Axboe <axboe@fb.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH 2/2] mm: fix undefined reference to `.kernel_map_pages' on
 PPC builds
Message-ID: <20150120140200.aa7ba0eb28d95e456972e178@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(62966003)(77156002)(229853001)(106466001)(77096005)(68736005)(33646002)(104016003)(46102003)(50986999)(100306002)(92566002)(97736003)(23726002)(36756003)(87936001)(85426001)(6806004)(86362001)(50466002)(46406003)(47776003)(50226001)(64706001)(105606002)(19580395003)(19580405001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB335;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:DM2PR03MB335;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR03MB335;
X-Forefront-PRVS: 0462918D61
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB335;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2015 20:07:17.3932
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR03MB335
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible to configure DEBUG_PAGEALLOC without PAGE_POISONING on
ppc.  Fix building the generic kernel_map_pages() implementation in
this case:

  LD      init/built-in.o
mm/built-in.o: In function `free_pages_prepare':
mm/page_alloc.c:770: undefined reference to `.kernel_map_pages'
mm/built-in.o: In function `prep_new_page':
mm/page_alloc.c:933: undefined reference to `.kernel_map_pages'
mm/built-in.o: In function `map_pages':
mm/compaction.c:61: undefined reference to `.kernel_map_pages'
make: *** [vmlinux] Error 1

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 mm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/Makefile b/mm/Makefile
index 4bf586e..2956467 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 obj-$(CONFIG_KSM) += ksm.o
 obj-$(CONFIG_PAGE_POISONING) += debug-pagealloc.o
+obj-$(CONFIG_DEBUG_PAGEALLOC) += debug-pagealloc.o
 obj-$(CONFIG_SLAB) += slab.o
 obj-$(CONFIG_SLUB) += slub.o
 obj-$(CONFIG_KMEMCHECK) += kmemcheck.o
-- 
2.2.2

