Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934764AbaDJILt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 04:11:49 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58288 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934709AbaDJILp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 04:11:45 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: mmarek@suse.cz
Cc: akpm@linux-foundation.org, michael.opdenacker@free-electrons.com,
        tkhai@yandex.ru, linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] scripts/tags.sh: add regular expression replacement pattern for memcg
Date: Thu, 10 Apr 2014 16:11:36 +0800
Message-Id: <1397117496-22616-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, no regular expression replacement pattern for PageCgroug*
defined, which causes quite a few pain while reading code. Just get
rid of it.

Also, add a comment to inform people to add pattern for whatever new
flags they add.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 include/linux/page_cgroup.h | 6 ++++++
 scripts/tags.sh             | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index 777a524..16b4f15 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -44,6 +44,12 @@ static inline void __init page_cgroup_init(void)
 struct page_cgroup *lookup_page_cgroup(struct page *page);
 struct page *lookup_cgroup_page(struct page_cgroup *pc);
 
+/*
+ * Note, whenever you add a new flag here, please add a
+ * regular expression replacement pattern in scripts/tags.sh
+ * to inform our friendly and smart tags generator.
+ */
+
 #define TESTPCGFLAG(uname, lname)			\
 static inline int PageCgroup##uname(struct page_cgroup *pc)	\
 	{ return test_bit(PCG_##lname, &pc->flags); }
diff --git a/scripts/tags.sh b/scripts/tags.sh
index 58c4559..c0d52d1 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -171,12 +171,16 @@ exuberant()
 	--regex-c++='/PAGEFLAG\(([^,)]*).*/ClearPage\1/'		\
 	--regex-c++='/TESTSETFLAG\(([^,)]*).*/TestSetPage\1/'		\
 	--regex-c++='/TESTPAGEFLAG\(([^,)]*).*/Page\1/'			\
+	--regex-c++='/TESTPCGFLAG\(([^,)]*).*/PageCgroup\1/'		\
 	--regex-c++='/SETPAGEFLAG\(([^,)]*).*/SetPage\1/'		\
 	--regex-c++='/__SETPAGEFLAG\(([^,)]*).*/__SetPage\1/'		\
+	--regex-c++='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'		\
 	--regex-c++='/TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
 	--regex-c++='/__TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
+	--regex-c++='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
 	--regex-c++='/CLEARPAGEFLAG\(([^,)]*).*/ClearPage\1/'		\
 	--regex-c++='/__CLEARPAGEFLAG\(([^,)]*).*/__ClearPage\1/'	\
+	--regex-c++='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
 	--regex-c++='/__PAGEFLAG\(([^,)]*).*/__SetPage\1/'		\
 	--regex-c++='/__PAGEFLAG\(([^,)]*).*/__ClearPage\1/'		\
 	--regex-c++='/PAGEFLAG_FALSE\(([^,)]*).*/Page\1/'		\
@@ -229,12 +233,16 @@ emacs()
 	--regex='/PAGEFLAG(\([^,)]*\).*/ClearPage\1/'		\
 	--regex='/TESTSETFLAG(\([^,)]*\).*/TestSetPage\1/'	\
 	--regex='/TESTPAGEFLAG(\([^,)]*\).*/Page\1/'		\
+	--regex='/TESTPCGFLAG\(([^,)]*).*/PageCgroup\1/'	\
 	--regex='/SETPAGEFLAG(\([^,)]*\).*/SetPage\1/'		\
 	--regex='/__SETPAGEFLAG(\([^,)]*\).*/__SetPage\1/'	\
+	--regex='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'	\
 	--regex='/TESTCLEARFLAG(\([^,)]*\).*/TestClearPage\1/'	\
 	--regex='/__TESTCLEARFLAG(\([^,)]*\).*/TestClearPage\1/'	\
+	--regex='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
 	--regex='/CLEARPAGEFLAG(\([^,)]*\).*/ClearPage\1/'	\
 	--regex='/__CLEARPAGEFLAG(\([^,)]*\).*/__ClearPage\1/'	\
+	--regex='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
 	--regex='/__PAGEFLAG(\([^,)]*\).*/__SetPage\1/'		\
 	--regex='/__PAGEFLAG(\([^,)]*\).*/__ClearPage\1/'	\
 	--regex='/PAGEFLAG_FALSE(\([^,)]*\).*/Page\1/'		\
-- 
1.9.0.GIT

