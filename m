Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaJONbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 09:31:03 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64288 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaJONbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 09:31:01 -0400
From: Rolf Evers-Fischer <embedded24@evers-fischer.de>
To: horms@verge.net.au, magnus.damm@gmail.com
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Rolf Evers-Fischer <embedded24@evers-fischer.de>
Subject: [PATCH] arch: arm: mach-shmobile: Remove ARCH_HAS_OPP completely
Date: Wed, 15 Oct 2014 15:29:45 +0200
Message-Id: <1413379785-14468-1-git-send-email-embedded24@evers-fischer.de>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V02:K0:2PFSBwe3uAfCvWKLkvambc7/OcEU7SxG3SbCSVnrlY6
 bOpQrehoMsO10PkFa+xgAuIdq0v1TEjgihnFsUmbmSLYTpwGp8
 ubVNB1slrJ0AXetsOztCR+IVco8q+teOMoazjJpT6eRGHt1qCd
 +H8OimFErQENxK2u8qL1dukwjpHYLpKs25UxWGyORkXI3kqNDk
 i1UTpystaEtdg/Nt7udb1JPixns+ZhYQYCOLIX3Fd47SsWeqXd
 w2XT2Wo9uOzTHfDYpMaiCgkaGM7xotOjmaA3wIamxm0eL6pYna
 yh1FKqRB7B1zx2UBDeOxYbkzq1V9MgMteXPgZrJK5pVhu9mKSq
 ZGHKL9Qgji5JP0C0dqXsYfcJXKis48L/l8FOqi6rqbI5H3ILlU
 iiVsKlgFpmdhtPEGx2FbbbOb6NjBJj6a4NM6YV6E46gsvB71sa
 3ChWn
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol ARCH_HAS_OPP became redundant in v3.16: commit
049d595a4db3 ("PM / OPP: Make OPP invisible to users in Kconfig")
removed the only dependency that used it. Setting it had no effect
anymore.

So commit 78c5e0bb145d ("PM / OPP: Remove ARCH_HAS_OPP") removed it. For
some reason that commit did not remove all select statements for that
symbol. These statements are now useless.

Commit adad5621f3e1 ("PM / devfreq: Remove ARCH_HAS_OPP completely")
removed it for devfreq. Remove one from mach-shmobile too.

Signed-off-by: Rolf Evers-Fischer <embedded24@evers-fischer.de>
---
 arch/arm/mach-shmobile/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index 21f457b..f59019d 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -36,7 +36,6 @@ menuconfig ARCH_SHMOBILE_MULTI
 	select NO_IOPORT_MAP
 	select PINCTRL
 	select ARCH_REQUIRE_GPIOLIB
-	select ARCH_HAS_OPP
 
 if ARCH_SHMOBILE_MULTI
 
-- 
1.9.1

