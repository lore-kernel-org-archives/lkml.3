Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab3KRXXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:23:10 -0500
Received: from smtprelay0219.hostedemail.com ([216.40.44.219]:52998 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751730Ab3KRXXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:23:06 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3866:4605:5007:7652:10004:10400:10848:11026:11473:11658:11914:12043:12438:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crush38_8f3d89e04f516
X-Filterd-Recvd-Size: 2014
Message-ID: <1384816981.17783.10.camel@joe-AO722>
Subject: [PATCH] checkpatch.pl: Check for function declarations without
 arguments
From: Joe Perches <joe@perches.com>
To: Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, apw@canonical.com,
        bp@alien8.de
Date: Mon, 18 Nov 2013 15:23:01 -0800
In-Reply-To: <1823702.CebDozRkek@sandpuppy>
References: <1384813914-11491-1-git-send-email-richard@nod.at>
	 <1384814182.17783.5.camel@joe-AO722> <1823702.CebDozRkek@sandpuppy>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions like this one are evil:

void foo()
{
	...
}

Because these functions allow variadic arguments without
checking the arguments at all.
 
Original-patch-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 61090e0..2e1ff0c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2634,6 +2634,15 @@ sub process {
 				$herecurr);
                }
 
+# check for function declarations without arguments like "int foo()"
+		if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
+			if (ERROR("FUNCTION_WITHOUT_ARGS",
+				  "Bad function definition - $1() should probably be $1(void)\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/(\b($Type)\s+($Ident))\s*\(\s*\)/$2 $3(void)/;
+			}
+		}
+
 # check for declarations of struct pci_device_id
 		if ($line =~ /\bstruct\s+pci_device_id\s+\w+\s*\[\s*\]\s*\=\s*\{/) {
 			WARN("DEFINE_PCI_DEVICE_TABLE",


