Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbaJ1HKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:10:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbaJ1DpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:45:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreas Henriksson <andreas.henriksson@endian.se>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3.16 088/127] ARM: at91: fix at91sam9263ek DT mmc pinmuxing settings
Date: Tue, 28 Oct 2014 11:35:23 +0800
Message-Id: <20141028033424.708372453@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/at91sam9263.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -535,6 +535,7 @@
 				compatible = "atmel,hsmci";
 				reg = <0xfff80000 0x600>;
 				interrupts = <10 IRQ_TYPE_LEVEL_HIGH 0>;
+				pinctrl-names = "default";
 				#address-cells = <1>;
 				#size-cells = <0>;
 				status = "disabled";
@@ -544,6 +545,7 @@
 				compatible = "atmel,hsmci";
 				reg = <0xfff84000 0x600>;
 				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 0>;
+				pinctrl-names = "default";
 				#address-cells = <1>;
 				#size-cells = <0>;
 				status = "disabled";


