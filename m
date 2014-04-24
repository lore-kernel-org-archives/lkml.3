Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbaDXQKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:10:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:34118 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758714AbaDXQIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:08:54 -0400
Message-Id: <20140424160851.216914433@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:06:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 6/7] ktest: Add the config bisect manual back
References: <20140424160626.491010573@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0006-ktest-Add-the-config-bisect-manual-back.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

After the rewrite of the config bisect, the bisect manual was
removed. Add it back.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 8805668..55ab700 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2923,7 +2923,13 @@ sub compare_configs {
 sub run_config_bisect_test {
     my ($type) = @_;
 
-    return run_bisect_test $type, "oldconfig";
+    my $ret = run_bisect_test $type, "oldconfig";
+
+    if ($bisect_manual) {
+	$ret = answer_bisect;
+    }
+
+    return $ret;
 }
 
 sub process_failed {
-- 
1.8.5.3


