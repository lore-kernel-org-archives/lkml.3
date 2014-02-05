Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaBEO4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:56:49 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:52881 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaBEO4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:56:48 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Stephen Warren <swarren@nvidia.com>,
        James Hogan <james.hogan@imgtec.com>,
        Felipe Pena <felipensp@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: zynq: Move of_clk_init from clock driver
Date: Wed,  5 Feb 2014 15:56:37 +0100
Message-Id: <572af6e4eaaaa1c74ea62364f8fa7ac5834cc754.1391612175.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-2821-1391612198-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-2821-1391612198-0001

Move of_clk_init() from clock driver to enable
options not to use zynq clock driver.
Use for example fixed clock setting.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Based on http://www.spinics.net/lists/arm-kernel/msg298287.html
series

---
 arch/arm/mach-zynq/common.c | 1 +
 drivers/clk/zynq/clkc.c     | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 93ea19b..8df35f3 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -68,6 +68,7 @@ static void __init zynq_timer_init(void)
 	zynq_early_slcr_init();

 	zynq_clock_init();
+	of_clk_init(NULL);
 	clocksource_of_init();
 }

diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index 03052d6..c812b93 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -602,8 +602,6 @@ void __init zynq_clock_init(void)
 	of_node_put(slcr);
 	of_node_put(np);

-	of_clk_init(NULL);
-
 	return;

 np_err:
--
1.8.2.3


--=_mimegpg-monstr-desktop-2821-1391612198-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLyUSYACgkQykllyylKDCFurACglzWXKDD+JNKf+nmrVi+2qxJK
HfoAn0/AXRcz6n5by7TK42+MaSTiqcyK
=QLrs
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-2821-1391612198-0001--
