Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaGaLnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:43:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:40081 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaGaLnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:43:07 -0400
From: <Wei.Yang@windriver.com>
To: <ralf@linux-mips.org>
CC: <Wei.Yang@windriver.com>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v1] MIPS:KDUMP: set a right value to kexec_indirection_page variable
Date: Thu, 31 Jul 2014 19:42:29 +0800
Message-ID: <1406806949-27039-1-git-send-email-Wei.Yang@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Wei <Wei.Yang@windriver.com>

Since there is not indirection page in crash type, so the vaule of the head
field of kimage structure is not equal to the address of indirection page but
IND_DONE. so we have to set kexec_indirection_page variable to the address of
the head field of image structure.

Signed-off-by: Yang Wei <Wei.Yang@windriver.com>

          Hi Ralf,

		  Please help me take a look at this patch, I have already verified it on Cavium 6100EVB board.

		  Thanks
		  Wei
---
 arch/mips/kernel/machine_kexec.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/machine_kexec.c b/arch/mips/kernel/machine_kexec.c
index 992e184..531b70d 100644
--- a/arch/mips/kernel/machine_kexec.c
+++ b/arch/mips/kernel/machine_kexec.c
@@ -71,8 +71,13 @@ machine_kexec(struct kimage *image)
 	kexec_start_address =
 		(unsigned long) phys_to_virt(image->start);
 
-	kexec_indirection_page =
-		(unsigned long) phys_to_virt(image->head & PAGE_MASK);
+	if (image->type == KEXEC_TYPE_DEFAULT) {
+		kexec_indirection_page =
+			(unsigned long) phys_to_virt(image->head & PAGE_MASK);
+	} else {
+		kexec_indirection_page = (unsigned long)&image->head;
+	}
+	
 
 	memcpy((void*)reboot_code_buffer, relocate_new_kernel,
 	       relocate_new_kernel_size);
-- 
1.7.9.5

