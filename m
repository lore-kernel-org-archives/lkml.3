Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3KFIPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:15:10 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44965 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab3KFIPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:15:08 -0500
Date: Wed, 6 Nov 2013 19:14:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2?= =?UTF-8?B?bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: linux-next: manual merge of the gpio tree with the arm-soc and
 cortex trees
Message-Id: <20131106191454.5f45b0b5300f03e74a6a09eb@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Nov_2013_19_14_54_+1100_y8bxG1i+DucTpGYW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Nov_2013_19_14_54_+1100_y8bxG1i+DucTpGYW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the gpio tree got a conflict in
arch/arm/Kconfig between commit f3372c01816e ("ARM: gemini: convert to
GENERIC_CLOCKEVENTS") from the arm-soc tree and f5caa3b59e18 ("ARM:
deprecate mach/timex.h for !ARCH_MULTIPLATFORM") from the cortex tree and
commits ffde39ea61ea ("ARM: mmp: delete the custom GPIO header"),
88f718e3fa4d ("ARM: pxa: delete the custom GPIO header") and 85649711a895
("ARM: gemini: delete <mach/gpio.h>") from the gpio tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig
index 568d6471dd18,c6debe07f036..000000000000
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -397,10 -386,8 +397,9 @@@ config ARCH_CLPS711
  config ARCH_GEMINI
  	bool "Cortina Systems Gemini"
  	select ARCH_REQUIRE_GPIOLIB
 -	select ARCH_USES_GETTIMEOFFSET
 +	select CLKSRC_MMIO
  	select CPU_FA526
 +	select GENERIC_CLOCKEVENTS
- 	select NEED_MACH_GPIO_H
  	help
  	  Support for the Cortina Systems Gemini family SoCs
 =20
@@@ -593,8 -558,6 +592,7 @@@ config ARCH_MM
  	select GPIO_PXA
  	select IRQ_DOMAIN
  	select MULTI_IRQ_HANDLER
- 	select NEED_MACH_GPIO_H
 +	select NEED_MACH_TIMEX_H
  	select PINCTRL
  	select PLAT_PXA
  	select SPARSE_IRQ
@@@ -658,8 -620,6 +656,7 @@@ config ARCH_PX
  	select GPIO_PXA
  	select HAVE_IDE
  	select MULTI_IRQ_HANDLER
- 	select NEED_MACH_GPIO_H
 +	select NEED_MACH_TIMEX_H
  	select PLAT_PXA
  	select SPARSE_IRQ
  	help

--Signature=_Wed__6_Nov_2013_19_14_54_+1100_y8bxG1i+DucTpGYW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSefqDAAoJEMDTa8Ir7ZwVQ/MP/Race/J+Lb9uhNafqypyW253
U+dflHaEaExFmuneLmMwaMRzaZD5ek60F/IiCHr+ZDErPf2qjzhZB3xiwHmt5qFJ
VoIu97EvHuRqLVJKur7lHZ6uBo4EOq6GJXNzDFjKn4yLYjZ+4bOTMqGkXJzAG1bm
rAnx0X5qnGcSYQancIpsbjlZYkPahYeGPztcWrm7W/fomnuPtiaBVOgVsQ7aDols
jXe+Bzi6xPoS4/Q1KPNPAGAwXfsRWL8ofNNLLxVfcY/irhrgs3rn28cmpeHI6vld
Usrm6ifvxKD8ZhxuC6Th2l2/fPidC02Arwo9cCvWRFQqgkzXSGVVVkX6ovEs4bmY
H3OQkvkLr0LDUWRARls/XDekBK31w363YQm1zc1KAmnV2UKG0kVHIWUbLuewUVFZ
4eWvMfemGORpCn2aNI7YM/jzO08881XS3nBPFFCNyB1JQlcPJx6uS6BgJMfyDhDU
qpa0ZWCTaSGFpU0aLRkzMiAUBJhMacy4kd4Hk1zjAvINDFhHd6movlU1e6n9eTGo
ifMgXB/L1ofBrY39OJjMj+sNk7cXAY55cob/lpKec1jPtJ70bL4DaFrqBtVt+kJi
p24s+hjJlZo4cCqt30a7N32kUTPE1RtUperAuhBfDA1offU0+G8m4WiR4roxGYc7
jZos3oufnklJK28KZnbN
=8P4D
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Nov_2013_19_14_54_+1100_y8bxG1i+DucTpGYW--
