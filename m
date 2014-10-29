Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbaJ2JKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:10:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58908 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbaJ2JKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:10:42 -0400
Date: Wed, 29 Oct 2014 02:10:11 -0700
From: tip-bot for Dave Jones <tipbot@zytor.com>
Message-ID: <tip-d4e1a0af1d3a88cdfc8c954d3005eb8745ec518d@git.kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, pure.logic@nexus-software.ie,
        davej@redhat.com, mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, pure.logic@nexus-software.ie,
        davej@redhat.com
In-Reply-To: <20141028175753.GA12743@redhat.com>
References: <20141028175753.GA12743@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Don'
 t enable F00F workaround on Intel Quark processors
Git-Commit-ID: d4e1a0af1d3a88cdfc8c954d3005eb8745ec518d
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

Commit-ID:  d4e1a0af1d3a88cdfc8c954d3005eb8745ec518d
Gitweb:     http://git.kernel.org/tip/d4e1a0af1d3a88cdfc8c954d3005eb8745ec518d
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Tue, 28 Oct 2014 13:57:53 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 29 Oct 2014 08:52:09 +0100

x86: Don't enable F00F workaround on Intel Quark processors

The Intel Quark processor is a part of family 5, but does not have the
F00F bug present in Pentiums of the same family.

Pentiums were models 0 through 8, Quark is model 9.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Link: http://lkml.kernel.org/r/20141028175753.GA12743@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
