Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbaKYLnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:43:45 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:36859 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827AbaKYLnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:43:40 -0500
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, dahi@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com
Subject: [RFC 1/2] powerpc/fsl-pci: atomic get_user when pagefault_disabled
Date: Tue, 25 Nov 2014 12:43:25 +0100
Message-Id: <1416915806-24757-2-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
References: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112511-0005-0000-0000-00000236FA7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever we have pagefaults disabled, we have to use the atomic variants of
(set|get)_user and copy_(from|to)_user.

Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
---
 arch/powerpc/sysdev/fsl_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 65d2ed4..c0af4ef 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -1025,7 +1025,7 @@ int fsl_pci_mcheck_exception(struct pt_regs *regs)
 	if (is_in_pci_mem_space(addr)) {
 		if (user_mode(regs)) {
 			pagefault_disable();
-			ret = get_user(regs->nip, &inst);
+			ret = __get_user_inatomic(regs->nip, &inst);
 			pagefault_enable();
 		} else {
 			ret = probe_kernel_address(regs->nip, inst);
-- 
1.8.5.5

