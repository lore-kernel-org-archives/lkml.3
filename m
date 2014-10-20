Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaJTMJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:09:52 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:62558 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaJTMIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:08:49 -0400
Date: Mon, 20 Oct 2014 08:10:41 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Yao Dongdong <yaodongdong@huawei.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Thermal:Remove usless if(!result) before return tz
Message-ID: <20141020121039.GA3688@developer>
References: <5444C78F.10404@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <5444C78F.10404@huawei.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Yao

On Mon, Oct 20, 2014 at 04:27:59PM +0800, Yao Dongdong wrote:
> result is always zero when comes here.
>=20
> Signed-off-by:yaodongdong@huawei.com
>=20
> ---
>  drivers/thermal/thermal_core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_cor=
e.c
> index 5b7d466..19cac8e 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1568,8 +1568,7 @@ struct thermal_zone_device *thermal_zone_device_reg=
ister(const char *type,
>=20
>     thermal_zone_device_update(tz);
>=20
> -   if (!result)
> -       return tz;
> +   return tz;
>=20

Adding a return here will make the resource release below not reachable
in the fail path.

>  unregister:
>     release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
> --
> 1.8.0.1
>=20
>=20

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJURPu0AAoJEMLUO4d9pOJW6ZUH/1InnDyjdzHIQgo0t6FeY4G9
pC0kdMpkqLw3RRf54T4nphqPXH2OR3DISBr5z7jGoBx9rb976Nr45ewYlVdRoeyR
8RnuMSsczGIU/k+H/7vmzskQF/lfJKl7y9IWbLzpKzMGWUuPI4E+uchhErS22Jl3
cp3mG5IyCsgADyT3Y9/5YzWAoXUGo+BSVSLGQydwygdWZSGwLuth3VMAG3pp8b9+
cuNgkShkKhnZz/7nDhrr1qpEQzZGaAEcA9pwucXZ7Tv8eENNoZU9x1f6hi1P9c48
a6OoM3d8GqEBJIdsYelxJ5Jmlul4J2TkrxAuxWKkK27VDPpY3pV3oCnMWSW3wCc=
=MFf3
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
