Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaCFJcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:32:11 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44089 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbaCFJcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:32:02 -0500
Message-ID: <5318408B.5060008@ti.com>
Date: Thu, 6 Mar 2014 11:31:55 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>
CC: <plagnioj@jcrosoft.com>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <fengguang.wu@intel.com>
Subject: Re: [PATCH] video: fbdev: uvesafb: Remove redundant NULL check in
 uvesafb_remove
References: <20140305155418.GA32106@udknight>
In-Reply-To: <20140305155418.GA32106@udknight>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="ArhphSkR9HshWXe3UhRxH07fVj8mxJBVS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ArhphSkR9HshWXe3UhRxH07fVj8mxJBVS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/03/14 17:54, Wang YanQing wrote:
> Because uvesafb_par is allocated as part of fb_info in uvesafb_probe,
> so we don't need to do NULL check for both fb_info and uvesafb_par in
> uvesafb_remove.
>=20
> [ This patch also fix a warning report by fengguang.wu@intel.com
>   "drivers/video/fbdev/uvesafb.c:1815 uvesafb_remove()
>    warn: variable dereferenced before check 'par'" ]
>=20
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  drivers/video/fbdev/uvesafb.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/uvesafb.c b/drivers/video/fbdev/uvesaf=
b.c
> index 1f38445..18352b2 100644
> --- a/drivers/video/fbdev/uvesafb.c
> +++ b/drivers/video/fbdev/uvesafb.c
> @@ -1812,11 +1812,9 @@ static int uvesafb_remove(struct platform_device=
 *dev)
>  		fb_destroy_modedb(info->monspecs.modedb);
>  		fb_dealloc_cmap(&info->cmap);
> =20
> -		if (par) {
> -			kfree(par->vbe_modes);
> -			kfree(par->vbe_state_orig);
> -			kfree(par->vbe_state_saved);
> -		}
> +		kfree(par->vbe_modes);
> +		kfree(par->vbe_state_orig);
> +		kfree(par->vbe_state_saved);
> =20
>  		framebuffer_release(info);
>  	}
>=20

Thanks, queuing for 3.15.

 Tomi



--ArhphSkR9HshWXe3UhRxH07fVj8mxJBVS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTGECLAAoJEPo9qoy8lh71qWMP/jMeWcJ+lkCR7fUTh7QZRyYA
ncegUkI2h0+fM3woDhkojeWKWLHMK1DNGd33Pk0YiPmaTXBFS95aIcFtNY0TWOyg
EGTmjRntPvw/KeiWbxlVhrcK2dZiC6P2Xfyou9CL2pRW90y2VpNw6kNGws0NKT+b
MMYI/OeDYaOO4xHoOCevJ0T2zONDFHyPWDMMLmYx1wJJiTW3UQBsAiyszvAgRmAH
V3T63FlEF9rocUVZdQ2Va8vi91zl7jxZ2z2cKSaBv+6qb+YE4NQZyvfBYVhaBnAf
InARxz4o9dNyNjErUYZ5VuM1qqfz0VWs80gjszFIK4Pugop9pmG1YQkFsA2iLBoU
wZYH1dG3vwtvck4k9+81nIUtdNhl54DHI9WCDsUKRAu+OVja4L86ZOGsEtr6nXnF
9vzGFB0mD7rZI/cv/GkJGRCOQdRwEk5OcIR2q8GCOfdRxDSWATkXTxfI8vsV/lvh
kyLTynVhbzdx9S9BLo78AcKg/ids1YFOYswaFFt9sew1V5kfJdYfoqQ8tz41AIX3
0L61CGKEsAKIH57F28CzJfieRqDm6P675iag1nFFk6l6b6XBqncz9sU1JF1Crg1C
FmbGQcY9yk26E4g3N9lusk3Xzc2AJuqOrtbh/ztz3m/HGDCQtLjhXGd4KCRGuvkt
COFUTCGugNASYRVuGxx4
=zre0
-----END PGP SIGNATURE-----

--ArhphSkR9HshWXe3UhRxH07fVj8mxJBVS--
