Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaCLWpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:45:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54135 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaCLWpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:45:16 -0400
Date: Wed, 12 Mar 2014 22:45:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Magnus Damm <damm@opensource.se>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140312224507.c7b9e7f45b1135ff6a7942c8@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Mar_2014_22_45_07_+0000_+aYdc+uVZaEI9zP+"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the clockevents tree with the sh tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Mar_2014_22_45_07_+0000_+aYdc+uVZaEI9zP+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

Today's linux-next merge of the clockevents tree got conflicts between the =
renesas tree and the clockevents tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc arch/arm/mach-shmobile/Kconfig
index 5249ff0511a8,c1a9538fb6bb..000000000000
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@@ -116,7 -137,7 +130,8 @@@ config ARCH_R8A779
  	select MIGHT_HAVE_PCI
  	select SH_CLK_CPG
  	select RENESAS_IRQC
 +	select ARCH_DMA_ADDR_T_64BIT if ARM_LPAE
+ 	select SYS_SUPPORTS_SH_CMT
 =20
  config ARCH_R8A7791
  	bool "R-Car M2 (R8A77910)"
@@@ -126,7 -147,7 +141,8 @@@
  	select MIGHT_HAVE_PCI
  	select SH_CLK_CPG
  	select RENESAS_IRQC
 +	select ARCH_DMA_ADDR_T_64BIT if ARM_LPAE
+ 	select SYS_SUPPORTS_SH_CMT
 =20
  config ARCH_EMEV2
  	bool "Emma Mobile EV2"
diff --cc drivers/clocksource/Kconfig
index 6510ec4f45ff,4f754a972139..000000000000
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@@ -141,5 -141,46 +141,49 @@@ config VF_PIT_TIME
  	help
  	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
 =20
 +config CLKSRC_QCOM
 +	bool
++
+ config SYS_SUPPORTS_SH_CMT
+         bool
+=20
+ config SYS_SUPPORTS_SH_MTU2
+         bool
+=20
+ config SYS_SUPPORTS_SH_TMU
+         bool
+=20
+ config SYS_SUPPORTS_EM_STI
+         bool
+=20
+ config SH_TIMER_CMT
+ 	bool "Renesas CMT timer driver" if COMPILE_TEST
+ 	default SYS_SUPPORTS_SH_CMT
+ 	help
+ 	  This enables build of a clocksource and clockevent driver for
+ 	  the Compare Match Timer (CMT) hardware available in 16/32/48-bit
+ 	  variants on a wide range of Mobile and Automotive SoCs from Renesas.
+=20
+ config SH_TIMER_MTU2
+ 	bool "Renesas MTU2 timer driver" if COMPILE_TEST
+ 	default SYS_SUPPORTS_SH_MTU2
+ 	help
+ 	  This enables build of a clockevent driver for the Multi-Function
+ 	  Timer Pulse Unit 2 (TMU2) hardware available on SoCs from Renesas.
+ 	  This hardware comes with 16 bit-timer registers.
+=20
+ config SH_TIMER_TMU
+ 	bool "Renesas TMU timer driver" if COMPILE_TEST
+ 	default SYS_SUPPORTS_SH_TMU
+ 	help
+ 	  This enables build of a clocksource and clockevent driver for
+ 	  the 32-bit Timer Unit (TMU) hardware available on a wide range
+ 	  SoCs from Renesas.
+=20
+ config EM_TIMER_STI
+ 	bool "Renesas STI timer driver" if COMPILE_TEST
+ 	default SYS_SUPPORTS_EM_STI
+ 	help
+ 	  This enables build of a clocksource and clockevent driver for
+ 	  the 48-bit System Timer (STI) hardware available on a SoCs
+ 	  such as EMEV2 from former NEC Electronics.

--Signature=_Wed__12_Mar_2014_22_45_07_+0000_+aYdc+uVZaEI9zP+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIONzAAoJELSic+t+oim9Rd4P/iIsUHwGiJFjEnJ2GgeaB50w
axaaXOCCqtTYg5nJKjoPSrnyxiqscyxCklFM348Nj4YNlopHm6blI9rNqvY02Kzc
fLaOwNDMrQ7OXwQ+BkvdeprW3Gg9T89OHd88ngC4sW2NOk7IQnUEK0/e/5NG0Ly8
yTYlIe3PAuWpgAEJYT3chbSjZQPagiAEENDIH88a6nPw81YwcNT1NEirW/DPwePm
5ou779m4bCr871Tb5wnj7x6JmEKM1EA6LFJr/C5SeN/zUE9TPpiuri/wXr2zbpkz
gf7hAuE8jWq/UwcaxS3HUirh3r7S1Lw/jWc0fLjCRAMlXOE53IP50JVSI6yBuj1M
ubJDaThZ/biYMsR/on4COy3loit8VfwZr+j6K2WGWsI+K9zwfe/Ii1N0BhUztXFF
FdDC67DUlEJqcTCGVuLHZY8niTB256RzxjV0eI7SCCh/Ndk7RufIrjOxI/EJCb0Q
VaU3JPpCeGIr8GVkGTNsZmxgx7YbnDJMvW/GpQ51sipBLqzVENPKpMAWjrs+dyMi
m1Sw1sxEfiWoDmUlWKSb8swnBf+SebW00jKqYy96xizBwIDYIgLBUri0boqVHif+
QyeS2VamKFiZHsdVGK11dAA1Twve8FNMbjkU/ZYgiNFG0vGyXyXP2QWjOCeS8TEI
w1Jfjco97Sw07rBMmYhF
=gSWH
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Mar_2014_22_45_07_+0000_+aYdc+uVZaEI9zP+--
