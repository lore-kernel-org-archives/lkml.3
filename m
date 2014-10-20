Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaJTMbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:31:53 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:44201 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaJTMbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:31:47 -0400
Date: Mon, 20 Oct 2014 08:33:40 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Yao Dongdong <yaodongdong@huawei.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Thermal:Fix memory leak if occur goto unregister
Message-ID: <20141020123338.GA3744@developer>
References: <5444C778.8050008@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <5444C778.8050008@huawei.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, Oct 20, 2014 at 04:27:36PM +0800, Yao Dongdong wrote:
> Signed-off-by:yaodongdong@huawei.com

Acked-by: Eduardo Valentin <edubezval@gmail.com>

Rui, would you take care of this?

>=20
> ---
>  drivers/thermal/thermal_core.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_cor=
e.c
> index 71b0ec0..5b7d466 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1574,6 +1574,7 @@ struct thermal_zone_device *thermal_zone_device_reg=
ister(const char *type,
>  unregister:
>     release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
>     device_unregister(&tz->device);
> +   kfree(tz);
>     return ERR_PTR(result);
>  }
>  EXPORT_SYMBOL_GPL(thermal_zone_device_register);
> --
> 1.8.0.1
>=20
>=20

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJURQEZAAoJEMLUO4d9pOJWfwUH/3Jqlq/1LbkxaNWIEeemChAP
gDY3W78tFCsBHOzcNYsmlfxGhM/DZTxg86OuKW4Xs0ySvnyKJRmA++4Ztl6CRhSK
FsGlw6b7msH9ZKCIQ5ejuePMoOIz5G3lqBbNHANbwb/EOnx3gIKbGX/8GZLrmJ3B
UMMUb0Xj8/f5mqZfwBv/BKbwWccHnt0gkyYSLMgVxdT70+0gfFzzdHb+m3S+m8pB
UbiU10Ni0lnbGoRFXNM9+Iey6lpTn/HTt9MzG7KoSM2zR5lALuTjxdqW8mdEw6lg
Dnpko7Y0mXqaAsMtCKAskkdlRFBJgqBUHv3x1cESuNpZXYjBDCSimuNtDqHZ9DE=
=CUr9
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
