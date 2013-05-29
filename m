Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965657Ab3E2L1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:27:32 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:32792 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965558Ab3E2L1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:27:30 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: [PATCH 2/2] DT: Add documentation for gpio-xilinx
Date: Wed, 29 May 2013 13:27:08 +0200
Message-Id: <f0768251290255269fa3a864f8399080d6433415.1369826814.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <4b90b06fce0475b579cfba4d968b4778359154f6.1369826814.git.michal.simek@xilinx.com>
References: <4b90b06fce0475b579cfba4d968b4778359154f6.1369826814.git.michal.simek@xilinx.com>
In-Reply-To: <4b90b06fce0475b579cfba4d968b4778359154f6.1369826814.git.michal.simek@xilinx.com>
References: <4b90b06fce0475b579cfba4d968b4778359154f6.1369826814.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-12816-1369826843-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-12816-1369826843-0001

Describe gpio-xilinx binding.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 .../devicetree/bindings/gpio/gpio-xilinx.txt       | 43 ++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-xilinx.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-xilinx.txt b/Documentation/devicetree/bindings/gpio/gpio-xilinx.txt
new file mode 100644
index 0000000..65bf386
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-xilinx.txt
@@ -0,0 +1,43 @@
+Xilinx plb/axi GPIO controller
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
+   services interrupts for this device.
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


--=_mimegpg-monstr-desktop-12816-1369826843-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGl5hsACgkQykllyylKDCFWwgCfZ5JdnFUeJM/RWdw/LgmWNvVI
fDoAnikME8mOpHM2nZ5YWxDxSIcY2/tk
=jZKM
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-12816-1369826843-0001--
