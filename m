Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3AZTYh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 14:24:37 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:59808 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753301Ab3AZTYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 14:24:34 -0500
Message-ID: <1359228273.2079.31.camel@joe-AO722>
Subject: [PATCH] checkpatch: Add check for kcalloc argument order
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Sat, 26 Jan 2013 11:24:33 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc is sometimes misused with the
first and second arguments switched.

Same issue with kmalloc_array too.

Bleat if sizeof is the first argument

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9cec6dd..b7326af 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3476,6 +3476,12 @@ sub process {
 			     "unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
 		}
 
+# check for alloc argument mismatch
+		if ($line =~ /\b(kcalloc|kmalloc_array)\s*\(\s*sizeof\b/) {
+			WARN("ALLOC_ARRAY_ARGS",
+			     "$1 uses number as first arg, sizeof is generally wrong\n" . $herecurr);
+		}
+
 # check for multiple semicolons
 		if ($line =~ /;\s*;\s*$/) {
 			WARN("ONE_SEMICOLON",


