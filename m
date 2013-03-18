Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750958Ab3CREGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:06:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54205 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3CREGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:06:30 -0400
Date: Mon, 18 Mar 2013 15:06:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the bcm2835 tree with the arm-soc tree
Message-Id: <20130318150628.82d6a8a23fcb36d881764399@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Mar_2013_15_06_28_+1100_Fx8VjLxDnWLJjB0z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Mar_2013_15_06_28_+1100_Fx8VjLxDnWLJjB0z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

Today's linux-next merge of the bcm2835 tree got a conflict in
arch/arm/Kconfig.debug between commit 29c9b7be7574 ("ARM: cns3xxx: move
debug_ll code to include/debug/") from the arm-soc tree and commit
f1ac922dec7e ("ARM: bcm2835: convert to multi-platform") from the bcm2835
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig.debug
index bce30a8,a877d51..0000000
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@@ -593,7 -583,7 +597,8 @@@ endchoic
 =20
  config DEBUG_LL_INCLUDE
  	string
+ 	default "debug/bcm2835.S" if DEBUG_BCM2835
 +	default "debug/cns3xxx.S" if DEBUG_CNS3XXX
  	default "debug/icedcc.S" if DEBUG_ICEDCC
  	default "debug/imx.S" if DEBUG_IMX1_UART || \
  				 DEBUG_IMX25_UART || \

--Signature=_Mon__18_Mar_2013_15_06_28_+1100_Fx8VjLxDnWLJjB0z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRRpLEAAoJEECxmPOUX5FEjQ8P/RFHy3chUAmc2jy5mkqEbc/m
9iP0kwBu26UBFR5dulkpDkuTza9Fum8dJ+mpTnq16RJIE6SAgjKhqm/tpr18gE8l
oly/hxpUjc6m0rmgPnlY1M3z/8UNYfbCowow0LdkUR9nJepbwDXO1kFDz7SnfFkm
gyAe8vxtSLsZWJBtzLW8J31JyFbgpsWWGn+KBm0Bd7pD4IDI30OjDlVqZ92xBIOg
hVmxJDK0P8bEArWf9fJDYZNPL1FLGvz7NPKLlqvb2xAH2NHa6Z7Te6Moa/2mma52
2xbMIAzX6So+J1CtLjSQOI5/3ElkuXpTpoUY0cogCEeHCSFAolbC0Dg525K/OBG7
TIOo2SyGn32De3ATk+OgPLFUFgun0PISlsMSwA/mUYhb4NPqhIpvwrjawd434Llh
mXUCAV8guUhUL33RzrfwZ4ncfzq87HenMBA9+Olfjml53aSI0M4c31WyYHQOGkNY
YUDDGzSWc1GhQ8gOv44tS+s8tmFSnBVFrysjtw7cNEjwEBLxp2CUB1fZsoPNfoLI
RxA3dfbkHl85SBECUbf+sRd7PYMqKzm8In6vgK5FhFktfA6b9EIjZ9sO3cwQXm9+
9D+9kUvoWOzNM4lYxU63FaccfH2SZ9Tb7wxPKYXsm3pM4QAd86jDIaONJbWbNFfC
31fTjbfeVNY1H8FRzb54
=e5Lq
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Mar_2013_15_06_28_+1100_Fx8VjLxDnWLJjB0z--
