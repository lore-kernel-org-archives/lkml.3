Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaHXO4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:56:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34002 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbaHXO4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:56:30 -0400
Date: Sun, 24 Aug 2014 07:56:17 -0700
From: tip-bot for Henrique de Moraes Holschuh <tipbot@zytor.com>
Message-ID: <tip-532ed3740c1ed1583ea3fa6de9410edf0d508563@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hmh@hmh.eng.br, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, hmh@hmh.eng.br,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, intel:
  Rename apply_microcode and declare it static
Git-Commit-ID: 532ed3740c1ed1583ea3fa6de9410edf0d508563
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

Commit-ID:  532ed3740c1ed1583ea3fa6de9410edf0d508563
Gitweb:     http://git.kernel.org/tip/532ed3740c1ed1583ea3fa6de9410edf0d508563
Author:     Henrique de Moraes Holschuh <hmh@hmh.eng.br>
AuthorDate: Thu, 24 Jul 2014 15:23:21 -0300
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Fri, 25 Jul 2014 17:57:51 +0200

x86, microcode, intel: Rename apply_microcode and declare it static

Rename apply_microcode() in microcode/intel.c to
apply_microcode_intel(), and declare it as static. This is a cosmetic
fix to silence a warning issued by sparse.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Link: http://lkml.kernel.org/r/1406146251-8540-1-git-send-email-hmh@hmh.eng.br
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/microcode/intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index a276fa7..c6826d1 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -127,7 +127,7 @@ static int get_matching_mc(struct microcode_intel *mc_intel, int cpu)
 	return get_matching_microcode(csig, cpf, mc_intel, crev);
 }
 
-int apply_microcode(int cpu)
+static int apply_microcode_intel(int cpu)
 {
 	struct microcode_intel *mc_intel;
 	struct ucode_cpu_info *uci;
@@ -314,7 +314,7 @@ static struct microcode_ops microcode_intel_ops = {
 	.request_microcode_user		  = request_microcode_user,
 	.request_microcode_fw             = request_microcode_fw,
 	.collect_cpu_info                 = collect_cpu_info,
-	.apply_microcode                  = apply_microcode,
+	.apply_microcode                  = apply_microcode_intel,
 	.microcode_fini_cpu               = microcode_fini_cpu,
 };
 
