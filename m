Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbaAWTiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:38:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851AbaAWTeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:34:23 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        akpm@linux-foundation.org, peterz@infradead.org, oleg@redhat.com
Subject: [PATCH 2/7] compiler: CONST_CAST makes writing const vars easier and obvious
Date: Thu, 23 Jan 2014 14:32:35 -0500
Message-Id: <babdd17e096254db6001c49d3940caf5f65d62a8.1390495874.git.rgb@redhat.com>
In-Reply-To: <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
References: <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
In-Reply-To: <cover.1390495874.git.rgb@redhat.com>
References: <cover.1390495874.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are vars that would benefit from making it more difficult or obvious to
overwrite by setting them to const.  This macro makes it easier to do so
avoiding typos while making it easier to find such instances.

Oleg Nesterov deserves full credit for this patch.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/compiler.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 92669cd..eaaf273 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -357,4 +357,12 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #else
 # define __kprobes
 #endif
+
+/* Make it easier to find and get right making a const writable */
+#define CONST_CAST(type, lval)			\
+	(*({					\
+		(void)((type *)0 == &(lval));	\
+		(type *)&(lval);		\
+	}))
+
 #endif /* __LINUX_COMPILER_H */
-- 
1.7.1

