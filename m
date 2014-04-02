Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbaDBUNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:13:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42801 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758818AbaDBUN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 07/40] crypto: sha256_ssse3 - also test for BMI2
Date: Wed,  2 Apr 2014 22:12:53 +0200
Message-Id: <5ebd72bfc4de97035b5b6527cf81537154a7591e.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oneukum@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 16c0c4e1656c14ef9deac189a4240b5ca19c6919 upstream.

The AVX2 implementation also uses BMI2 instructions,
but doesn't test for their availability. The assumption
that AVX2 and BMI2 always go together is false. Some
Haswells have AVX2 but not BMI2.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/crypto/sha256_ssse3_glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 50226c4b86ed..e52947f80e68 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -281,7 +281,7 @@ static int __init sha256_ssse3_mod_init(void)
 	/* allow AVX to override SSSE3, it's a little faster */
 	if (avx_usable()) {
 #ifdef CONFIG_AS_AVX2
-		if (boot_cpu_has(X86_FEATURE_AVX2))
+		if (boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_BMI2))
 			sha256_transform_asm = sha256_transform_rorx;
 		else
 #endif
-- 
1.9.1

