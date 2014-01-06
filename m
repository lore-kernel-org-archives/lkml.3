Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaAFOhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:37:16 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:57895 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaAFOhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:37:11 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] ARM: zynq: Move clock_init from slcr to common
Date: Mon,  6 Jan 2014 15:36:37 +0100
Message-Id: <3374e74f85daade60ec31b3aa05151bbe39759d0.1389018985.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1389018985.git.michal.simek@xilinx.com>
References: <cover.1389018985.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1389018985.git.michal.simek@xilinx.com>
References: <cover.1389018985.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-32317-1389019018-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-32317-1389019018-0001

From: Steffen Trumtrar <s.trumtrar@pengutronix.de>

Preparation step for next changes.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 arch/arm/mach-zynq/common.c | 2 ++
 arch/arm/mach-zynq/slcr.c   | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 1db2a5ca..bf6717f 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -64,6 +64,8 @@ static void __init zynq_init_machine(void)
 static void __init zynq_timer_init(void)
 {
 	zynq_slcr_init();
+
+	zynq_clock_init(zynq_slcr_base);
 	clocksource_of_init();
 }

diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index 1836d5a..59ad09f 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -106,8 +106,6 @@ int __init zynq_slcr_init(void)

 	pr_info("%s mapped to %p\n", np->name, zynq_slcr_base);

-	zynq_clock_init(zynq_slcr_base);
-
 	of_node_put(np);

 	return 0;
--
1.8.2.3


--=_mimegpg-monstr-desktop-32317-1389019018-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLKv4oACgkQykllyylKDCGUkACfb2odKQ6Y6JzraBBb/bjhpMk1
LGcAoIEx05SY8iNX7vhaHVF1ovTGciU0
=NPS1
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-32317-1389019018-0001--
