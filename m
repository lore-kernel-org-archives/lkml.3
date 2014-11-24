Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaKXPnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:43:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:3774 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753605AbaKXPnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:43:35 -0500
Message-Id: <20141124154332.398031894@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 24 Nov 2014 10:42:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>
Subject: [for-next][PATCH 5/5] ktest: Add back "tail -1" to kernelrelease make
References: <20141124154251.345600733@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-ktest-Add-back-tail-1-to-kernelrelease-make.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Commit 52d21580b362 "ktest: Use make -s kernelrelease" fixed commit
7ff525712acf "kbuild: fake the "Entering directory ..." message more simply"
as that commit added output after the make kernelrelease. But there's still
some build scripts that are used by ktest that has output before the make
is executed, and requires that only the last line is printed.

Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 35b118a38c2f..b9cd036f0442 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2002,7 +2002,7 @@ sub get_version {
     # get the release name
     return if ($have_version);
     doprint "$make kernelrelease ... ";
-    $version = `$make -s kernelrelease`;
+    $version = `$make -s kernelrelease | tail -1`;
     chomp($version);
     doprint "$version\n";
     $have_version = 1;
-- 
2.1.1


