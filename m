Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaFHRLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 13:11:24 -0400
Received: from smtprelay0185.hostedemail.com ([216.40.44.185]:51621 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753461AbaFHRLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 13:11:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3871:3876:4321:5007:7652:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rub02_45e5ca47ae50a
X-Filterd-Recvd-Size: 2149
Message-ID: <1402247478.6328.5.camel@joe-AO725>
Subject: [PATCH] checkpatch: fix complex macro false positive for escaped
 constant char
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Choi Gi-yong <yong@gnoy.org>,
        Andy Whitcroft <apw@canonical.com>
Date: Sun, 08 Jun 2014 10:11:18 -0700
In-Reply-To: <1402236777-10914-1-git-send-email-yong@gnoy.org>
References: <1402236777-10914-1-git-send-email-yong@gnoy.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A single escaped constant char is not a complex macro.

Signed-off-by: Joe Perches <joe@perches.com>
---
On Sun, 2014-06-08 at 23:12 +0900, Choi Gi-yong wrote:
> diff --git a/drivers/staging/speakup/speakup_acntpc.c b/drivers/staging/speakup/speakup_acntpc.c
[]
> @@ -35,7 +35,7 @@
[]
> -#define PROCSPEECH '\r'
> +#define PROCSPEECH ('\r')

checkpatch false positive, doesn't need parenthesis

 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 010b18e..ba92493 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3757,7 +3757,7 @@ sub process {
 			    $dstat !~ /^(?:$Ident|-?$Constant),$/ &&			# 10, // foo(),
 			    $dstat !~ /^(?:$Ident|-?$Constant);$/ &&			# foo();
 			    $dstat !~ /^[!~-]?(?:$Lval|$Constant)$/ &&		# 10 // foo() // !foo // ~foo // -foo // foo->bar // foo.bar->baz
-			    $dstat !~ /^'X'$/ &&					# character constants
+			    $dstat !~ /^'X'$/ && $dstat !~ /^'XX'$/ &&			# character constants
 			    $dstat !~ /$exceptions/ &&
 			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
 			    $dstat !~ /^(?:\#\s*$Ident|\#\s*$Constant)\s*$/ &&		# stringification #foo


