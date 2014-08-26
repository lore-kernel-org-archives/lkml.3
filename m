Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934469AbaHZKgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:36:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54359 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934435AbaHZKgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:36:16 -0400
Message-ID: <53FC6310.9030901@ti.com>
Date: Tue, 26 Aug 2014 13:36:00 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <kernel-janitors@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 14/14] video: of: display_timing: delete unneeded test
 before of_node_put
References: <1407492475-26283-14-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1407492475-26283-14-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="jfGp2xKET0cjtqNatIt4UD9B3bxcHbElJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jfGp2xKET0cjtqNatIt4UD9B3bxcHbElJ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/08/14 13:07, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Of_node_put supports NULL as its argument, so the initial test is not
> necessary.  Furthermore, native_mode cannot be NULL at this point.
>=20
> Suggested by Uwe Kleine-K=C3=B6nig.
>=20
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @@
> expression e;
> @@
>=20
> -if (e)
>    of_node_put(e);
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> ---
>  drivers/video/of_display_timing.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/video/of_display_timing.c b/drivers/video/of_displ=
ay_timing.c
> index 987edf1..339f831 100644
> --- a/drivers/video/of_display_timing.c
> +++ b/drivers/video/of_display_timing.c
> @@ -233,8 +233,7 @@ struct display_timings *of_get_display_timings(stru=
ct device_node *np)
>  	return disp;
> =20
>  timingfail:
> -	if (native_mode)
> -		of_node_put(native_mode);
> +	of_node_put(native_mode);
>  	display_timings_release(disp);
>  entryfail:
>  	kfree(disp);
>=20

Thanks, queued for 3.18.

 Tomi



--jfGp2xKET0cjtqNatIt4UD9B3bxcHbElJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/GMQAAoJEPo9qoy8lh71L0EP/3ALKBpmcA16+jhrMFXtKWRf
iHX5X0MbjIvKCKC5soIxYeITyiKMdoE4a7tm5idn7lBkgDECyCpd3eybTzUwceSZ
T6lYEGjoHXQssjbJ9jot/ozbTbUx5iLjOxcQw38G9p6kWvfDxu70kcJpOHpHtnsA
TMvX+Tyx0dQv2fk3qv6DdNVgS8afSlbXf/wIRbhW9x8/8IGE96Tkv/e62Ok7dmVs
z2pi4Ei0nJ6Rq3G0InoDRxTCO0MwvF1QaJdaoDT9xKtPI9/G0AVXUg6eRVUVFkTQ
r1jaDw6kkxe5+rVWT1SFVSKOdB+hsf7wS8pcULVWPMFEVV6VvFAjz+UWpWY8ucME
x+pWI6SKuG8XBZpvG3X0tPmNko7U0egTetT1kKm86oEXji91NKsnqC7TZ+rypG+X
Oo1kMgldbjCgDTj2tk86nrkQNNr9VBJH4vN8hpFExiBfwtcILEhaDvltAf8VIUZT
sxJUNN4+JiXWBTCYjMTSv1iVb+/QPpLxISfW4KyPbr2kSE/a32PfFlDg2Gjo/Ifz
KixO5LNRStNmeT/DYREa19dR9j6A6fPd2X+KdWYMySGnslRyggSZ/eOx1JBHJwX3
b0nizXMrZwVIId8tiPAkg2UMymWuvs7xEddbc3LSy99pNSCCq03t22TZ8sVrWFo7
uTGjUoM/4AUP8ED0v0Qg
=i5OF
-----END PGP SIGNATURE-----

--jfGp2xKET0cjtqNatIt4UD9B3bxcHbElJ--
