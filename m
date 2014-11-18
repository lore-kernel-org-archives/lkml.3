Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaKRAGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:06:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48989 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaKRAGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:06:07 -0500
Date: Mon, 17 Nov 2014 16:05:56 -0800
From: tip-bot for Qiaowei Ren <tipbot@zytor.com>
Message-ID: <tip-53f037b08b5bebf47aa2b574a984e2f9fc7926f2@git.kernel.org>
Cc: tglx@linutronix.de, dave@sr71.net, hpa@zytor.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, qiaowei.ren@intel.com,
        dave.hansen@linux.intel.com
Reply-To: mingo@kernel.org, qiaowei.ren@intel.com, dave.hansen@linux.intel.com,
        tglx@linutronix.de, hpa@zytor.com, dave@sr71.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <20141114151822.82B3B486@viggo.jf.intel.com>
References: <20141114151822.82B3B486@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] ia64: Sync struct siginfo with general version
Git-Commit-ID: 53f037b08b5bebf47aa2b574a984e2f9fc7926f2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53f037b08b5bebf47aa2b574a984e2f9fc7926f2
Gitweb:     http://git.kernel.org/tip/53f037b08b5bebf47aa2b574a984e2f9fc7926f2
Author:     Qiaowei Ren <qiaowei.ren@intel.com>
AuthorDate: Fri, 14 Nov 2014 07:18:22 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 18 Nov 2014 00:58:53 +0100

ia64: Sync struct siginfo with general version

New fields about bound violation are added into general struct
siginfo. This will impact MIPS and IA64, which extend general
struct siginfo. This patch syncs this struct for IA64 with
general version.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-mm@kvack.org
Cc: linux-mips@linux-mips.org
Cc: Dave Hansen <dave@sr71.net>
Link: http://lkml.kernel.org/r/20141114151822.82B3B486@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/include/uapi/asm/siginfo.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/include/uapi/asm/siginfo.h b/arch/ia64/include/uapi/asm/siginfo.h
index 4ea6225..bce9bc1 100644
--- a/arch/ia64/include/uapi/asm/siginfo.h
+++ b/arch/ia64/include/uapi/asm/siginfo.h
@@ -63,6 +63,10 @@ typedef struct siginfo {
 			unsigned int _flags;	/* see below */
 			unsigned long _isr;	/* isr */
 			short _addr_lsb;	/* lsb of faulting address */
+			struct {
+				void __user *_lower;
+				void __user *_upper;
+			} _addr_bnd;
 		} _sigfault;
 
 		/* SIGPOLL */
@@ -110,9 +114,9 @@ typedef struct siginfo {
 /*
  * SIGSEGV si_codes
  */
-#define __SEGV_PSTKOVF	(__SI_FAULT|3)	/* paragraph stack overflow */
+#define __SEGV_PSTKOVF	(__SI_FAULT|4)	/* paragraph stack overflow */
 #undef NSIGSEGV
-#define NSIGSEGV	3
+#define NSIGSEGV	4
 
 #undef NSIGTRAP
 #define NSIGTRAP	4
