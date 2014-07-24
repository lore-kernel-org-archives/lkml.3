Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbaGXSXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:23:34 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34949 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758959AbaGXSXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:23:32 -0400
X-Sasl-enc: Pw3b2S98Ig56cQGKPpcyG06LdJmGbcpYhiPCtOcQ8/En 1406226208
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>
Subject: [PATCH v2 4/8] x86, microcode, intel: rename apply_microcode and declare it static
Date: Thu, 24 Jul 2014 15:23:21 -0300
Message-Id: <1406226201-18820-1-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406146251-8540-5-git-send-email-hmh@hmh.eng.br>
References: <1406146251-8540-5-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename apply_microcode() in microcode/intel.c to apply_microcode_intel(),
and declare it as static.

This is a cosmetic fix to silence a warning issued by sparse.  It brings
the microcode/intel.c driver in line with what microcode/amd.c is doing.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 v2: declare as static instead of extern, and changed patch title

 arch/x86/kernel/cpu/microcode/intel.c |    4 ++--
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
 
-- 
1.7.10.4

