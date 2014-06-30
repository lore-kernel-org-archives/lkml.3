Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaF3NOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:14:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbaF3NOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:14:35 -0400
From: Andreas Schwab <schwab@suse.de>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm64/crypto: fix makefile rule for aes-glue-%.o
CC: linux-kernel@vger.kernel.org
X-Yow: OVER the undertow!  UNDER the overpass!  Around the FUTURE
 and BEYOND REPAIR!!
Date: Mon, 30 Jun 2014 15:14:33 +0200
Message-ID: <mvmvbri4k06.fsf@hawking.suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following build failure:

  CC [M]  arch/arm64/crypto/aes-glue-ce.o
ld: cannot find arch/arm64/crypto/aes-glue-ce.o: No such file or directory
scripts/Makefile.build:393: recipe for target 'arch/arm64/crypto/aes-ce-blk.o' failed
make[1]: *** [arch/arm64/crypto/aes-ce-blk.o] Error 1
Makefile:893: recipe for target 'arch/arm64/crypto' failed
make: *** [arch/arm64/crypto] Error 2

The $(obj)/aes-glue-%.o rule only creates $(obj)/.tmp_aes-glue-ce.o, it
should use if_changed_rule instead of if_changed_dep.

Signed-off-by: Andreas Schwab <schwab@suse.de>
---
 arch/arm64/crypto/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index 2070a56..a3f935f 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -35,4 +35,4 @@ AFLAGS_aes-neon.o	:= -DINTERLEAVE=4
 CFLAGS_aes-glue-ce.o	:= -DUSE_V8_CRYPTO_EXTENSIONS
 
 $(obj)/aes-glue-%.o: $(src)/aes-glue.c FORCE
-	$(call if_changed_dep,cc_o_c)
+	$(call if_changed_rule,cc_o_c)
-- 
2.0.1

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
