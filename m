Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaLOPEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:04:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38458 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaLOO1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Schwab <schwab@suse.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 056/168] arm64/crypto: fix makefile rule for aes-glue-%.o
Date: Mon, 15 Dec 2014 14:25:10 +0000
Message-Id: <1418653622-21105-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@suse.de>

commit 7c2105fbe9658d6cee18751568e29579bb58bfec upstream.

This fixes the following build failure when building with CONFIG_MODVERSIONS
enabled:

  CC [M]  arch/arm64/crypto/aes-glue-ce.o
ld: cannot find arch/arm64/crypto/aes-glue-ce.o: No such file or directory
make[1]: *** [arch/arm64/crypto/aes-ce-blk.o] Error 1
make: *** [arch/arm64/crypto] Error 2

The $(obj)/aes-glue-%.o rule only creates $(obj)/.tmp_aes-glue-ce.o, it
should use if_changed_rule instead of if_changed_dep.

Signed-off-by: Andreas Schwab <schwab@suse.de>
[ardb: mention CONFIG_MODVERSIONS in commit log]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/crypto/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index 2070a56ecc46..a3f935fde975 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -35,4 +35,4 @@ AFLAGS_aes-neon.o	:= -DINTERLEAVE=4
 CFLAGS_aes-glue-ce.o	:= -DUSE_V8_CRYPTO_EXTENSIONS
 
 $(obj)/aes-glue-%.o: $(src)/aes-glue.c FORCE
-	$(call if_changed_dep,cc_o_c)
+	$(call if_changed_rule,cc_o_c)
-- 
2.1.3

