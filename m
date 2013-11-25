Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3KYJma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:42:30 -0500
Received: from smtp.citrix.com ([66.165.176.89]:39910 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab3KYJm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:42:29 -0500
X-IronPort-AV: E=Sophos;i="4.93,766,1378857600"; 
   d="scan'208";a="77766612"
From: Ian Campbell <ian.campbell@citrix.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: Ian Campbell <ian.campbell@citrix.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Gernot Vormayr <gvormayr@gmail.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] powerpc/dts/virtex440: declare address/size-cells for phy device
Date: Mon, 25 Nov 2013 09:42:26 +0000
Message-ID: <1385372547-21324-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a warning:

  DTC     arch/powerpc/boot/virtex440-ml507.dtb
Warning (reg_format): "reg" property in /plb@0/xps-ll-temac@81c00000/ethernet@81c00000/phy@7 has invalid length (4 bytes) (#address-cells == 2, #size-cells == 1)
Warning (avoid_default_addr_size): Relying on default #address-cells value for /plb@0/xps-ll-temac@81c00000/ethernet@81c00000/phy@7
Warning (avoid_default_addr_size): Relying on default #size-cells value for /plb@0/xps-ll-temac@81c00000/ethernet@81c00000/phy@7

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Gernot Vormayr <gvormayr@gmail.com>
Cc: devicetree@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
---
No reply since June. http://patchwork.ozlabs.org/patch/248235/
---
 arch/powerpc/boot/dts/virtex440-ml507.dts |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/boot/dts/virtex440-ml507.dts b/arch/powerpc/boot/dts/virtex440-ml507.dts
index fc7073b..391a4e2 100644
--- a/arch/powerpc/boot/dts/virtex440-ml507.dts
+++ b/arch/powerpc/boot/dts/virtex440-ml507.dts
@@ -257,6 +257,8 @@
 			#size-cells = <1>;
 			compatible = "xlnx,compound";
 			ethernet@81c00000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
 				compatible = "xlnx,xps-ll-temac-1.01.b";
 				device_type = "network";
 				interrupt-parent = <&xps_intc_0>;
-- 
1.7.10.4

