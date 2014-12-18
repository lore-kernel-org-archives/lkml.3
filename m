Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaLRU1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 15:27:22 -0500
Received: from mail-bn1bon0078.outbound.protection.outlook.com ([157.56.111.78]:43904
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751125AbaLRU1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 15:27:21 -0500
X-Greylist: delayed 849 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Dec 2014 15:27:21 EST
From: Derek Chickles <dchickles@caviumnetworks.com>
To: <joe@perches.com>
CC: <apw@canonical.com>, <computersforpeace@gmail.com>,
        <linux-kernel@vger.kernel.org>, <cernekee@gmail.com>,
        Derek Chickles <dchickles@caviumnetworks.com>,
        Derek Chickles <derek.chickles@caviumnetworks.com>
Subject: [PATCH] checkpatch: Fix MAINTAINERS search pattern
Date: Thu, 18 Dec 2014 12:12:13 -0800
Message-ID: <1418933533-8364-1-git-send-email-dchickles@caviumnetworks.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1418801732-19141-1-git-send-email-computersforpeace@gmail.com>
References: <1418801732-19141-1-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.2.3.194]
X-ClientProxiedBy: CY1PR00CA0014.namprd00.prod.outlook.com (25.160.142.152) To
 DM2PR07MB493.namprd07.prod.outlook.com (10.141.159.139)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Derek.Chickles@caviumnetworks.com; 
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR07MB493;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR07MB493;
X-Forefront-PRVS: 042957ACD7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(99396003)(101416001)(40100003)(122386002)(120916001)(229853001)(110136001)(107046002)(2351001)(81156004)(106356001)(105586002)(31966008)(36756003)(89996001)(21056001)(92566001)(575784001)(87976001)(19580395003)(19580405001)(69596002)(50466002)(47776003)(64706001)(20776003)(48376002)(76176999)(66066001)(50986999)(2950100001)(62966003)(97736003)(77156002)(68736005)(46102003)(77096005)(33646002)(53416004)(42186005)(4396001)(50226001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR07MB493;H:dclinux.caveonetworks.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR07MB493;
X-OriginatorOrg: caviumnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2014 20:13:09.5760 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR07MB493
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the check that was supposed to prevent the MAINTAINERS
warning from appearing when you run checkpatch.pl on a patch that
includes new files/directories and an updated MAINTAINERS file.

Signed-off-by: Derek Chickles <derek.chickles@caviumnetworks.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f0bb6d6..6f10ebb 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2085,7 +2085,7 @@ sub process {
 
 # Check if MAINTAINERS is being updated.  If so, there's probably no need to
 # emit the "does MAINTAINERS need updating?" message on file add/move/delete
-		if ($line =~ /^\s*MAINTAINERS\s*\|/) {
+		if ($realfile =~ /MAINTAINERS/) {
 			$reported_maintainer_file = 1;
 		}
 
-- 
1.8.3.1

