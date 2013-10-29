Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3J2H53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 03:57:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50985 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3J2H51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 03:57:27 -0400
Date: Tue, 29 Oct 2013 18:57:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the  tree
Message-Id: <20131029185714.f6a1eef0e6700b989bbdf5dc@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Oct_2013_18_57_14_+1100_+KuC8KQGUKEsinI+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Oct_2013_18_57_14_+1100_+KuC8KQGUKEsinI+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/Kconfig between commit 85649711a895 ("ARM: gemini: delete
<mach/gpio.h>") from the gpio tree and commit f3372c01816e ("ARM: gemini:
convert to GENERIC_CLOCKEVENTS") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig
index 55be62c92b60,04163fece49f..000000000000
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -391,8 -385,10 +390,9 @@@ config ARCH_CLPS711
  config ARCH_GEMINI
  	bool "Cortina Systems Gemini"
  	select ARCH_REQUIRE_GPIOLIB
- 	select ARCH_USES_GETTIMEOFFSET
+ 	select CLKSRC_MMIO
  	select CPU_FA526
+ 	select GENERIC_CLOCKEVENTS
 -	select NEED_MACH_GPIO_H
  	help
  	  Support for the Cortina Systems Gemini family SoCs
 =20

--Signature=_Tue__29_Oct_2013_18_57_14_+1100_+KuC8KQGUKEsinI+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSb2peAAoJEMDTa8Ir7ZwVECsP/1jI8IAV3tqXnS7odzRtlbVa
tph2rtv4SI9IQ3dwk4LCh0h4SQmzUwW+1PqQyJ2xQSk6lc/Big6cVfriIUK39Fa6
nrbINZoA3VHdB2ONZZzfDuLaqvx7YEwgN1j5CZXg7bazyGr3THbyAD04w/J0gSeI
RoddLBOl7ZDUUPnSHBl05e3RUgalEizIk5hV2Wo4giC0QPCkMPYn58tPX43tSJ+w
swbA49caGkCPXiBnwa+yJywUNRZb7lZoPz9R3gBNOksdB2tuFgKiKaDITc/BAZwh
JwgU6taQlxlx0x9hsBcWor0h4eFRDjVp48OimWOHgKdRPcOTDX9XgQZXKpptubY7
W/Oha8Ix64HlAIBgxn1kUJe0VGQvVkyH1GtGZk+ZR//oculnGnqRtqczxAFGbfRF
Ib9MJwYBNG13IS62koBFKxdErrgQMt+2RkVsFStEc6jkcVdna9RlHdC4AQAHUSiB
wl+gQc0Mcl6dk4IqTw2egH2l32WBKC5S0I554FNuIf5qDUD5ocZ41zukJDZsfrrl
CoqkhXBC2QCM0u70GLbZlEVFg+TTFd8dbrX27nB6V1dx6kCfI114QXdCoTraegzE
npBbvTtQbvOXyDqLbwLHI1VC8+EiEnsve9sFWnj+nVQa7ovicOJ17GahqwU7l7t9
+dEWilcqZKooV9IBYRtf
=mq9d
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Oct_2013_18_57_14_+1100_+KuC8KQGUKEsinI+--
