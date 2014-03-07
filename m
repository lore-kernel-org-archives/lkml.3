Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaCGPOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:14:00 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:48460 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751648AbaCGPMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:07 -0500
Message-Id: <20140307151203.849335052@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 07 Mar 2014 10:09:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Ingo Molnar <mingo@redhat.com>
Subject: [for-next][PATCH 18/20] ftrace: Remove freelist from struct dyn_ftrace
References: <20140307150920.881849073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0018-ftrace-Remove-freelist-from-struct-dyn_ftrace.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

The 'freelist' member was introduced to 'struct dyn_ftrace' in commit
ee000b7f9fe429d2470c674ccec8d344f6789e0d (tracing: use union for
multi-usages field), but the use of this member was later removed in
3208230983a0ee3d95be22d463257e530c684956 (ftrace: Remove usage of
"freed" records). Remove also the 'freelist' member now.

Link: http://lkml.kernel.org/r/1393268401-24379-5-git-send-email-jslaby@suse.cz

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 1bbb2cd..20da0561 100644
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
1.8.5.3


