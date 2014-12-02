Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbaLBUNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:13:14 -0500
Received: from mail-bn1bon0143.outbound.protection.outlook.com ([157.56.111.143]:37047
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933012AbaLBUNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:13:13 -0500
X-Greylist: delayed 3633 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 15:13:13 EST
From: Tom Huynh <tom.huynh@freescale.com>
To: <mingo@redhat.com>, <acme@kernel.org>, <namhyung@kernel.org>,
        <jolsa@kernel.org>
CC: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <kim.phillips@freescale.com>,
        <linux-kernel@vger.kernel.org>, <mmullins@mmlx.us>,
        Tom Huynh <tom.huynh@freescale.com>
Subject: [PATCHv2] perf hists: change print format from lu to PRIu64
Date: Tue, 2 Dec 2014 11:37:22 -0600
Message-ID: <1417541842-9747-1-git-send-email-tom.huynh@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(69596002)(44976005)(19580405001)(84676001)(6806004)(19580395003)(64706001)(47776003)(20776003)(92726001)(50226001)(50986999)(92566001)(2201001)(4396001)(93916002)(21056001)(31966008)(105606002)(86362001)(95666004)(106466001)(81156004)(107046002)(229853001)(89996001)(88136002)(87286001)(62966003)(77156002)(87936001)(104016003)(48376002)(102836001)(57986006)(33646002)(104166001)(46102003)(36756003)(76506005)(50466002)(99396003)(120916001)(68736005)(97736003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0737;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0737;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0737;
X-Forefront-PRVS: 0413C9F1ED
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=tom.huynh@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0737;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_events in tools/perf/ui/browsers/hists.c is of type u64, so the print
format (%lu) causes perf report to show 0 event count when running with 
32-bit userspace without redirection. This patch fixes that problem by
printing nr_events as PRIu64. 

Signed-off-by: Tom Huynh <tom.huynh@freescale.com>
---
change since v1: replace %llu with PRIu64

 tools/perf/ui/browsers/hists.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index cfb976b..c6d68b8 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1254,7 +1254,7 @@ static int hists__browser_title(struct hists *hists,
 
 	nr_samples = convert_unit(nr_samples, &unit);
 	printed = scnprintf(bf, size,
-			   "Samples: %lu%c of event '%s', Event count (approx.): %lu",
+			   "Samples: %lu%c of event '%s', Event count (approx.): %" PRIu64,
 			   nr_samples, unit, ev_name, nr_events);
 
 
-- 
1.9.1

