Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaKRAFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:05:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48978 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaKRAFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:05:52 -0500
Date: Mon, 17 Nov 2014 16:05:40 -0800
From: tip-bot for Qiaowei Ren <tipbot@zytor.com>
Message-ID: <tip-232b5fff5bad78ad00b94153fa90ca53bef6a444@git.kernel.org>
Cc: hpa@zytor.com, dave@sr71.net, tglx@linutronix.de, mingo@kernel.org,
        linux-kernel@vger.kernel.org, qiaowei.ren@intel.com,
        dave.hansen@linux.intel.com
Reply-To: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        qiaowei.ren@intel.com, dave.hansen@linux.intel.com, hpa@zytor.com,
        dave@sr71.net
In-Reply-To: <20141114151820.F7EDC3CC@viggo.jf.intel.com>
References: <20141114151820.F7EDC3CC@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] mips: Sync struct siginfo with general version
Git-Commit-ID: 232b5fff5bad78ad00b94153fa90ca53bef6a444
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

Commit-ID:  232b5fff5bad78ad00b94153fa90ca53bef6a444
Gitweb:     http://git.kernel.org/tip/232b5fff5bad78ad00b94153fa90ca53bef6a444
Author:     Qiaowei Ren <qiaowei.ren@intel.com>
AuthorDate: Fri, 14 Nov 2014 07:18:20 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 18 Nov 2014 00:58:53 +0100

mips: Sync struct siginfo with general version

New fields about bound violation are added into general struct
siginfo. This will impact MIPS and IA64, which extend general
struct siginfo. This patch syncs this struct for MIPS with
general version.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-mm@kvack.org
Cc: linux-mips@linux-mips.org
Cc: Dave Hansen <dave@sr71.net>
Link: http://lkml.kernel.org/r/20141114151820.F7EDC3CC@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mips/include/uapi/asm/siginfo.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/include/uapi/asm/siginfo.h b/arch/mips/include/uapi/asm/siginfo.h
index e811744..d08f83f 100644
--- a/arch/mips/include/uapi/asm/siginfo.h
+++ b/arch/mips/include/uapi/asm/siginfo.h
@@ -92,6 +92,10 @@ typedef struct siginfo {
 			int _trapno;	/* TRAP # which caused the signal */
 #endif
 			short _addr_lsb;
+			struct {
+				void __user *_lower;
+				void __user *_upper;
+			} _addr_bnd;
 		} _sigfault;
 
 		/* SIGPOLL, SIGXFSZ (To do ...)	 */
