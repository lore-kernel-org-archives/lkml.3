Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870Ab3CGWQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:16:06 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:49237 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759224Ab3CGWQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:16:01 -0500
Message-ID: <1362694559.5994.31.camel@x61.thuisdomein>
Subject: [PATCH] powerpc/wsp: drop "select PPC_WSP_COPRO"
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Thu, 07 Mar 2013 23:15:59 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2013 22:15:59.0940 (UTC) FILETIME=[5911E840:01CE1B81]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no Kconfig symbol PPC_WSP_COPRO. The select statement for it is
a nop. Drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
A short treatise on the uneventful life of PPC_WSP_COPRO in the mainline
kernel tree

Release v3.0 included commit 76b4eda866c4936af8d696f040abea56bf688e16
("powerpc: Add A2 cpu support"). It added some code wrapped in an
"#ifdef CONFIG_PPC_WSP_COPRO" and "#endif" pair. It did not add a
Kconfig symbol PPC_WSP_COPRO. Neither did it add a preprocessor #define
for CONFIG_PPC_WSP_COPRO. There haS actually never been such a symbol or
such a macro in the mainline tree.

Release v3.3 included commit fac26ad4f9cb794c9d1032f55f40a31cb55be09a
("powerpc/book3e: Add ICSWX/ACOP support to Book3e cores like A2"). It
basically renamed CONFIG_PPC_WSP_COPRO to CONFIG_PPC_ICSWX. It did not
elaborate why it did that. But at least PPC_ICSWX was a valid Kconfig
symbol.

Release v3.3 also included commit
cc35b6766878e31accc95c3fdae945bdadc73a46 ("powerpc/book3e: Add Chroma as
a new WSP/PowerEN platform."). That commit added a Kconfig select
statement for PPC_WSP_COPRO. It is not clear why it did that. Current
opinion is that it served no purpose and that the kernel tree would be
better of without that statement.

 arch/powerpc/platforms/wsp/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/platforms/wsp/Kconfig b/arch/powerpc/platforms/wsp/Kconfig
index 79d2225..56203a4 100644
--- a/arch/powerpc/platforms/wsp/Kconfig
+++ b/arch/powerpc/platforms/wsp/Kconfig
@@ -9,7 +9,6 @@ config PPC_WSP
 	select PCI
 	select PPC_IO_WORKAROUNDS if PCI
 	select PPC_INDIRECT_PIO if PCI
-	select PPC_WSP_COPRO
 	default n
 
 menu "WSP platform selection"
-- 
1.7.11.7

