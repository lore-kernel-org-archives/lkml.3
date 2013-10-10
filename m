Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab3JJQpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:45:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37649 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621Ab3JJQpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:45:07 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Rajendra Nayak <rnayak@ti.com>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH] ARM: dts: omap4-panda-es: Do not reset gpio1
Date: Thu, 10 Oct 2013 11:44:41 -0500
Message-ID: <1381423481-5920-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381313521-10422-1-git-send-email-rnayak@ti.com>
References: <1381313521-10422-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not reset GPIO1 at boot-up because GPIO 7 in GPIO1 block is used on
OMAP4460 PandaBoard-ES to select voltage register in TPS62361 which
supplies VDD_MPU.

Without this, OMAP4460 PandaBoard-ES boards fail to boot-up because
MPU voltage switches over to VSET0 voltage value (boot voltage) which
is not sufficient to operate the device at OPP100.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
As explained here: http://marc.info/?l=u-boot&m=133066647800872&w=2

GPIO1 reset causes PandaBoard-ES to stop functioning.
This depends on Patch series from Rajendra:
http://marc.info/?l=linux-doc&m=138131355520116&w=2
Applies on Benoit's for_13/dts branch:
https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.13/dts

Tested on PandaBoard-ES without the u-boot uenv hack

 arch/arm/boot/dts/omap4-panda-es.dts |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
index 56c4354..816d1c9 100644
--- a/arch/arm/boot/dts/omap4-panda-es.dts
+++ b/arch/arm/boot/dts/omap4-panda-es.dts
@@ -62,3 +62,7 @@
 		gpios = <&gpio1 8 GPIO_ACTIVE_HIGH>;
 	};
 };
+
+&gpio1 {
+	 ti,no-reset-on-init;
+};
-- 
1.7.9.5

