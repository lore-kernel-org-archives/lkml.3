Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422689AbaDPQUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:20:10 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:48133 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422648AbaDPQUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:20:06 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        nasa4836@gmail.com
Subject: [PATCH] crypto: sha{256,512}_ssse3 - remove asmlinkage from static functions
Date: Thu, 17 Apr 2014 00:19:50 +0800
Message-Id: <1397665190-12491-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 128ea04a9885("lto: Make asmlinkage __visible") restricts
asmlinkage to externally_visible, this causes compilation warnings:

    arch/x86/crypto/sha256_ssse3_glue.c:56:1:
    warning: ‘externally_visible’ attribute have effect only on public objects [-Wattributes]

    static asmlinkage void (*sha256_transform_asm)(const char *, u32 *, u64);
    ^

    arch/x86/crypto/sha512_ssse3_glue.c:55:1:
    warning: ‘externally_visible’ attribute have effect only on public objects [-Wattributes]
    static asmlinkage void (*sha512_transform_asm)(const char *, u64 *,
    ^

Drop asmlinkage here to avoid such warnings.

Also see Commit 8783dd3a37a5853689e1("irqchip: Remove asmlinkage from static functions")

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 arch/x86/crypto/sha256_ssse3_glue.c | 2 +-
 arch/x86/crypto/sha512_ssse3_glue.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index f248546..be35c31 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -53,7 +53,7 @@ asmlinkage void sha256_transform_rorx(const char *data, u32 *digest,
 				     u64 rounds);
 #endif
 
-static asmlinkage void (*sha256_transform_asm)(const char *, u32 *, u64);
+static void (*sha256_transform_asm)(const char *, u32 *, u64);
 
 
 static int sha256_ssse3_init(struct shash_desc *desc)
diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index f30cd10..ddbc242 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -52,7 +52,7 @@ asmlinkage void sha512_transform_rorx(const char *data, u64 *digest,
 				     u64 rounds);
 #endif
 
-static asmlinkage void (*sha512_transform_asm)(const char *, u64 *, u64);
+static void (*sha512_transform_asm)(const char *, u64 *, u64);
 
 
 static int sha512_ssse3_init(struct shash_desc *desc)
-- 
1.9.0.GIT

