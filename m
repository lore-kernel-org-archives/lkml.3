Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaBGEZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:25:49 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:29373 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaBGEZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:25:48 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Wang Nan <wangnan0@huawei.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geng Hui <hui.geng@huawei.com>
Subject: [PATCH] tools lib traceevent: Use realpath for srctree and objtree
Date: Fri, 7 Feb 2014 12:22:33 +0800
Message-ID: <1391746953-21918-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If BUILD_SRC or CURDIR contains tailing '/', the file names passed to gcc will
contain '//'. It will be contained .o's in debuginfo, then confuse debugedit:

https://bugzilla.redhat.com/show_bug.cgi?id=304121

This patch uses realpath command to makesure potential tailing '/'s are removed.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geng Hui <hui.geng@huawei.com>

---
 tools/lib/traceevent/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 005c9cc..5bb281c 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -107,8 +107,8 @@ endif # BUILD_SRC
 # We process the rest of the Makefile if this is the final invocation of make
 ifeq ($(skip-makefile),)
 
-srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
-objtree		:= $(CURDIR)
+srctree		:= $(realpath $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR)))
+objtree		:= $(realpath $(CURDIR))
 src		:= $(srctree)
 obj		:= $(objtree)
 
-- 
1.8.4

