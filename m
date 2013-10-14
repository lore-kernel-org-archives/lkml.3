Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3JNHk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 03:40:26 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:33724 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3JNHkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 03:40:25 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] powerpc/kexec: kexec_sequence() is in misc_64.S
Date: Mon, 14 Oct 2013 09:40:16 +0200
Message-Id: <1381736416-4088-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct reference to the location of the kexec_sequence() assembly helper.
There never was a kexec_stub.S in mainline.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/powerpc/kernel/machine_kexec_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 611acdf30096..be4e6d648f60 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -312,7 +312,7 @@ static union thread_union kexec_stack __init_task_data =
  */
 struct paca_struct kexec_paca;
 
-/* Our assembly helper, in kexec_stub.S */
+/* Our assembly helper, in misc_64.S */
 extern void kexec_sequence(void *newstack, unsigned long start,
 			   void *image, void *control,
 			   void (*clear_all)(void)) __noreturn;
-- 
1.7.9.5

