Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965234AbaKNKwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:52:23 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:42292 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965199AbaKNKwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:52:19 -0500
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
Subject: [PATCH v4 3/6] ARM: zynq: Move slcr.h and smp.h to generic location
Date: Fri, 14 Nov 2014 11:52:04 +0100
Message-Id: <104ae4ce194398e02f5e031365269c4054339391.1415962281.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1415962281.git.michal.simek@xilinx.com>
References: <cover.1415962281.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1415962281.git.michal.simek@xilinx.com>
References: <cover.1415962281.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-14112-1415962335-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-14112-1415962335-0001

include/soc/zynq/ is the right location for this header
to be able to share information from this header with other
drivers which require it.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

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
index 60b1163dba28..279e87eef71c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1551,6 +1551,7 @@ S:	Supported
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


--=_mimegpg-monstr-desktop-14112-1415962335-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlRl3t8ACgkQykllyylKDCHDuACffX5wWfsYPY4CALawFxqAVW0V
wdoAn1xICpGrhM7VZ7n0jRoma/lnjTkb
=0nRl
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-14112-1415962335-0001--
