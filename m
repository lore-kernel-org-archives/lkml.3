Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaEUXYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:24:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43377 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaEUXYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:24:40 -0400
Date: Wed, 21 May 2014 16:24:28 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-1bd24efc8bd1e644b115cae51048c008bea76de1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <10ad65f534f8bc62e77f74fe15f68e8d4a59d8b3.1400709717.git.luto@amacapital.net>
References: <10ad65f534f8bc62e77f74fe15f68e8d4a59d8b3.1400709717.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86_64, entry: Add missing 'DEFAULT_FRAME 0'
  entry annotations
Git-Commit-ID: 1bd24efc8bd1e644b115cae51048c008bea76de1
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

Commit-ID:  1bd24efc8bd1e644b115cae51048c008bea76de1
Gitweb:     http://git.kernel.org/tip/1bd24efc8bd1e644b115cae51048c008bea76de1
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Wed, 21 May 2014 15:07:07 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 21 May 2014 16:22:51 -0700

x86_64, entry: Add missing 'DEFAULT_FRAME 0' entry annotations

The paranoidzeroentry macros were missing them.  I'm not at all
convinced that these annotations are correct and/or necessary, but
this makes the macros more consistent with each other.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/10ad65f534f8bc62e77f74fe15f68e8d4a59d8b3.1400709717.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/entry_64.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c36..39372ec 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1230,6 +1230,7 @@ ENTRY(\sym)
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
+	DEFAULT_FRAME 0
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
@@ -1249,6 +1250,7 @@ ENTRY(\sym)
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
+	DEFAULT_FRAME 0
 	TRACE_IRQS_OFF_DEBUG
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
