Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab3FJWWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:22:19 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35076 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754083Ab3FJWWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:22:16 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] checkpatch: Improve "no space after cast" test
Date: Mon, 10 Jun 2013 15:20:48 -0700
Message-Id: <13259df474cdfc1dfe382c2d335c4e2e60f0da10.1370902448.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370902448.git.joe@perches.com>
References: <cover.1370902448.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some false positives exist on this test.

For instance:
	*va_arg(args, signed char *) = val.s;
or
	memset(foo, 0, sizeof(struct bar *) * baz));

Ignore lines that have an arithmetic operator or assignment
after what appears to be a cast to a pointer "(foo *)".

Add $Arithmetic convenience variable.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c2d223c..ab39ceb 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -241,10 +241,11 @@ our $Float	= qr{$Float_hex|$Float_dec|$Float_int};
 our $Constant	= qr{$Float|$Binary|$Hex|$Int};
 our $Assignment	= qr{\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=};
 our $Compare    = qr{<=|>=|==|!=|<|>};
+our $Arithmetic = qr{\+|-|\*|\/|%};
 our $Operators	= qr{
 			<=|>=|==|!=|
 			=>|->|<<|>>|<|>|!|~|
-			&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%
+			&&|\|\||,|\^|\+\+|--|&|\||$Arithmetic
 		  }x;
 
 our $NonptrType;
@@ -1885,7 +1886,7 @@ sub process {
 			}
 		}
 
-		if ($line =~ /^\+.*\*[ \t]*\)[ \t]+/) {
+		if ($line =~ /^\+.*\*[ \t]*\)[ \t]+(?!$Assignment|$Arithmetic)/) {
 			CHK("SPACING",
 			    "No space is necessary after a cast\n" . $hereprev);
 		}
-- 
1.8.1.2.459.gbcd45b4.dirty

