Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaLANZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:25:17 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34671 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbaLANZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:25:11 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/7] ARM: zynq: Move slcr.h and smp.h to generic location
Date: Mon,  1 Dec 2014 14:24:54 +0100
Message-Id: <edff974dd95ea07b0a9c7caa0dedc0f660c15838.1417440250.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1417440250.git.michal.simek@xilinx.com>
References: <cover.1417440250.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1417440250.git.michal.simek@xilinx.com>
References: <cover.1417440250.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-3286-1417440307-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-3286-1417440307-0001

include/soc/zynq/ is the right location for this header
to be able to share information from this header with other
drivers which require it.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v5: None
Changes in v4:
- Move only slcr.h and smp.h and keep common.h in platform
  which is not needed by OCMC driver
  Based on Arnd request: https://lkml.org/lkml/2014/10/20/268
  Not all symbols from slcr.h/smp.h will be used by OCMC driver
  - no problem to remove them if it is needed
- Add record to MAINTAINERS file

Changes in v3: None
Changes in v2:
- Update pm.c added in 3.17 too - Soren pointed on it

 MAINTAINERS                                     | 1 +
 arch/arm/mach-zynq/common.c                     | 4 ++--
 arch/arm/mach-zynq/platsmp.c                    | 5 +++--
 arch/arm/mach-zynq/slcr.c                       | 3 ++-
 {arch/arm/mach-zynq => include/soc/zynq}/slcr.h | 0
 {arch/arm/mach-zynq => include/soc/zynq}/smp.h  | 0
 6 files changed, 8 insertions(+), 5 deletions(-)
 rename {arch/arm/mach-zynq => include/soc/zynq}/slcr.h (100%)
 rename {arch/arm/mach-zynq => include/soc/zynq}/smp.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index a20df9bf8ab0..7b6ed1f667ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1550,6 +1550,7 @@ S:	Supported
 F:	arch/arm/mach-zynq/
 F:	drivers/cpuidle/cpuidle-zynq.c
 F:	drivers/block/xsysace.c
+F:	include/soc/zynq/
 N:	zynq
 N:	xilinx
 F:	drivers/clocksource/cadence_ttc_timer.c
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 947e72b79496..d30ecc1a7641 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -43,8 +43,8 @@
 #include <asm/hardware/cache-l2x0.h>

 #include "common.h"
-#include "slcr.h"
-#include "smp.h"
+#include <soc/zynq/slcr.h>
+#include <soc/zynq/smp.h>

 #define ZYNQ_DEVCFG_MCTRL		0x80
 #define ZYNQ_DEVCFG_PS_VERSION_SHIFT	28
diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index 717ba2b922b1..6d2b8a16b6c3 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -25,9 +25,10 @@
 #include <asm/cacheflush.h>
 #include <asm/smp_scu.h>
 #include <linux/irqchip/arm-gic.h>
+
 #include "common.h"
-#include "slcr.h"
-#include "smp.h"
+#include <soc/zynq/slcr.h>
+#include <soc/zynq/smp.h>

 /*
  * Store number of cores in the system
diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index 40f8d7420334..b77e42d999c8 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -20,7 +20,8 @@
 #include <linux/regmap.h>
 #include <linux/clk/zynq.h>
 #include "common.h"
-#include "slcr.h"
+#include <soc/zynq/slcr.h>
+#include <soc/zynq/smp.h>

 /* register offsets */
 #define SLCR_UNLOCK_OFFSET		0x8   /* SCLR unlock register */
diff --git a/arch/arm/mach-zynq/slcr.h b/include/soc/zynq/slcr.h
similarity index 100%
rename from arch/arm/mach-zynq/slcr.h
rename to include/soc/zynq/slcr.h
diff --git a/arch/arm/mach-zynq/smp.h b/include/soc/zynq/smp.h
similarity index 100%
rename from arch/arm/mach-zynq/smp.h
rename to include/soc/zynq/smp.h
--
1.8.2.3


--=_mimegpg-monstr-desktop-3286-1417440307-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlR8bDMACgkQykllyylKDCF3hQCeO2dY+xCMZvVbOmOaHSOjX3m3
g0sAn2xyrySrvxzKdiykuW4x4VbhrgiS
=GQYD
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-3286-1417440307-0001--
