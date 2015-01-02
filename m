Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbbABPxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:53:12 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:60263 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbABPxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:53:08 -0500
Date: Fri, 2 Jan 2015 11:53:00 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        punit.agrawal@arm.com, broonie@kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v6 9/9] of: thermal: Introduce sustainable power for
 a thermal zone
Message-ID: <20150102155256.GD10683@developer>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
 <1417806260-9264-10-git-send-email-javi.merino@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pZs/OQEoSSbxGlYw"
Content-Disposition: inline
In-Reply-To: <1417806260-9264-10-git-send-email-javi.merino@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pZs/OQEoSSbxGlYw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 05, 2014 at 07:04:20PM +0000, Javi Merino wrote:
> From: Punit Agrawal <punit.agrawal@arm.com>
>=20
> Introduce an optional property called, sustainable-power, which
> represents the power (in mW) which the thermal zone can safely
> dissipate.
>=20
> If provided the property is parsed and associated with the thermal
> zone via the thermal zone parameters.
>=20
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> ---
>  Documentation/devicetree/bindings/thermal/thermal.txt | 4 ++++
>  drivers/thermal/of-thermal.c                          | 4 ++++
>  2 files changed, 8 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Docu=
mentation/devicetree/bindings/thermal/thermal.txt
> index f5db6b72a36f..c6eb9a8d2aed 100644
> --- a/Documentation/devicetree/bindings/thermal/thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
> @@ -167,6 +167,10 @@ Optional property:
>  			by means of sensor ID. Additional coefficients are
>  			interpreted as constant offset.
> =20
> +- sustainable-power:	An estimate of the sustainable power (in mW) that t=
he
> +  Type: unsigned	thermal zone can dissipate.
> +  Size: one cell
> +

Please, include examples of this property, as you mentioned in the
governor documentation.

>  Note: The delay properties are bound to the maximum dT/dt (temperature
>  derivative over time) in two situations for a thermal zone:
>  (i)  - when passive cooling is activated (polling-delay-passive); and
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index 62143ba31001..e032b9bf4085 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -794,6 +794,7 @@ int __init of_parse_thermal_zones(void)
>  	for_each_child_of_node(np, child) {
>  		struct thermal_zone_device *zone;
>  		struct thermal_zone_params *tzp;
> +		u32 prop;
> =20
>  		/* Check whether child is enabled or not */
>  		if (!of_device_is_available(child))
> @@ -820,6 +821,9 @@ int __init of_parse_thermal_zones(void)
>  		/* No hwmon because there might be hwmon drivers registering */
>  		tzp->no_hwmon =3D true;
> =20
> +		if (!of_property_read_u32(child, "sustainable-power", &prop))
> +			tzp->sustainable_power =3D prop;
> +
>  		zone =3D thermal_zone_device_register(child->name, tz->ntrips,
>  						    0, tz,
>  						    ops, tzp,
> --=20
> 1.9.1
>=20
>=20

--pZs/OQEoSSbxGlYw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUpr7OAAoJEMLUO4d9pOJWb0AH/1D9Mrj9sr+OYUPej2oowicf
YEvj9OZA+c2Xqv0Cfrf2vgLqB9/pTfv9o9A1lTvl7g5h5OU6RrTYlYm5z5cWwRfQ
dAOc4FPMqnyhweO6twfkKEEw48eR46hMm3wIMmicUt5g2Z64jRBXt39+AkWjquLn
wF+FWOAH9TlbDwIVEBvjDgIZjcp2ZKBc5Mp30oSa9ug7dXQobELxI2ByZMAwDIiR
gEi+J9vk3O2TUiK0j/sIpkTKS4ZwDrvOfL1XwW5IN+55oTikIMRGfMd8D9M5S8X+
UVKwQ8qhBYvizax/KF7/yEK70yIRu31sgJYPcnNv0TGGnnaIf6RxXkyVC7ourDc=
=Ux6b
-----END PGP SIGNATURE-----

--pZs/OQEoSSbxGlYw--
