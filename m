Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaJ1R6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:58:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbaJ1R6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:58:07 -0400
Date: Tue, 28 Oct 2014 13:57:53 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH] Don't enable F00F workaround on Intel Quark processors.
Message-ID: <20141028175753.GA12743@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
	Bryan O'Donoghue <pure.logic@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel Quark processor is a part of family 5, but does not have the
F00F bug present in Pentiums of the same family.

Pentiums were models 0 through 8, Quark is model 9.

Cc: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1ef456273172..9cc6b6f25f42 100644
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
