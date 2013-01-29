Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab3A2JJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:09:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab3A2JHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:07:39 -0500
Date: Tue, 29 Jan 2013 01:07:20 -0800
From: tip-bot for David Woodhouse <dwmw2@infradead.org>
Message-ID: <tip-2b9b6d8c715b23fa119261c32ad360681f4464a9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dwmw2@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com
In-Reply-To: <1359395390.3529.65.camel@shinybook.infradead.org>
References: <1359395390.3529.65.camel@shinybook.infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Require MOVBE feature in cpuid when we use it
Git-Commit-ID: 2b9b6d8c715b23fa119261c32ad360681f4464a9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 01:07:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b9b6d8c715b23fa119261c32ad360681f4464a9
Gitweb:     http://git.kernel.org/tip/2b9b6d8c715b23fa119261c32ad360681f4464a9
Author:     David Woodhouse <dwmw2@infradead.org>
AuthorDate: Mon, 28 Jan 2013 17:49:50 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 28 Jan 2013 16:59:55 -0800

x86: Require MOVBE feature in cpuid when we use it

Add MOVBE to asm/required-features.h so we check for it during startup
and don't bother checking for it later.

CONFIG_MATOM is used because it corresponds to -march=atom in the
Makefiles.  If the rules get more complicated it may be necessary to
make this an explicit Kconfig option which uses -mmovbe/-mno-movbe to
control the use of this instruction explicitly.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Link: http://lkml.kernel.org/r/1359395390.3529.65.camel@shinybook.infradead.org
[ hpa: added a patch description ]
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/required-features.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index 6c7fc25..5c6e4fb 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -47,6 +47,12 @@
 # define NEED_NOPL	0
 #endif
 
+#ifdef CONFIG_MATOM
+# define NEED_MOVBE	(1<<(X86_FEATURE_MOVBE & 31))
+#else
+# define NEED_MOVBE	0
+#endif
+
 #ifdef CONFIG_X86_64
 #ifdef CONFIG_PARAVIRT
 /* Paravirtualized systems may not have PSE or PGE available */
@@ -80,7 +86,7 @@
 
 #define REQUIRED_MASK2	0
 #define REQUIRED_MASK3	(NEED_NOPL)
-#define REQUIRED_MASK4	0
+#define REQUIRED_MASK4	(NEED_MOVBE)
 #define REQUIRED_MASK5	0
 #define REQUIRED_MASK6	0
 #define REQUIRED_MASK7	0
