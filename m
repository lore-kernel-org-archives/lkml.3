Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3H0DoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:44:14 -0400
Received: from intranet.asianux.com ([58.214.24.6]:2773 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3H0DoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:44:13 -0400
X-Spam-Score: -101.0
Message-ID: <521C204D.9020909@asianux.com>
Date: Tue, 27 Aug 2013 11:43:09 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] h8300: include: asm: add marco VM_DATA_DEFAULT_FLAGS in page.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need add VM_DATA_DEFAULT_FLAGS definition just like another platforms
has done (e.g. xtensa), or can not pass compiling.

The related error (allmodconfig for h8300):

    CC      security/selinux/hooks.o
  security/selinux/hooks.c: In function 'selinux_init':
  security/selinux/hooks.c:5866:21: error: 'VM_DATA_DEFAULT_FLAGS' undeclared (first use in this function)
    default_noexec = !(VM_DATA_DEFAULT_FLAGS & VM_EXEC);
                       ^

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/h8300/include/asm/page.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/include/asm/page.h b/arch/h8300/include/asm/page.h
index 837381a..6af8b0d 100644
--- a/arch/h8300/include/asm/page.h
+++ b/arch/h8300/include/asm/page.h
@@ -72,6 +72,9 @@ extern unsigned long memory_end;
 
 #endif /* __ASSEMBLY__ */
 
+#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE |   \
+				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
-- 
1.7.7.6
