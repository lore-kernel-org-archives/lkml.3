Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaAFOiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:38:03 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:34578 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbaAFOht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:37:49 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] ARM: zynq: Introduce zynq_slcr_unlock()
Date: Mon,  6 Jan 2014 15:36:43 +0100
Message-Id: <bf130aff62c16b98b2372c328ee593de92431c41.1389018985.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1389018985.git.michal.simek@xilinx.com>
References: <cover.1389018985.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1389018985.git.michal.simek@xilinx.com>
References: <cover.1389018985.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-32383-1389019064-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-32383-1389019064-0001

Call special function for unlocking SLCR.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 arch/arm/mach-zynq/slcr.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index f0f6a69..c1f1499 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -71,6 +71,18 @@ static int zynq_slcr_read(u32 *val, u32 offset)
 }

 /**
+ * zynq_slcr_unlock - Unlock SLCR registers
+ *
+ * return:	a negative value on error, 0 on success
+ */
+static inline int zynq_slcr_unlock(void)
+{
+	zynq_slcr_write(SLCR_UNLOCK_MAGIC, SLCR_UNLOCK_OFFSET);
+
+	return 0;
+}
+
+/**
  * zynq_slcr_system_reset - Reset the entire system.
  */
 void zynq_slcr_system_reset(void)
@@ -82,7 +94,7 @@ void zynq_slcr_system_reset(void)
 	 * Note that this seems to require raw i/o
 	 * functions or there's a lockup?
 	 */
-	writel(SLCR_UNLOCK_MAGIC, zynq_slcr_base + SLCR_UNLOCK_OFFSET);
+	zynq_slcr_unlock();

 	/*
 	 * Clear 0x0F000000 bits of reboot status register to workaround
@@ -164,7 +176,7 @@ int __init zynq_early_slcr_init(void)
 	np->data = (__force void *)zynq_slcr_base;

 	/* unlock the SLCR so that registers can be changed */
-	writel(SLCR_UNLOCK_MAGIC, zynq_slcr_base + SLCR_UNLOCK_OFFSET);
+	zynq_slcr_unlock();

 	pr_info("%s mapped to %p\n", np->name, zynq_slcr_base);

--
1.8.2.3


--=_mimegpg-monstr-desktop-32383-1389019064-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLKv7gACgkQykllyylKDCEBhgCeO80eM3WF2qYstQF2B1uaSIY5
XgwAnA1tIB/yj2uP714rU6L8b6wVrY7r
=CWHp
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-32383-1389019064-0001--
