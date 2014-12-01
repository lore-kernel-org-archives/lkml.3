Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbaLAN0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:26:41 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55856 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbaLANZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:25:13 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v5 4/7] ARM: zynq: Extend SLCR driver to read OCM configuration
Date: Mon,  1 Dec 2014 14:24:55 +0100
Message-Id: <bda1e7239b421b43caa1c20f9d34f6f8f94458b3.1417440250.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1417440250.git.michal.simek@xilinx.com>
References: <cover.1417440250.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1417440250.git.michal.simek@xilinx.com>
References: <cover.1417440250.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-3295-1417440309-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-3295-1417440309-0001

Get OCM configuration from SLCR.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v5: None
Changes in v4:
- slcr.h has moved to soc/include/ folder. Move definition there too.

Changes in v3: None
Changes in v2: None

 arch/arm/mach-zynq/slcr.c | 15 +++++++++++++++
 include/soc/zynq/slcr.h   |  1 +
 2 files changed, 16 insertions(+)

diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index b77e42d999c8..f7c606e57525 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -29,6 +29,7 @@
 #define SLCR_A9_CPU_RST_CTRL_OFFSET	0x244 /* CPU Software Reset Control */
 #define SLCR_REBOOT_STATUS_OFFSET	0x258 /* PS Reboot Status */
 #define SLCR_PSS_IDCODE			0x530 /* PS IDCODE */
+#define SLCR_OCM_CFG_OFFSET		0x910 /* OCM Address Mapping */

 #define SLCR_UNLOCK_MAGIC		0xDF0D
 #define SLCR_A9_CPU_CLKSTOP		0x10
@@ -128,6 +129,20 @@ void zynq_slcr_system_reset(void)
 }

 /**
+ * zynq_slcr_get_ocm_config - Get SLCR OCM config
+ *
+ * Return:	OCM config bits
+ */
+u32 zynq_slcr_get_ocm_config(void)
+{
+	u32 val;
+
+	zynq_slcr_read(&val, SLCR_OCM_CFG_OFFSET);
+
+	return val;
+}
+
+/**
  * zynq_slcr_cpu_start - Start cpu
  * @cpu:	cpu number
  */
diff --git a/include/soc/zynq/slcr.h b/include/soc/zynq/slcr.h
index 7b4edab666ee..639723c4f90c 100644
--- a/include/soc/zynq/slcr.h
+++ b/include/soc/zynq/slcr.h
@@ -25,5 +25,6 @@ extern void zynq_slcr_cpu_start(int cpu);
 extern bool zynq_slcr_cpu_state_read(int cpu);
 extern void zynq_slcr_cpu_state_write(int cpu, bool die);
 extern u32 zynq_slcr_get_device_id(void);
+extern u32 zynq_slcr_get_ocm_config(void);

 #endif
--
1.8.2.3


--=_mimegpg-monstr-desktop-3295-1417440309-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlR8bDUACgkQykllyylKDCGbZACfdtz7Wmxu7wdFOdaQZvF8UCsX
H5IAoIEjMO0FwgoJ9uipL5abSv8UYvSr
=KBIH
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-3295-1417440309-0001--
