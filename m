Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbaBHBrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 20:47:12 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:32690 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBHBrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 20:47:11 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Sasha Levin <sasha.levin@oracle.com>, Wang Nan <wangnan0@huawei.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Geng Hui" <hui.geng@huawei.com>
Subject: [PATCH resend 1/2] liblockdep: Use realpath for srctree and objtree
Date: Sat, 8 Feb 2014 09:43:40 +0800
Message-ID: <1391823820-11154-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1390730778-30366-1-git-send-email-wangnan0@huawei.com>
References: <1390730778-30366-1-git-send-email-wangnan0@huawei.com>
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
Acked-by: Sasha Levin <sasha.levin@oracle.com> 
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geng Hui <hui.geng@huawei.com>

---
 tools/lib/lockdep/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
 
-- 
1.8.4

