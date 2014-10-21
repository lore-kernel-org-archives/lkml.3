Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbaJUQwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:52:45 -0400
Received: from mail-by2on0127.outbound.protection.outlook.com ([207.46.100.127]:23540
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932373AbaJUQwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:52:43 -0400
X-Greylist: delayed 1121 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Oct 2014 12:52:43 EDT
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <akpm@linux-foundation.org>
CC: <joe@perches.com>, <festevam@gmail.com>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2] checkpatch: Improve warning message for "needless if" case
Date: Tue, 21 Oct 2014 14:52:27 -0200
Message-ID: <1413910347-6406-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(92566001)(19580395003)(69596002)(6806004)(92726001)(44976005)(64706001)(19580405001)(68736004)(85306004)(50226001)(95666004)(2351001)(107046002)(229853001)(4396001)(105606002)(84676001)(102836001)(47776003)(81156004)(104016003)(106466001)(87936001)(33646002)(88136002)(110136001)(120916001)(87286001)(104166001)(26826002)(93916002)(20776003)(86362001)(99396003)(76482002)(89996001)(21056001)(46102003)(80022003)(48376002)(50466002)(85852003)(50986999)(31966008)(97736003)(77156001)(36756003)(62966002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB254;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB254;
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Fabio.Estevam@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break the sentence so that it looks better:

WARNING: debugfs_remove(NULL) is safe and this check is probably not required

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
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

