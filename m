Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070AbaDVPRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:17:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757047AbaDVPRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:17:41 -0400
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, x86@kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, mguzik@redhat.com,
        Aaron Tomlin <atomlin@redhat.com>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/4 v3] nmi: Provide the option to issue an NMI back trace to every cpu but current
Date: Tue, 22 Apr 2014 11:17:25 -0400
Message-Id: <1398179848-197479-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1398179848-197479-1-git-send-email-dzickus@redhat.com>
References: <1398179848-197479-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>

Some times it is preferred not to use the
trigger_all_cpu_backtrace() routine when one wants
to avoid capturing a back trace for current.
For instance if one was previously captured
recently.

This patch provides a new routine namely
trigger_allbutself_cpu_backtrace() which offers
the flexibility to issue an NMI to every cpu but
current and capture a back trace accordingly.

[Added stub in #else clause - dcz]

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 include/linux/nmi.h |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 6a45fb5..a17ab63 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -32,15 +32,24 @@ static inline void touch_nmi_watchdog(void)
 #ifdef arch_trigger_all_cpu_backtrace
 static inline bool trigger_all_cpu_backtrace(void)
 {
-	arch_trigger_all_cpu_backtrace();
+	arch_trigger_all_cpu_backtrace(true);
 
 	return true;
 }
+static inline bool trigger_allbutself_cpu_backtrace(void)
+{
+	arch_trigger_all_cpu_backtrace(false);
+	return true;
+}
 #else
 static inline bool trigger_all_cpu_backtrace(void)
 {
 	return false;
 }
+static inline bool trigger_allbutself_cpu_backtrace(void)
+{
+	return false;
+}
 #endif
 
 #ifdef CONFIG_LOCKUP_DETECTOR
-- 
1.7.1

