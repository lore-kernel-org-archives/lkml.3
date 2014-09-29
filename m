Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaI2Daw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 23:30:52 -0400
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:36610
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750891AbaI2Dau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 23:30:50 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>, <vbabka@suse.cz>, <mgorman@suse.de>,
        <rientjes@google.com>, <minchan@kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] mm, compaction: using uninitialized_var insteads setting 'flags' to 0 directly.
Date: Mon, 29 Sep 2014 11:30:25 +0800
Message-ID: <1411961425-8045-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(93916002)(50226001)(48376002)(88136002)(26826002)(4396001)(85852003)(83072002)(104166001)(104016003)(87286001)(87936001)(97736003)(89996001)(47776003)(107046002)(84676001)(92566001)(92726001)(86362001)(50986999)(50466002)(6806004)(44976005)(62966002)(83322001)(69596002)(68736004)(19580395003)(19580405001)(76482002)(10300001)(90102001)(21056001)(36756003)(64706001)(106466001)(20776003)(31966008)(102836001)(95666004)(74502003)(81342003)(79102003)(80022003)(81542003)(74662003)(46102003)(77982003)(85306004)(105606002)(229853001)(81156004)(120916001)(77156001)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0611;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0611;
X-Forefront-PRVS: 034902F5BC
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting 'flags' to zero will be certainly a misleading way to avoid
warning of 'flags' may be used uninitialized. uninitialized_var is
a correct way because the warning is a false possitive.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 mm/compaction.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 92075d5..59a116d 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -344,7 +344,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 {
 	int nr_scanned = 0, total_isolated = 0;
 	struct page *cursor, *valid_page = NULL;
-	unsigned long flags = 0;
+	unsigned long uninitialized_var(flags);
 	bool locked = false;
 	unsigned long blockpfn = *start_pfn;
 
@@ -573,7 +573,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
 	struct lruvec *lruvec;
-	unsigned long flags = 0;
+	unsigned long uninitialized_var(flags);
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
 
-- 
2.1.0.27.g96db324

