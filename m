Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3CFUC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:02:29 -0500
Received: from mail-gh0-f180.google.com ([209.85.160.180]:60130 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3CFUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:02:28 -0500
From: "Raphael S.Carvalho" <raphael.scarv@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org,
        "Raphael S.Carvalho" <raphael.scarv@gmail.com>
Subject: [PATCH 1/1] pid_namespace.c/.h: Simplifying defines.
Date: Wed,  6 Mar 2013 16:38:06 -0300
Message-Id: <1362598686-3933-1-git-send-email-raphael.scarv@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes BITS_PER_PAGE from pid_namespace.c and put
it into pid_namespace.h instead, since we can simplify the
define PID_MAP_ENTRIES by using the BITS_PER_PAGE.

Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>
---
 include/linux/pid_namespace.h |    3 ++-
 kernel/pid_namespace.c        |    2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 215e5e3..e4ae945 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -13,7 +13,8 @@ struct pidmap {
        void *page;
 };
 
-#define PIDMAP_ENTRIES         ((PID_MAX_LIMIT + 8*PAGE_SIZE - 1)/PAGE_SIZE/8)
+#define BITS_PER_PAGE		(PAGE_SIZE * 8)
+#define PIDMAP_ENTRIES		((PID_MAX_LIMIT+BITS_PER_PAGE-1)/BITS_PER_PAGE)
 
 struct bsd_acct_struct;
 
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index c1c3dc1..f158e27 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -19,8 +19,6 @@
 #include <linux/reboot.h>
 #include <linux/export.h>
 
-#define BITS_PER_PAGE		(PAGE_SIZE*8)
-
 struct pid_cache {
 	int nr_ids;
 	char name[16];
-- 
1.7.2.5

