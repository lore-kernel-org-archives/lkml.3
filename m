Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaJ0TDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:03:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52746 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbaJ0TDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Henriksson <andreas.henriksson@endian.se>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 043/105] ARM: at91: fix at91sam9263ek DT mmc pinmuxing settings
Date: Mon, 27 Oct 2014 11:56:18 -0700
Message-Id: <1414436240-13879-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Henriksson <andreas.henriksson@endian.se>

commit b65e0fb3d046cc65d0a3c45d43de351fb363271b upstream.

As discovered on a custom board similar to at91sam9263ek and basing
its devicetree on that one apparently the pin muxing doesn't get
set up properly. This was discovered since the custom boards u-boot
does funky stuff with the pin muxing and leaved it set to SPI
which made the MMC driver not work under Linux.
The fix is simply to define the given configuration as the default.
This probably worked by pure luck before, but it's better to
make the muxing explicitly set.

Signed-off-by: Andreas Henriksson <andreas.henriksson@endian.se>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/boot/dts/at91sam9263.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index d5bd65f..55bb7f3 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -506,6 +506,7 @@
 				compatible = "atmel,hsmci";
 				reg = <0xfff80000 0x600>;
 				interrupts = <10 IRQ_TYPE_LEVEL_HIGH 0>;
+				pinctrl-names = "default";
 				#address-cells = <1>;
 				#size-cells = <0>;
 				status = "disabled";
@@ -515,6 +516,7 @@
 				compatible = "atmel,hsmci";
 				reg = <0xfff84000 0x600>;
 				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 0>;
+				pinctrl-names = "default";
 				#address-cells = <1>;
 				#size-cells = <0>;
 				status = "disabled";
-- 
1.9.1

