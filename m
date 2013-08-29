Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab3H2H7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:59:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35325 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab3H2H7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:59:35 -0400
Date: Thu, 29 Aug 2013 17:59:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Simon Horman <horms@verge.net.au>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: linux-next: manual merge of the arm-soc tree with the v4l-dvb tree
Message-Id: <20130829175932.de8fe48f48a152172dd3d770@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Aug_2013_17_59_32_+1000_+pQ.1qqPSxuDjH7Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Aug_2013_17_59_32_+1000_+pQ.1qqPSxuDjH7Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-shmobile/setup-r8a7779.c between commit 4714a0255eee
("[media] ARM: shmobile: r8a7779: add VIN support") from the v4l-dvb tree
and commit fee529df76ff ("ARM: shmobile: r8a7779: cleanup registration of
usb phy") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/setup-r8a7779.c
index 3d89288,6a99333..0000000
--- a/arch/arm/mach-shmobile/setup-r8a7779.c
+++ b/arch/arm/mach-shmobile/setup-r8a7779.c
@@@ -629,24 -648,6 +675,16 @@@ void __init r8a7779_add_ether_device(st
  					  pdata, sizeof(*pdata));
  }
 =20
- void __init r8a7779_add_usb_phy_device(struct rcar_phy_platform_data *pda=
ta)
- {
- 	platform_device_register_resndata(&platform_bus, "rcar_usb_phy", -1,
- 					  usb_phy_resources,
- 					  ARRAY_SIZE(usb_phy_resources),
- 					  pdata, sizeof(*pdata));
- }
-=20
 +void __init r8a7779_add_vin_device(int id, struct rcar_vin_platform_data =
*pdata)
 +{
 +	BUG_ON(id < 0 || id > 3);
 +
 +	vin_info_table[id]->data =3D pdata;
 +	vin_info_table[id]->size_data =3D sizeof(*pdata);
 +
 +	platform_device_register_full(vin_info_table[id]);
 +}
 +
  /* do nothing for !CONFIG_SMP or !CONFIG_HAVE_TWD */
  void __init __weak r8a7779_register_twd(void) { }
 =20

--Signature=_Thu__29_Aug_2013_17_59_32_+1000_+pQ.1qqPSxuDjH7Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHv9kAAoJEECxmPOUX5FEH7wP/j9+2ZF9m6YHDhGTFs3qT8Tf
2JxET/vyOBmEMWRkCPz8mpEmYVgzRSg2K9vnn3kLBftzwyhvPdJ6jAV6+mDPK4ek
AaNIK8gGX4gf1Cpxd4sGllo/Lfpv7ycfB01D0YYrFps4NXIfdFe2lWOOQ0Meg6wZ
nPK/QXX2LpCHaoe0AG/XNEAypzSgkVmU8hAaAuTPO2+Jv09+eK1Nlhda/e2JsCoV
YsNauZFqFnahbADpkv4pl1qm0D/NBEYKVxQvGqggaskVcGoj/MsWxiNRsoIdZchP
9Csdope9vJa1kE9265jnaUURcr1SznrLdU6TF9BVM2yK7PpR1XP5d0A5IsJigftT
O+SOiZBhSE9fu9IKN0yopa6nMiV6OK+0RPKEhROKBHv0g1MjWTdYQmgUmbPAxJyq
N3NSUZsnF9UYsFOHhfbeb8ScZFf2nuUeytI5OFf0Do8mJOqfAOLlgao1bZ4WH23r
+4OYCLeXD3uFHXSA69XmfUEeEEQHC8JNsQSrnb26ACeUZPp2B3mFDxUav6gAD7bm
gfblreyH+gSstQH8H0newYd4IAsXEhHcB6duNJEhRA1SQKOqGH079ejbOALEOJTp
1rogbOzjxldZsnJHU5ZG3ht2y0J099gzHt8gOwYwvQyMUUB+uHLYNxZjSS/ra0RH
TtSJZCHG8iiL2126N9mW
=WkDm
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Aug_2013_17_59_32_+1000_+pQ.1qqPSxuDjH7Q--
