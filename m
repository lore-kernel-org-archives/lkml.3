Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531AbaH0J6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:58:17 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:17881 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932914AbaH0J6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:58:15 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2014 05:58:14 EDT
From: Bo Shen <voice.shen@atmel.com>
To: <nicolas.ferre@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH] dtb: at91: sam9n12ek: ohci: add port and vbus property
Date: Wed, 27 Aug 2014 17:52:49 +0800
Message-ID: <1409133169-26741-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the port number and vbus property for ohci port, or else if
bootloader won't configure the vbus pin, the 5v supply is not
power on, so can not work with usb devices.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 arch/arm/boot/dts/at91sam9n12ek.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
index 83d7237..13bb24e 100644
--- a/arch/arm/boot/dts/at91sam9n12ek.dts
+++ b/arch/arm/boot/dts/at91sam9n12ek.dts
@@ -136,6 +136,8 @@
 		};
 
 		usb0: ohci@00500000 {
+			num-ports = <1>;
+			atmel,vbus-gpio = <&pioB 7 GPIO_ACTIVE_LOW>;
 			status = "okay";
 		};
 	};
-- 
1.8.5.2

