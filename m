Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaBXTAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:00:52 -0500
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59745 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbaBXTAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:00:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: rostedt@goodmis.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2 5/6] ftrace: Remove freelist from struct dyn_ftrace
Date: Mon, 24 Feb 2014 20:00:00 +0100
Message-Id: <1393268401-24379-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1393268401-24379-1-git-send-email-jslaby@suse.cz>
References: <1393268401-24379-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'freelist' member was introduced to 'struct dyn_ftrace' in commit
ee000b7f9fe429d2470c674ccec8d344f6789e0d (tracing: use union for
multi-usages field), but the use of this member was later removed in
3208230983a0ee3d95be22d463257e530c684956 (ftrace: Remove usage of
"freed" records). Remove also the 'freelist' member now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/ftrace.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 1bbb2cd631de..20da0561b868 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -330,12 +330,9 @@ enum {
 #define FTRACE_REF_MAX		((1UL << 29) - 1)
 
 struct dyn_ftrace {
-	union {
-		unsigned long		ip; /* address of mcount call-site */
-		struct dyn_ftrace	*freelist;
-	};
+	unsigned long		ip; /* address of mcount call-site */
 	unsigned long		flags;
-	struct dyn_arch_ftrace		arch;
+	struct dyn_arch_ftrace	arch;
 };
 
 int ftrace_force_update(void);
-- 
1.8.5.2

