Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaLDLpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:45:52 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36306 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbaLDLpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:45:49 -0500
Subject: [PATCH 1/2] ftracetest: Fix to show descriptions on dash
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Thu, 04 Dec 2014 14:41:16 -0500
Message-ID: <20141204194116.7376.78940.stgit@localhost.localdomain>
In-Reply-To: <20141204194109.7376.84279.stgit@localhost.localdomain>
References: <20141204194109.7376.84279.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ftracetest doesn't show testcase's descriptions when
it is executed on dash. This fixes that to show the
descriptions on dash correctly by passing it via a variable
instead of directly passing the grep command output.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/testing/selftests/ftrace/ftracetest |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index 535b98b..e8b4021 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -135,7 +135,8 @@ TOTAL_RESULT=0
 CASENO=0
 testcase() { # testfile
   CASENO=$((CASENO+1))
-  prlog -n "[$CASENO]"`grep "^#[ \t]*description:" $1 | cut -f2 -d:`
+  desc=`grep "^#[ \t]*description:" $1 | cut -f2 -d:`
+  prlog -n "[$CASENO]$desc"
 }
 
 eval_result() { # retval sigval


