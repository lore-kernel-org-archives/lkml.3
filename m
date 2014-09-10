Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaIJEss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:48:48 -0400
Received: from ozlabs.org ([103.22.144.67]:52627 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaIJEsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:48:46 -0400
Date: Wed, 10 Sep 2014 14:48:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Romain Perier <romain.perier@gmail.com>,
        Heiko =?UTF-8?B?U3TDvGJuZXI=?= <heiko@sntech.de>
Subject: linux-next: manual merge of the net-next tree with the arm-soc tree
Message-ID: <20140910144837.5e3089e1@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/lTJg7MWLjv6szNbPy0aQ3N9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lTJg7MWLjv6szNbPy0aQ3N9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
arch/arm/boot/dts/rk3188-radxarock.dts between commit 4721ab855d1a
("ARM: dts: rockchip: add hym8563 rtc to Radxa Rock board") from the
arm-soc tree and commit c6ec956b73db ("ARM: dts: Enable emac node on
the rk3188-radxarock boards") from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/rk3188-radxarock.dts
index 2c2313ff67c6,d63d685ea6cc..000000000000
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@@ -209,12 -217,12 +225,18 @@@
  		};
  	};
 =20
 +	hym8563 {
 +		rtc_int: rtc-int {
 +			rockchip,pins =3D <RK_GPIO0 0 RK_FUNC_GPIO &pcfg_pull_up>;
 +		};
 +	};
 +
+ 	lan8720a  {
+ 		phy_int: phy-int {
+ 			rockchip,pins =3D <RK_GPIO3 26 RK_FUNC_GPIO &pcfg_pull_up>;
+ 		};
+ 	};
+=20
  	ir-receiver {
  		ir_recv_pin: ir-recv-pin {
  			rockchip,pins =3D <RK_GPIO0 10 RK_FUNC_GPIO &pcfg_pull_none>;

--Sig_/lTJg7MWLjv6szNbPy0aQ3N9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUD9grAAoJEMDTa8Ir7ZwVmv0P/3IPwA7Cgk3g9+wvGQrNr0kT
5H7eLfWgopi++a+yorbOjqD0V3O4I71o04AwTqUmc5WOTHvQOSMLQMApxko4fTy9
cW8+iXCj+VUBH3WQtq4d3vfgN1n1Grs+ca8hOnqYoh5WfK0VC0OQXiulvEzkCywb
L8y1oCfQybnxjmFLgPH1Ad4frrN0He3H5XdyfTkHsz5A87HJJKprpxlG2QlRIGiu
xXv7riC+QHhyRXjJu4Gylp0C4sPO6bm2xeZww6+DYOE+vwi63n0BdvF0RZTHAV1S
zZWPvxAnSnPTKL0NSciLafvfsIE7NrQUAc4GoAN0BRAd+SVz84rhGmA6x09qJqDJ
Qflo8D4ghd2TFDuAVGM9sW505qsnGJEcHMs8sfTdfK8JDezVHfWbgDgxYJBTJLyr
RZ+sRwuN1uXDgv2TacAYgJ0BG+3mOEE78aEUneuIeGpKtMSLRcM/Wpyy1O1Vxd9+
VQ1cRWsVRiRVxlyJuh0naUMk99TZAYUqhyBjGrSEQYA9VrBth9/AbT1c9lSpXt+t
vvVhU+hROHiX43qOGWZltXU3hE3mvzxxhxuzbefsHl7XD6nhoCzPnrCSYLz7zHje
d5N/9TPTVx/v92Oekv2FPTVZgtblURiXj6DWPVmLdUR8KRd1Qr0UTB+WRBDkuu2X
uiD0s4TVPe+lrw+ufMeq
=ujzH
-----END PGP SIGNATURE-----

--Sig_/lTJg7MWLjv6szNbPy0aQ3N9--
