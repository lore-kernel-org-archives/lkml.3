Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3GACWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 22:22:44 -0400
Received: from intranet.asianux.com ([58.214.24.6]:62174 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3GACWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 22:22:43 -0400
X-Spam-Score: -100.8
Message-ID: <51D0E7BF.9030206@asianux.com>
Date: Mon, 01 Jul 2013 10:21:51 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH v2] arch: tile: include: asm: add cmpxchg64() definition
References: <51CA6D21.3090901@asianux.com> <51CC492C.1040105@tilera.com> <51CCD891.8000806@asianux.com> <51CCEC27.8050508@asianux.com> <20130628150941.GA22767@linux-mips.org> <51D0E4B3.6080402@asianux.com>
In-Reply-To: <51D0E4B3.6080402@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need add cmpxchg64(), or will cause compiling issue.

Need define it as cmpxchg() only for 64-bit operation, since cmpxchg()
can support 8 bytes.

The related error (with allmodconfig):

  drivers/block/blockconsole.c: In function ‘bcon_advance_console_bytes’:
  drivers/block/blockconsole.c:164:2: error: implicit declaration of function ‘cmpxchg64’ [-Werror=implicit-function-declaration]

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/tile/include/asm/cmpxchg.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/tile/include/asm/cmpxchg.h b/arch/tile/include/asm/cmpxchg.h
index 276f067..1da5bfb 100644
--- a/arch/tile/include/asm/cmpxchg.h
+++ b/arch/tile/include/asm/cmpxchg.h
@@ -68,6 +68,12 @@ extern unsigned long __cmpxchg_called_with_bad_pointer(void);
 
 #define tas(ptr) (xchg((ptr), 1))
 
+#define cmpxchg64(ptr, o, n)						\
+({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg((ptr), (o), (n));					\
+})
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_TILE_CMPXCHG_H */
-- 
1.7.7.6
