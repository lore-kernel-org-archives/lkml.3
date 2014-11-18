Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019AbaKRXQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:16:08 -0500
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:19136
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932188AbaKRXQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:16:05 -0500
From: Tom Huynh <tom.huynh@freescale.com>
To: <mingo@redhat.com>, <acme@kernel.org>, <namhyung@kernel.org>,
        <jolsa@kernel.org>
CC: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <kim.phillips@freescale.com>,
        <linux-kernel@vger.kernel.org>, Tom Huynh <tom.huynh@freescale.com>
Subject: [PATCH] perf hist browser: change print format from lu to llu to fit u64 type
Date: Tue, 18 Nov 2014 17:00:27 -0600
Message-ID: <1416351627-360-1-git-send-email-tom.huynh@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(50466002)(21056001)(120916001)(104016003)(68736004)(99396003)(48376002)(19580395003)(44976005)(6806004)(19580405001)(50226001)(106466001)(33646002)(229853001)(62966003)(4396001)(95666004)(36756003)(105606002)(102836001)(77156002)(107046002)(76506005)(20776003)(92726001)(87936001)(97736003)(47776003)(2201001)(57986006)(46102003)(93916002)(84676001)(64706001)(86362001)(31966008)(104166001)(92566001)(88136002)(87286001)(89996001)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0747;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0747;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0747;
X-Forefront-PRVS: 039975700A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=tom.huynh@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0747;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_events in tools/perf/ui/browsers/hists.c is of type u64, thus it should
be printed as %llu instead of %lu. The print format %lu causes perf report
to show 0 event count when running with 32-bit userspace without 
redirection. This patch fixes that problem.

Signed-off-by: Tom Huynh <tom.huynh@freescale.com>
---
 tools/perf/ui/browsers/hists.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index cfb976b..49b2471 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1254,7 +1254,7 @@ static int hists__browser_title(struct hists *hists,
 
 	nr_samples = convert_unit(nr_samples, &unit);
 	printed = scnprintf(bf, size,
-			   "Samples: %lu%c of event '%s', Event count (approx.): %lu",
+			   "Samples: %lu%c of event '%s', Event count (approx.): %llu",
 			   nr_samples, unit, ev_name, nr_events);
 
 
-- 
1.9.1

