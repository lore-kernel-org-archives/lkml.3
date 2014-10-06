Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaJFLoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:44:54 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43541 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaJFLor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:44:47 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ARM: zynq: Extend SLCR driver to read OCM configuration
Date: Mon,  6 Oct 2014 13:44:26 +0200
Message-Id: <586ef67a22005316fd65cebbbd4019a8a2094e07.1412595859.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <565908c2d70764e281d6a9b28d9599cea87823a3.1412595859.git.michal.simek@xilinx.com>
References: <565908c2d70764e281d6a9b28d9599cea87823a3.1412595859.git.michal.simek@xilinx.com>
In-Reply-To: <565908c2d70764e281d6a9b28d9599cea87823a3.1412595859.git.michal.simek@xilinx.com>
References: <565908c2d70764e281d6a9b28d9599cea87823a3.1412595859.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-12334-1412595883-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-12334-1412595883-0001

Get OCM configuration from SLCR.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/arm/mach-zynq/slcr.c | 15 +++++++++++++++
 include/soc/zynq/common.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index cb7c46165728..0c3e45090c09 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -27,6 +27,7 @@
 #define SLCR_A9_CPU_RST_CTRL_OFFSET	0x244 /* CPU Software Reset Control */
 #define SLCR_REBOOT_STATUS_OFFSET	0x258 /* PS Reboot Status */
 #define SLCR_PSS_IDCODE			0x530 /* PS IDCODE */
+#define SLCR_OCM_CFG_OFFSET		0x910 /* OCM Address Mapping */

 #define SLCR_UNLOCK_MAGIC		0xDF0D
 #define SLCR_A9_CPU_CLKSTOP		0x10
@@ -126,6 +127,20 @@ void zynq_slcr_system_reset(void)
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
diff --git a/include/soc/zynq/common.h b/include/soc/zynq/common.h
index f652f0a884a6..fc6b1ed37455 100644
--- a/include/soc/zynq/common.h
+++ b/include/soc/zynq/common.h
@@ -25,6 +25,7 @@ extern void zynq_slcr_system_reset(void);
 extern void zynq_slcr_cpu_stop(int cpu);
 extern void zynq_slcr_cpu_start(int cpu);
 extern u32 zynq_slcr_get_device_id(void);
+extern u32 zynq_slcr_get_ocm_config(void);

 #ifdef CONFIG_SMP
 extern void secondary_startup(void);
--
1.8.2.3


--=_mimegpg-monstr-desktop-12334-1412595883-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlQygKsACgkQykllyylKDCFcwQCfQJD4m/WCinOLU/qOaHVCxw9T
nMoAnjDS3E0DPFnKlqpOq3RWCwMemgn1
=DcQk
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-12334-1412595883-0001--
