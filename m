Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbaJURE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:04:29 -0400
Received: from mail-by2on0127.outbound.protection.outlook.com ([207.46.100.127]:43849
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933275AbaJURE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:04:28 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <akpm@linux-foundation.org>
CC: <joe@perches.com>, <festevam@gmail.com>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v3] checkpatch: Improve warning message for "needless if" case
Date: Tue, 21 Oct 2014 15:03:59 -0200
Message-ID: <1413911039-6792-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(81156004)(64706001)(95666004)(19580405001)(87936001)(85852003)(31966008)(110136001)(89996001)(84676001)(87286001)(6806004)(44976005)(104016003)(33646002)(88136002)(69596002)(80022003)(46102003)(68736004)(47776003)(76482002)(4396001)(19580395003)(20776003)(229853001)(97736003)(26826002)(102836001)(50986999)(50466002)(48376002)(93916002)(86362001)(92726001)(77156001)(21056001)(50226001)(92566001)(104166001)(105606002)(106466001)(2351001)(120916001)(85306004)(107046002)(99396003)(62966002)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR03MB250;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB250;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Fabio.Estevam@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an 'and' to the sentence so that it looks better:

WARNING: debugfs_remove(NULL) is safe and this check is probably not required

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v2:
- Update the commit log accordingly
Changes since v1:
- Use 'and' instead of '.'

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
+				     "$1(NULL) is safe and this check is probably not required\n" . $hereprev);
 			}
 		}
 
-- 
1.9.1

