Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3ERALL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 20:11:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53420 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756338Ab3ERALK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 20:11:10 -0400
Message-ID: <1368835868.2194.103.camel@joe-AO722>
Subject: [PATCH] checkpatch: Add --strict preference for p =
 kmalloc(sizeof(*p)...
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 17 May 2013 17:11:08 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add another test for memory allocation style to follow
Documentation/CodingStyle:

		Chapter 14: Allocating memory

The preferred form for passing a size of a struct is the following:

	p = kmalloc(sizeof(*p), ...);

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b954de5..1803907 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3495,6 +3495,14 @@ sub process {
 			     "unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
 		}
 
+# alloc style
+# p = alloc(sizeof(struct foo), ...) should be p = alloc(sizeof(*p), ...)
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*([kv][mz]alloc(?:_node)?)\s*\(\s*(sizeof\s*\(\s*struct\s+$Lval\s*\))/) {
+			CHK("ALLOC_SIZEOF_STRUCT",
+			    "Prefer $3(sizeof(*$1)...) over $3($4...)\n" . $herecurr);
+		}
+
 # check for krealloc arg reuse
 		if ($^V && $^V ge 5.10.0 &&
 		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*krealloc\s*\(\s*\1\s*,/) {


