Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaLCGE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 01:04:57 -0500
Received: from ozlabs.org ([103.22.144.67]:45187 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaLCGEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 01:04:55 -0500
From: Michael Ellerman <mpe@ellerman.id.au>
To: <linux-kernel@vger.kernel.org>
Cc: zohar@linux.vnet.ibm.com, d.kasatkin@samsung.com,
        james.l.morris@oracle.com, serge@hallyn.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Subject: [RESEND PATCH] ima: Fix build failure on powerpc when TCG_IBMVTPM dependencies are not met
Date: Wed,  3 Dec 2014 17:04:50 +1100
Message-Id: <1417586690-11521-1-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On powerpc we can end up with IMA=y and PPC_PSERIES=n which leads to:

  warning: (IMA) selects TCG_IBMVTPM which has unmet direct dependencies (TCG_TPM && PPC_PSERIES)
  tpm_ibmvtpm.c:(.text+0x14f3e8): undefined reference to `.plpar_hcall_norets'

I'm not sure why IMA needs to select those user-visible symbols, but if
it must then the simplest fix is to just express the proper dependencies
on the select.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 security/integrity/ima/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


Could someone please pick this up?

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index e099875643c5..b51668d04f9d 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -10,7 +10,7 @@ config IMA
 	select CRYPTO_HASH_INFO
 	select TCG_TPM if HAS_IOMEM && !UML
 	select TCG_TIS if TCG_TPM && X86
-	select TCG_IBMVTPM if TCG_TPM && PPC64
+	select TCG_IBMVTPM if TCG_TPM && PPC_PSERIES
 	help
 	  The Trusted Computing Group(TCG) runtime Integrity
 	  Measurement Architecture(IMA) maintains a list of hash
-- 
1.9.1

