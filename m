Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaK1SbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:31:24 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:57158 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaK1SYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:13 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 03/30] cputime: Introduce nsecs_to_cputime64()
Date: Fri, 28 Nov 2014 19:23:33 +0100
Message-Id: <1417199040-21044-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be needed for the conversion of kernel stat to nsecs.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/cputime.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/cputime.h b/include/linux/cputime.h
index f2eb2ee..a225ab9 100644
--- a/include/linux/cputime.h
+++ b/include/linux/cputime.h
@@ -13,4 +13,14 @@
 	usecs_to_cputime((__nsecs) / NSEC_PER_USEC)
 #endif
 
+#ifndef nsecs_to_cputime
+# define nsecs_to_cputime(__nsecs)	\
+	usecs_to_cputime((__nsecs) / NSEC_PER_USEC)
+#endif
+
+#ifndef nsecs_to_cputime64
+# define nsecs_to_cputime64(__nsecs)	\
+	((__force cputime64_t) nsecs_to_cputime(__nsecs))
+#endif
+
 #endif /* __LINUX_CPUTIME_H */
-- 
2.1.3

