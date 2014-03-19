Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaCSEda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 00:33:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:10450 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbaCSEdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 00:33:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,682,1389772800"; 
   d="asc'?scan'208";a="502781744"
Message-ID: <1395203586.2050.7.camel@jtkirshe-mobl>
Subject: Re: [PATCH 2/2] INTEL-IGB: Convert iounmap to pci_iounmap
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, donald.c.skidmore@intel.com,
        gregory.v.rose@intel.com, alexander.h.duyck@intel.com,
        john.ronciak@intel.com, mitch.a.williams@intel.com,
        linux.nics@intel.com, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Tue, 18 Mar 2014 21:33:06 -0700
In-Reply-To: <1395159085-11691-2-git-send-email-peter.senna@gmail.com>
References: <1395159085-11691-1-git-send-email-peter.senna@gmail.com>
	 <1395159085-11691-2-git-send-email-peter.senna@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3zjns+ZL2TfZRMyWNk/3"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3zjns+ZL2TfZRMyWNk/3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-03-18 at 17:11 +0100, Peter Senna Tschudin wrote:
> Use pci_iounmap instead of iounmap when the virtual mapping was done
> with pci_iomap. A simplified version of the semantic patch that finds
> this
> issue is as follows: (http://coccinelle.lip6.fr/)
>    =20
> // <smpl>
> @r@
> expression addr;
> @@
> addr =3D pci_iomap(...)
>=20
> @rr@
> expression r.addr;
> @@
> * iounmap(addr)
> // </smpl>
>=20
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
>  Tested by compilation only.
>=20
>  drivers/net/ethernet/intel/igb/igb_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks Peter, I have added you patch to my queue.

--=-3zjns+ZL2TfZRMyWNk/3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABCgAGBQJTKR4CAAoJEOVv75VaS+3O2GYP/1ALxiYvn0+dv/9+AObLK5E1
20+vVgc2arJO3SBxH8ItcROvatSXnnuVGIVYDr35ogGxutye/onu+pcxvNHEyjal
0mlfBT6G5HfNrg6ahlMwf3VbB57aUgjY4SHYHU5EC+ogDKLdOhogMdNH+EN1UtCt
SEyUVfz7HWrzq/i+otW7tUCflz8mK3KFS+HhAl1y5tsGiA/z85dG9F66lm5nPt0D
NA52OBorr7auzD2lUGRF4TEPZIJs/D1ShSsTyg21IZj/JkkGWpvvVcHBp0yyXSiR
O8cKg3gMmv0dEV43DxGOPrvqRJ2T/rG7bgW4IMgIjXRj4EGHljhichpNIj5iXV3Q
9KHgp1UdPnjOJHTzy6bIYyV1mEmcWckU9MJmU9K+p58UovEtXB37YKcPWLDd1zbN
7k5tlG/C/LUIXgKyjCXuHmEpSnBGEjwGMwC1cOAWCimpTug2N4+tYDBDhtrXKSDs
qZObjAryn3521riFtAvP9CMct0JTDlnwni02Nnv5Np31RPFFumr0ZRDmVZTu/pOP
qMq5A7/OxdOripXzHIPvzlqr2qZ822n5U6Fe1nqUZ7gc1/cmnz6u4dH/fFp/mrW9
0nRlhxK0WvzQLi0xi9uaQvU/07gAI17A7wTNWfA8Vlsf+Hq6N+uSKteb3UMosEH6
G3HAHy5UB23he3G0wXka
=20Hr
-----END PGP SIGNATURE-----

--=-3zjns+ZL2TfZRMyWNk/3--

