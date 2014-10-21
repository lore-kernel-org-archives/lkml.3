Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363AbaJURGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:06:55 -0400
Received: from mail-by2on0146.outbound.protection.outlook.com ([207.46.100.146]:56596
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933220AbaJURGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:06:53 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <joe@perches.com>
CC: <festevam@gmail.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] checkpatch: Improve warning message for "needless if" case
Date: Tue, 21 Oct 2014 12:33:44 -0200
Message-ID: <1413902024-2932-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(97736003)(26826002)(33646002)(48376002)(20776003)(47776003)(62966002)(110136001)(84676001)(87286001)(64706001)(76482002)(88136002)(104166001)(87936001)(102836001)(44976005)(68736004)(19580395003)(86362001)(19580405001)(92726001)(92566001)(104016003)(89996001)(85852003)(31966008)(50466002)(107046002)(99396003)(50226001)(77156001)(106466001)(229853001)(95666004)(105606002)(4396001)(93916002)(69596002)(6806004)(46102003)(2351001)(21056001)(80022003)(85306004)(36756003)(81156004)(120916001)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB255;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB255;
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Fabio.Estevam@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break the sentence so that it looks better:

WARNING: debugfs_remove(NULL) is safe. This check is probably not required

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d94f5d8..99653bb 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4446,7 +4446,7 @@ sub process {
 			my $expr = '\s*\(\s*' . quotemeta($1) . '\s*\)\s*;';
 			if ($line =~ /\b(kfree|usb_free_urb|debugfs_remove(?:_recursive)?)$expr/) {
 				WARN('NEEDLESS_IF',
-				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
+				     "$1(NULL) is safe. This check is probably not required\n" . $hereprev);
 			}
 		}
 
-- 
1.9.1

