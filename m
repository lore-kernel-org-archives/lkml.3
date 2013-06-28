Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3F1Bwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 21:52:30 -0400
Received: from intranet.asianux.com ([58.214.24.6]:45166 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3F1Bw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 21:52:29 -0400
X-Spam-Score: -100.9
Message-ID: <51CCEC27.8050508@asianux.com>
Date: Fri, 28 Jun 2013 09:51:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: tile: include: asm: add cmpxchg64() definition
References: <51CA6D21.3090901@asianux.com> <51CC492C.1040105@tilera.com> <51CCD891.8000806@asianux.com>
In-Reply-To: <51CCD891.8000806@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need add cmpxchg64(), or will cause compiling issue.

Just define it as cmpxchg(), since cmpxchg() can support 8 bytes.

The related error (with allmodconfig):

  drivers/block/blockconsole.c: In function ¡®bcon_advance_console_bytes¡¯:
  drivers/block/blockconsole.c:164:2: error: implicit declaration of function ¡®cmpxchg64¡¯ [-Werror=implicit-function-declaration]

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/tile/include/asm/cmpxchg.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/tile/include/asm/cmpxchg.h b/arch/tile/include/asm/cmpxchg.h
index 276f067..7688c28 100644
--- a/arch/tile/include/asm/cmpxchg.h
+++ b/arch/tile/include/asm/cmpxchg.h
@@ -68,6 +68,8 @@ extern unsigned long __cmpxchg_called_with_bad_pointer(void);
 
 #define tas(ptr) (xchg((ptr), 1))
 
+#define cmpxchg64(ptr, o, n)		cmpxchg((ptr), (o), (n))
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_TILE_CMPXCHG_H */
-- 
1.7.7.6
