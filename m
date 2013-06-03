Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab3FCLA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 07:00:28 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:57026 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab3FCLA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 07:00:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,792,1363132800"; 
   d="scan'208";a="5254501"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
CC: Ian Campbell <ian.campbell@citrix.com>, Rupjyoti Sarmah <rsarmah@apm.com>,
        Tirumala R Marri <tmarri@apm.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc/4xx: Fix warning in kilauea.dtb
Date: Mon, 3 Jun 2013 12:00:24 +0100
Message-ID: <1370257224-23805-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently I see:
  DTC     arch/powerpc/boot/kilauea.dtb
Warning (reg_format): "reg" property in /plb/ppc4xx-msi@C10000000 has invalid length (12 bytes) (#address-cells == 1, #size-cells == 1)

It appears that unlike the other plarforms handled by 3fb7933850fa
"powerpc/4xx: Adding PCIe MSI support" this platform does not use address-cells=2.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Rupjyoti Sarmah <rsarmah@apm.com>
Cc: Tirumala R Marri <tmarri@apm.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
---
 arch/powerpc/boot/dts/kilauea.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/dts/kilauea.dts b/arch/powerpc/boot/dts/kilauea.dts
index 1613d6e..5ba7f01 100644
--- a/arch/powerpc/boot/dts/kilauea.dts
+++ b/arch/powerpc/boot/dts/kilauea.dts
@@ -406,7 +406,7 @@
 
 		MSI: ppc4xx-msi@C10000000 {
 			compatible = "amcc,ppc4xx-msi", "ppc4xx-msi";
-			reg = < 0x0 0xEF620000 0x100>;
+			reg = <0xEF620000 0x100>;
 			sdr-base = <0x4B0>;
 			msi-data = <0x00000000>;
 			msi-mask = <0x44440000>;
-- 
1.7.10.4

