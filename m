Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3KKKUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 05:20:45 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:37652 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3KKKTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 05:19:48 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, catalin.marinas@arm.com, hpa@zytor.com,
        steve.capper@linaro.org, ak@linux.intel.com, dave.martin@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/4] x86: align with generic cpu modalias
Date: Mon, 11 Nov 2013 11:19:34 +0100
Message-Id: <1384165175-16134-4-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1384165175-16134-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1384165175-16134-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align with the new generic 'cpu:type:...:features:...' modalias
by moving the 'x86' prefix and the vendor/family/model IDs into
the 'type' field.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/kernel/cpu/match.c |  3 +--
 scripts/mod/file2alias.c    | 10 +++++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index ab6082a..82e92b2 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -56,8 +56,7 @@ ssize_t arch_print_cpu_modalias(struct device *dev,
 	int i, n;
 	char *buf = bufptr;
 
-	n = snprintf(buf, size, "x86cpu:vendor:%04X:family:%04X:"
-		     "model:%04X:feature:",
+	n = snprintf(buf, size, "cpu:type:x86,ven%04Xfam%04Xmod%04X:feature:",
 		boot_cpu_data.x86_vendor,
 		boot_cpu_data.x86,
 		boot_cpu_data.x86_model);
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index efc7abe..856c343 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1110,7 +1110,7 @@ static int do_amba_entry(const char *filename,
 }
 ADD_TO_DEVTABLE("amba", amba_id, do_amba_entry);
 
-/* LOOKS like x86cpu:vendor:VVVV:family:FFFF:model:MMMM:feature:*,FEAT,*
+/* LOOKS like cpu:type:x86,venVVVVfamFFFFmodMMMM:feature:*,FEAT,*
  * All fields are numbers. It would be nicer to use strings for vendor
  * and feature, but getting those out of the build system here is too
  * complicated.
@@ -1124,10 +1124,10 @@ static int do_x86cpu_entry(const char *filename, void *symval,
 	DEF_FIELD(symval, x86_cpu_id, model);
 	DEF_FIELD(symval, x86_cpu_id, vendor);
 
-	strcpy(alias, "x86cpu:");
-	ADD(alias, "vendor:",  vendor != X86_VENDOR_ANY, vendor);
-	ADD(alias, ":family:", family != X86_FAMILY_ANY, family);
-	ADD(alias, ":model:",  model  != X86_MODEL_ANY,  model);
+	strcpy(alias, "cpu:type:x86,");
+	ADD(alias, "ven", vendor != X86_VENDOR_ANY, vendor);
+	ADD(alias, "fam", family != X86_FAMILY_ANY, family);
+	ADD(alias, "mod", model  != X86_MODEL_ANY,  model);
 	strcat(alias, ":feature:*");
 	if (feature != X86_FEATURE_ANY)
 		sprintf(alias + strlen(alias), "%04X*", feature);
-- 
1.8.3.2

