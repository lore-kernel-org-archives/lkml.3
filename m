Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab3FCMcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:32:13 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:48090 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626Ab3FCMcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:32:09 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: [PATCH v2 6/6] DT: Add documentation for gpio-xilinx
Date: Mon,  3 Jun 2013 14:31:21 +0200
Message-Id: <af7595252de09373f5591f21262e5ffa7c9e0dc2.1370262666.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
In-Reply-To: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-25624-1370262725-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-25624-1370262725-0001

Describe gpio-xilinx binding.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v2:
- Extend description

 .../devicetree/bindings/gpio/gpio-xilinx.txt       | 48 ++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-xilinx.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-xilinx.txt b/Documentation/devicetree/bindings/gpio/gpio-xilinx.txt
new file mode 100644
index 0000000..63bf4be
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-xilinx.txt
@@ -0,0 +1,48 @@
+Xilinx plb/axi GPIO controller
+
+Dual channel GPIO controller with configurable number of pins
+(from 1 to 32 per channel). Every pin can be configured as
+input/output/tristate. Both channels share the same global IRQ but
+local interrupts can be enabled on channel basis.
+
+Required properties:
+- compatible : Should be "xlnx,xps-gpio-1.00.a"
+- reg : Address and length of the register set for the device
+- #gpio-cells : Should be two. The first cell is the pin number and the
+  second cell is used to specify optional parameters (currently unused).
+- gpio-controller : Marks the device node as a GPIO controller.
+
+Optional properties:
+- interrupts : Interrupt mapping for GPIO IRQ.
+- interrupt-parent : Phandle for the interrupt controller that
+  services interrupts for this device.
+- xlnx,all-inputs : if n-th bit is setup, GPIO-n is input
+- xlnx,dout-default : if n-th bit is 1, GPIO-n default value is 1
+- xlnx,gpio-width : gpio width
+- xlnx,tri-default : if n-th bit is 1, GPIO-n is in tristate mode
+- xlnx,is-dual : if 1, controller also uses the second channel
+- xlnx,all-inputs-2 : as above but for the second channel
+- xlnx,dout-default-2 : as above but the second channel
+- xlnx,gpio2-width : as above but for the second channel
+- xlnx,tri-default-2 : as above but for the second channel
+
+
+Example:
+gpio: gpio@40000000 {
+	#gpio-cells = <2>;
+	compatible = "xlnx,xps-gpio-1.00.a";
+	gpio-controller ;
+	interrupt-parent = <&microblaze_0_intc>;
+	interrupts = < 6 2 >;
+	reg = < 0x40000000 0x10000 >;
+	xlnx,all-inputs = <0x0>;
+	xlnx,all-inputs-2 = <0x0>;
+	xlnx,dout-default = <0x0>;
+	xlnx,dout-default-2 = <0x0>;
+	xlnx,gpio-width = <0x2>;
+	xlnx,gpio2-width = <0x2>;
+	xlnx,interrupt-present = <0x1>;
+	xlnx,is-dual = <0x1>;
+	xlnx,tri-default = <0xffffffff>;
+	xlnx,tri-default-2 = <0xffffffff>;
+} ;
--
1.8.2.3


--=_mimegpg-monstr-desktop-25624-1370262725-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGsjMUACgkQykllyylKDCFjzwCgnkPMFRTVvkWVatG7yQ0KvOH9
5XUAn16LKaX63p7hlqq+OJo59FBx/O7O
=V4wL
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-25624-1370262725-0001--
