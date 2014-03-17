Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaCQFiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 01:38:12 -0400
Received: from ozlabs.org ([203.10.76.45]:36788 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaCQFiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 01:38:10 -0400
Date: Mon, 17 Mar 2014 16:37:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, Magnus Damm <damm@opensource.se>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Wolfram Sang <wsa@sang-engineering.com>
Subject: linux-next: manual merge of the tip tree with the arm-soc tree
Message-Id: <20140317163752.f93d266cffa1cbdfcd1f9f8d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_16_37_52_+1100_6j/c2XGPZQ=Wejqo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_16_37_52_+1100_6j/c2XGPZQ=Wejqo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/clocksource/Kconfig between commit 3f8e8cee2f4b ("clocksource:
qcom: Move clocksource code out of mach-msm") from the arm-soc tree and
commit fd3f1270d237 ("clocksource: Add Kconfig entries for CMT, MTU2, TMU
and STI") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

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

--Signature=_Mon__17_Mar_2014_16_37_52_+1100_6j/c2XGPZQ=Wejqo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJoo1AAoJEMDTa8Ir7ZwVhHAP/iRxgIYU8IJLeMBdDPuY/Gbt
UVMh22WrIrN9k+FDPta6uVSiCAm2KRIQCNYltIaUUcNNG3jLZAW0y84hikWu0twn
zMBXg8k1lvlABgrBfce0Ue0+k/+OXhHNZZaDn/9yifB2RcYO8ZzCbEVAEFwh1UFZ
hoZNEDRJkHqVeXfNv6NoOSH0RcfWg7/TkwSuyxDIE3DZJFk7/Wy/0CAXvxyioRUW
4p7y1FYFzSSc8nl/0Aj/qFqm3pJIWGa11CJ2dfIzEVG4Oe84SaspkzArVppST3fv
NpMdFvwz3vZHUjp4YIqBWtGu2d7JTbu3r0GoLFHpzNl/OlZK4oIuS3/oaBrA9ONt
VoD/VGdbni3XLG8arqxIK7P0i1yemxtBVuigBhEmIXnog2SWGHCQ+ZVR2eHUhahv
kDkRWzyR7p72xIuEt7VMZR2yRafKT14t12xVXmfwmIkUif2O2SvpaCHvnGUfp/e+
2sA2S6KLokgWEGgAM1v9yxtS4atsWy6OgiemLIYKLtYab6JIJ1bsh4Cu2QSm0Hqg
fOj0xUqVDbOmUXgnDZ1CbIQP2lqrZ+pZSLCAS/1YqKMZSfWptozc86AeTJH624Ah
Or9oCgt5KHCL1F3qPfjRPlbBqIzi4eOyx97ubmfvGze7dvg5DE+a9xXv/JdPCKIH
I2MZ90n3dEkxJcNpIDrQ
=3RKR
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_16_37_52_+1100_6j/c2XGPZQ=Wejqo--
