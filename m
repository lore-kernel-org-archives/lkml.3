Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaKXPne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:43:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:3774 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752589AbaKXPnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:43:33 -0500
Message-Id: <20141124154331.796019188@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 24 Nov 2014 10:42:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>
Subject: [for-next][PATCH 1/5] ktest: Use make -s kernelrelease
References: <20141124154251.345600733@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ktest-Use-make-s-kernelrelease.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Marek <mmarek@suse.cz>

The previous tail -1 broke with commit 7ff525712acf ("kbuild: fake the
"Entering directory ..." message more simply")

Link: http://lkml.kernel.org/r/20141022194408.GA20989@pobox.suse.cz

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index bf1398180785..60fe020a6e80 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2005,7 +2005,7 @@ sub get_version {
     # get the release name
     return if ($have_version);
     doprint "$make kernelrelease ... ";
-    $version = `$make kernelrelease | tail -1`;
+    $version = `$make -s kernelrelease`;
     chomp($version);
     doprint "$version\n";
     $have_version = 1;
-- 
2.1.1


