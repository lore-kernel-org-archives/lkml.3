Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbaEIVbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:31:53 -0400
Received: from smtprelay0181.hostedemail.com ([216.40.44.181]:58384 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757972AbaEIVbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:31:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3167:3352:3653:3866:3867:3868:3870:3871:5007:6119:7652:10004:10400:10848:11026:11473:11658:11914:12043:12438:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: peace37_fbf39635a433
X-Filterd-Recvd-Size: 2233
Message-ID: <1399671106.2912.21.camel@joe-AO725>
Subject: [PATCH] checkpatch: Warn on #defines ending in semicolon
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andres Freund <andres@anarazel.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andy Whitcroft <apw@canonical.com>
Date: Fri, 09 May 2014 14:31:46 -0700
In-Reply-To: <20140509103303.GC16058@pd.tnic>
References: <1399598957-7011-1-git-send-email-andres@anarazel.de>
	 <1399598957-7011-3-git-send-email-andres@anarazel.de>
	 <20140509075730.GB16058@pd.tnic> <20140509103303.GC16058@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a #define ending in a semicolon is poor style
and can lead to unexpected code paths being executed.

Warn on uses of these #define types:

	#define foo[(...)] bar;
	#define foo[(...)]	\
		bar;

Original-patch-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 34eb216..3b5651a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3782,6 +3782,17 @@ sub process {
 					WARN("DO_WHILE_MACRO_WITH_TRAILING_SEMICOLON",
 					     "do {} while (0) macros should not be semicolon terminated\n" . "$herectx");
 				}
+			} elsif ($dstat =~ /^\+\s*#\s*define\s+$Ident.*;\s*$/) {
+				$ctx =~ s/\n*$//;
+				my $cnt = statement_rawlines($ctx);
+				my $herectx = $here . "\n";
+
+				for (my $n = 0; $n < $cnt; $n++) {
+					$herectx .= raw_line($linenr, $n) . "\n";
+				}
+
+				WARN("TRAILING_SEMICOLON",
+				     "macros should not use a trailing semicolon\n" . "$herectx");
 			}
 		}
 


