Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab3CPCKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 22:10:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45406 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932104Ab3CPCKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 22:10:36 -0400
Message-ID: <1363399822.3937.161.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 04/21] target/pscsi: Fix page increment
From: Ben Hutchings <ben@decadent.org.uk>
To: Asias He <asias@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 16 Mar 2013 02:10:22 +0000
In-Reply-To: <20130312223245.664885170@linuxfoundation.org>
References: <20130312223245.109098379@linuxfoundation.org>
	 <20130312223245.664885170@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-eCm0M3iZwbbfe6PD3oX3"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eCm0M3iZwbbfe6PD3oX3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-12 at 15:44 -0700, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Asias He <asias@redhat.com>
>=20
> commit 472b72f2db7831d7dbe22ffdff4adee3bd49b05d upstream.
>=20
> The page++ is wrong. It makes bio_add_pc_page() pointing to a wrong page
> address if the 'while (len > 0 && data_len > 0) { ... }' loop is
> executed more than one once.
>=20
> Signed-off-by: Asias He <asias@redhat.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  drivers/target/target_core_pscsi.c |    1 -
>  1 file changed, 1 deletion(-)
>=20
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -1210,7 +1210,6 @@ static int __pscsi_map_task_SG(
>  				bio =3D NULL;
>  			}
> =20
> -			page++;
>  			len -=3D bytes;
>  			data_len -=3D bytes;
>  			off =3D 0;

So in case a fragment crosses a page boundary, we wrap around to the
beginning of the same page?  That doesn't look right.

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-eCm0M3iZwbbfe6PD3oX3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUPUjue/yOyVhhEJAQqtrA//a4o7qU5/dbCX9NpgxpEeKyfyr4FdJyVp
AH3+QXPHrXodv5Aa/tr6B/FWogRIR9vg4Bm4rAboBMBO5exuSx2x3SJT25o5Olmm
HXP7pXJilPH6ylFO3AXH2snOrdeQhrhACuzc/ezprEJt68xgtdR7D94fIxqfPWwZ
ZiSeXiLB1D4G6dJXrvR/CwV3NsaOaTJt5mYF+jNf5lwgA4L1wNiOm4Vm/w7lf+Mj
Jogu5zJo2vbCvGjeWCeVOjPfBnqUMjqAL2eUYOvquUPtq+JY15dwrrxcE65pNdi9
lI8pMAXMbSv4GIy7HnMRbUjboiqOMFfUOZB0z9e7FqexINUDrk6DE0rLCnnJdN/B
lvG8pqxNLVo1kMfIX0qKwqoYXo8GHyREcVTo6+bT6juLOSIJzHocb6ob17urCKEK
xpDHgdSdEBi0+xcpc8V9devXBFzqPEzovXY+GGdZ+WJgWsqPMsZMfeodVni2iFb9
2vc7u/XscORSXsDGj3zTot/23ZwQidBFbbD0mk7sZ6Y9nBZtI1983LGNF/ZQ5q48
wJmCKQIAWGSGS52YdgR9xJZM30L9uR6B/wlDSzSSTu9B88J67+b0lj6AqrarfdFA
ZapRS7qQRL5Kwejgl/dXf8SgYPvUs23bhz3nTV5MA2fvxMPG75ozNtSilcOLEBhl
XGxkYi58xZM=
=on2g
-----END PGP SIGNATURE-----

--=-eCm0M3iZwbbfe6PD3oX3--
