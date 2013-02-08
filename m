Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455Ab3BHBwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:52:33 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51938 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab3BHBwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 20:52:31 -0500
Date: Fri, 8 Feb 2013 12:52:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: linux-next: manual merge of the watchdog tree with the mfd tree
Message-Id: <20130208125220.37a34d89ea4cc7e43b27cf4e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Feb_2013_12_52_20_+1100_/5hTjrN9Ff9/3T=m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Feb_2013_12_52_20_+1100_/5hTjrN9Ff9/3T=m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

Today's linux-next merge of the watchdog tree got conflicts in
drivers/watchdog/Kconfig and drivers/watchdog/Makefile between commit
699ff59052e7 ("watchdog: Add support for ux500_wdt watchdog") from the
mfd tree and commit 77b709cb6c9d ("watchdog: introduce retu_wdt driver")
from the watchdog tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/watchdog/Kconfig
index 26e1fdb,3cc04ea..0000000
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@@ -364,18 -366,18 +366,30 @@@ config IMX2_WD
  	  To compile this driver as a module, choose M here: the
  	  module will be called imx2_wdt.
 =20
 +config UX500_WATCHDOG
 +	tristate "ST-Ericsson Ux500 watchdog"
 +	depends on MFD_DB8500_PRCMU
 +	select WATCHDOG_CORE
 +	default y
 +	help
 +	  Say Y here to include Watchdog timer support for the watchdog
 +	  existing in the prcmu of ST-Ericsson Ux500 series platforms.
 +
 +	  To compile this driver as a module, choose M here: the
 +	  module will be called ux500_wdt.
 +
+ config RETU_WATCHDOG
+ 	tristate "Retu watchdog"
+ 	depends on MFD_RETU
+ 	select WATCHDOG_CORE
+ 	help
+ 	  Retu watchdog driver for Nokia Internet Tablets (770, N800,
+ 	  N810). At least on N800 the watchdog cannot be disabled, so
+ 	  this driver is essential and you should enable it.
+=20
+ 	  To compile this driver as a module, choose M here: the
+ 	  module will be called retu_wdt.
+=20
  # AVR32 Architecture
 =20
  config AT32AP700X_WDT
diff --cc drivers/watchdog/Makefile
index bec86ee,15813d4..0000000
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@@ -52,7 -52,7 +52,8 @@@ obj-$(CONFIG_STMP3XXX_RTC_WATCHDOG) +=3D=20
  obj-$(CONFIG_NUC900_WATCHDOG) +=3D nuc900_wdt.o
  obj-$(CONFIG_TS72XX_WATCHDOG) +=3D ts72xx_wdt.o
  obj-$(CONFIG_IMX2_WDT) +=3D imx2_wdt.o
 +obj-$(CONFIG_UX500_WATCHDOG) +=3D ux500_wdt.o
+ obj-$(CONFIG_RETU_WATCHDOG) +=3D retu_wdt.o
 =20
  # AVR32 Architecture
  obj-$(CONFIG_AT32AP700X_WDT) +=3D at32ap700x_wdt.o

--Signature=_Fri__8_Feb_2013_12_52_20_+1100_/5hTjrN9Ff9/3T=m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRFFpUAAoJEECxmPOUX5FE/qcQAIXdkPKndI8FxRq+tkXGNb2j
RKpxsqrTni17WYa7rBUAS3eHcvL5PusqsLQjeYP7yfO+z4SKZ6brHRq12WZ3Hq7k
dBfS3cFguqI2vL7+3+czCY17eRqO+T73roGHQfPRGLPA4TlDz1TjEkUZ4OcqAWLC
O7fslWa9j32oIJyIN1BXfU7VmUtvvY+vbVKootypM3YzQruD5xx2J1xg0MSzMvz5
mx/VxHP6T9lVhNex/EcwFSJAW9t/DjaW7ORsq7qsgD/JrK2bq3NYiU4Xz9+Kbb69
+iZgTXPdIsVlra/yos7H1pT7OI3AmMpN5ROrsWKZoqaMbalSi02Hrh2xPomoAekz
AW9aYXGavtUNBXjTHJz5CSCytm6B9KhZDKvPY4/vSS9d5gKzskhctQHpkpUKQ72/
7tRCQ4AHgiob6Bm0EBnyc5vxlcXCdX0/1VyKL9q5wgF5ZwStRRMjMjAEm7aM3Rkf
QP/XatFqmNhj6GVtKg93KXIkduxI6lvWwbRENgm65E7eCLGB2CNu7UKR3pFOPBAk
oC9UVpzyWkVwzfrPbZrtQmqsqp7vkAcTTbWZ63NpTqHR9fTx3uy4yHnZo09OsIqj
D+w+DJr5sYBdn6EKw0uZrpG3kMaiEUQsFOca1bF2UDSDhfDhHbAJ7eYkE85aZdzo
s8M1b0Drk284vtj02B2a
=OQLJ
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Feb_2013_12_52_20_+1100_/5hTjrN9Ff9/3T=m--
