Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaJ1Sdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:33:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54085 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaJ1Sdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:33:49 -0400
Date: Tue, 28 Oct 2014 11:33:30 -0700
From: tip-bot for Dave Jones <tipbot@zytor.com>
Message-ID: <tip-c1dd2d38a55119e1611a9ea3ee30bcf8902e2b04@git.kernel.org>
Cc: davej@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, pure.logic@nexus-software.ie, mingo@kernel.org
Reply-To: davej@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, pure.logic@nexus-software.ie, mingo@kernel.org
In-Reply-To: <20141028175753.GA12743@redhat.com>
References: <20141028175753.GA12743@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Don'
 t enable F00F workaround on Intel Quark processors
Git-Commit-ID: c1dd2d38a55119e1611a9ea3ee30bcf8902e2b04
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

Commit-ID:  c1dd2d38a55119e1611a9ea3ee30bcf8902e2b04
Gitweb:     http://git.kernel.org/tip/c1dd2d38a55119e1611a9ea3ee30bcf8902e2b04
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Tue, 28 Oct 2014 13:57:53 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 28 Oct 2014 19:31:23 +0100

x86: Don't enable F00F workaround on Intel Quark processors

The Intel Quark processor is a part of family 5, but does not have the
F00F bug present in Pentiums of the same family.

Pentiums were models 0 through 8, Quark is model 9.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Link: http://lkml.kernel.org/r/20141028175753.GA12743@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/cpu/intel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1ef4562..9cc6b6f 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -213,12 +213,13 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_F00F_BUG
 	/*
-	 * All current models of Pentium and Pentium with MMX technology CPUs
+	 * All models of Pentium and Pentium with MMX technology CPUs
 	 * have the F0 0F bug, which lets nonprivileged users lock up the
 	 * system. Announce that the fault handler will be checking for it.
+	 * The Quark is also family 5, but does not have the same bug.
 	 */
 	clear_cpu_bug(c, X86_BUG_F00F);
-	if (!paravirt_enabled() && c->x86 == 5) {
+	if (!paravirt_enabled() && c->x86 == 5 && c->x86_model < 9) {
 		static int f00f_workaround_enabled;
 
 		set_cpu_bug(c, X86_BUG_F00F);
