Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab3KYJkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:40:43 -0500
Received: from smtp.citrix.com ([66.165.176.89]:31939 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab3KYJkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:40:40 -0500
X-IronPort-AV: E=Sophos;i="4.93,766,1378857600"; 
   d="scan'208";a="77766343"
From: Ian Campbell <ian.campbell@citrix.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: Ian Campbell <ian.campbell@citrix.com>, Rupjyoti Sarmah <rsarmah@apm.com>,
        Tirumala R Marri <tmarri@apm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] powerpc/4xx: Fix warning in kilauea.dtb
Date: Mon, 25 Nov 2013 09:40:37 +0000
Message-ID: <1385372437-20958-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently I see:
  DTC     arch/powerpc/boot/kilauea.dtb
Warning (reg_format): "reg" property in /plb/ppc4xx-msi@C10000000 has invalid length (12 bytes) (#address-cells == 1, #size-cells == 1)

It appears that unlike the other platforms handled by 3fb7933850fa
"powerpc/4xx: Adding PCIe MSI support" this platform does not use address-cells=2.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Josh Boyer <jwboyer@gmail.com>
Cc: Rupjyoti Sarmah <rsarmah@apm.com>
Cc: Tirumala R Marri <tmarri@apm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
---
Resending, this hasn't been picked up since June
http://patchwork.ozlabs.org/patch/248234/
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

