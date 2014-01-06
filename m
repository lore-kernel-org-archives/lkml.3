Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaAFIWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:22:32 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63679 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbaAFIW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:22:29 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, hpa@zytor.com, ak@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, mingo@redhat.com, nico@linaro.org,
        x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4/8] x86: align with generic cpu modalias
Date: Mon,  6 Jan 2014 09:22:12 +0100
Message-Id: <1388996536-27014-5-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388996536-27014-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1388996536-27014-1-git-send-email-ard.biesheuvel@linaro.org>
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
index ab6082a9020e..82e92b2185f6 100644
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
index 8a69005228d8..5fdad833f951 100644
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

