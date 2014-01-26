Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaAZKJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 05:09:57 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:4555 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaAZKJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 05:09:56 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Wang Nan <wangnan0@huawei.com>, Sasha Levin <sasha.levin@oracle.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>, Geng Hui <hui.geng@huawei.com>
Subject: [PATCH] Use realpath for srctree and objtree
Date: Sun, 26 Jan 2014 18:06:18 +0800
Message-ID: <1390730778-30366-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When BUILD_SRC contains a tailing '/', the file name used in compiling command
will contain '//', and it then goes to .o's debuginfo, confuses debugedit:

https://bugzilla.redhat.com/show_bug.cgi?id=304121

This patch uses realpath to makesure srctree and objtree don't have tailing '/'.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Geng Hui <hui.geng@huawei.com>

---
 tools/lib/lockdep/Makefile    | 4 ++--
 tools/lib/traceevent/Makefile | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
index da8b7aa..e638dd5 100644
--- a/tools/lib/lockdep/Makefile
+++ b/tools/lib/lockdep/Makefile
@@ -87,8 +87,8 @@ endif # BUILD_SRC
 # We process the rest of the Makefile if this is the final invocation of make
 ifeq ($(skip-makefile),)
 
-srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
-objtree		:= $(CURDIR)
+srctree		:= $(realpath $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR)))
+objtree		:= $(realpath $(CURDIR))
 src		:= $(srctree)
 obj		:= $(objtree)
 
diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 56d52a3..dd23171 100644
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

