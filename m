Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211AbaK0OVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:21:41 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:34553 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaK0OVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:21:39 -0500
Date: Thu, 27 Nov 2014 10:21:29 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Navneet Kumar <navneetk@nvidia.com>
Cc: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Diwakar Tundlam <dtundlam@nvidia.com>
Subject: Re: [PATCH 1/3] thermal: of: support writable trips via dt
Message-ID: <20141127142127.GB3342@developer>
References: <1417050989-25405-1-git-send-email-navneetk@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <1417050989-25405-1-git-send-email-navneetk@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Navneet

On Wed, Nov 26, 2014 at 05:16:27PM -0800, Navneet Kumar wrote:
> From: navneet kumar <navneetk@nvidia.com>
>=20
> Support writable trip points configuration from the
> device tree. 'OF' reads this configuration and adjusts
> the 'trips' mask accordingly to allow the 'set_trip_xxx'
> calls to be effective.
>=20
> Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>

Thanks for sharing your patches!

> ---
>  drivers/thermal/of-thermal.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index 62143ba31001..cf9ee3e82fee 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -604,7 +604,8 @@ static int thermal_of_get_trip_type(struct device_nod=
e *np,
>   * Return: 0 on success, proper error code otherwise
>   */
>  static int thermal_of_populate_trip(struct device_node *np,
> -				    struct __thermal_trip *trip)
> +				    struct __thermal_trip *trip,
> +				    bool *trip_writable)
>  {
>  	int prop;
>  	int ret;
> @@ -629,6 +630,8 @@ static int thermal_of_populate_trip(struct device_nod=
e *np,
>  		return ret;
>  	}
> =20
> +	*trip_writable =3D of_property_read_bool(np, "writable");

New DT properties needs to be properly discussed in device tree mainling
list. From what I see here, this property does not describe hardware,
does it?=20

A simple git grep writable Documentation/devicetree/bindings/
returns nothing. So, I am a bit skeptic having this property is
allowable.

In any case, can you please send your proposal also copying device tree mai=
ling list?
devicetree@vger.kernel.org

Besides, you need to document this new property:
Documentation/devicetree/bindings/thermal/thermal.txt=20


All the best,

Eduardo Valentin

> +
>  	/* Required for cooling map matching */
>  	trip->np =3D np;
>  	of_node_get(np);
> @@ -657,6 +660,8 @@ thermal_of_build_thermal_zone(struct device_node *np)
>  	struct __thermal_zone *tz;
>  	int ret, i;
>  	u32 prop;
> +	bool trip_writable;
> +	u64 m =3D 0;
> =20
>  	if (!np) {
>  		pr_err("no thermal zone np\n");
> @@ -700,9 +705,14 @@ thermal_of_build_thermal_zone(struct device_node *np)
> =20
>  	i =3D 0;
>  	for_each_child_of_node(child, gchild) {
> -		ret =3D thermal_of_populate_trip(gchild, &tz->trips[i++]);
> +		trip_writable =3D false;
> +		ret =3D thermal_of_populate_trip(gchild, &tz->trips[i],
> +					       &trip_writable);
>  		if (ret)
>  			goto free_trips;
> +		if (trip_writable)
> +			m |=3D 1ULL << i;
> +		i++;
>  	}
> =20
>  	of_node_put(child);
> --=20
> 1.8.1.5
>=20

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdzNeAAoJEMLUO4d9pOJWCGQIAIpJSIucsTCXJraPUVr/UqbS
wIUsZNRC8zMe5mMLqcLedj9mt7ATKo95osIr1IXLdrHQxCAvbxgbGP0gpwqDTe5U
eOt/6xSXDv7ZJgvEwWxJ7IrxrsycRVTx2+IZaiYT6atfxLyG9FWPMH9QznWOj/o6
PPMl5pk/RKl9uEvItWrd426aXHZ+PAT4Kjz8iU/R6fOwU7U7Hl9lUbP68T4oE29O
iHXZKWHj1vrKuHiixSghkJ4GcWBGu52PC2m/U5WM9MlV3TCqDSBNOg5vl70Iw7+X
WW0K0m3TAf37VJWZ8F/ZjeQmYMjOLxmW1vLh3iXqd2Rvgb2WB0KsqaK7xaU/Hi0=
=VbsH
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
