Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaCCH7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:59:50 -0500
Received: from ozlabs.org ([203.10.76.45]:53149 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820AbaCCH7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:59:48 -0500
Date: Mon, 3 Mar 2014 18:59:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        Rob Herring <robh@kernel.org>
Subject: linux-next: manual merge of the akpm-current tree with the arm-soc
 tree
Message-Id: <20140303185940.a4fd9da2d758967f3bc52a09@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Mar_2014_18_59_40_+1100_RAa5FDg2MWblG/ri"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Mar_2014_18_59_40_+1100_RAa5FDg2MWblG/ri
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
arch/arm/mach-prima2/Kconfig between commit 9352b05b6e4e ("ARM: select
MIGHT_HAVE_CACHE_L2X0 for V6 and V7 multi-platform") from the arm-soc
tree and commit b096b0b50c4b ("Kconfig: rename HAS_IOPORT to
HAS_IOPORT_MAP") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-prima2/Kconfig
index 2c726b4f9356,850ff5500821..000000000000
--- a/arch/arm/mach-prima2/Kconfig
+++ b/arch/arm/mach-prima2/Kconfig
@@@ -1,8 -1,10 +1,8 @@@
  config ARCH_SIRF
  	bool "CSR SiRF" if ARCH_MULTI_V7
  	select ARCH_REQUIRE_GPIOLIB
 -	select GENERIC_CLOCKEVENTS
  	select GENERIC_IRQ_CHIP
- 	select NO_IOPORT
 -	select MIGHT_HAVE_CACHE_L2X0
+ 	select NO_IOPORT_MAP
  	select PINCTRL
  	select PINCTRL_SIRF
  	help

--Signature=_Mon__3_Mar_2014_18_59_40_+1100_RAa5FDg2MWblG/ri
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFDZxAAoJEMDTa8Ir7ZwV9IkP/iCPbHRSyIVOKDWu0431Musb
ylyFUvmrMYI9LA5rpAA3TIE6ErgevJdIO+wQnPeFgqDPoAhgVrVoqp4LfNTQzVGu
RRNMsIVb3dWpotDy2fqmhuuBcO3Hp1d8R104LfIRMsKo3rItIDQNYZllbVxllEdA
FSMy9xfL9IaczqQbutY/Zqw2NhG0OEF+x2g55NsKz0cQ1r6SdFsQpvzrXqagIrij
ZHIi2GOQ2ZQVkMzJZOZs61eJFPvfkySWpoBFMCErRxFgXlSPlOHrMhwTatomKdXB
1q0SFNUtba2m7vLYmeegyi9yf+yCCYvxigWOjUa4N5HA1HW/avDDfpLE8Wivm/OC
bvwzEpZyeURdawCTSF1CfFBXI9pwUvCBwJxqBvqSER9/74LuyLCzJWXR0veL4VNZ
Wwjbr0IuDAmRwXdieOLmUdJRijjSBGhR34C4906BZ4GrzetohlNBdt0ZXngxZj1J
PM9t4pIIMGvZ1lchW8ss53Z83cAt57uQC/YazJ+ByShofXL56QnxgF7D1jbiRlDV
Y+zqeVuQbUin3nSY7EXnVytmKJOeSok2wv17VT3VPoqJHLMbhiuwA5CEmtfKdZvB
taju/5Mamvl2+mJpDEe2MaaBzNdnZs0rn5V4qfRxKT5wjHo9CtMPZ/RVwHaMHBrF
b6kh3SlPbAQeIDpKzmpZ
=lEth
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Mar_2014_18_59_40_+1100_RAa5FDg2MWblG/ri--
