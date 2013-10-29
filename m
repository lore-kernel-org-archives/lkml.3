Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3J2K43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:56:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58505 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab3J2K41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:56:27 -0400
Message-ID: <526F9455.7070103@ti.com>
Date: Tue, 29 Oct 2013 12:56:21 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] framebuffer: Add fb_<level> convenience logging macros
References: <0926c7a34ac51c4cbb67debd0d883f41891e75d9.1379640011.git.joe@perches.com>
In-Reply-To: <0926c7a34ac51c4cbb67debd0d883f41891e75d9.1379640011.git.joe@perches.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="jaaaffjqUprTnRBq6W75XFthipxtdBRII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jaaaffjqUprTnRBq6W75XFthipxtdBRII
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 20/09/13 04:35, Joe Perches wrote:
> Add fb_<level> convenience macros for emitting the
> "fb%d: ", struct fb_info->node value.
>=20
> Neatens and shortens the code a bit.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  include/linux/fb.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>=20
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index ffac70a..70c4836 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -792,4 +792,16 @@ extern int fb_find_mode(struct fb_var_screeninfo *=
var,
>  			const struct fb_videomode *default_mode,
>  			unsigned int default_bpp);
> =20
> +/* Convenience logging macros */
> +#define fb_err(fb_info, fmt, ...)					\
> +	pr_err("fb%d: " fmt, (fb_info)->node, ##__VA_ARGS__)
> +#define fb_notice(info, fmt, ...)					\
> +	pr_notice("fb%d: " fmt, (fb_info)->node, ##__VA_ARGS__)
> +#define fb_warn(fb_info, fmt, ...)					\
> +	pr_warn("fb%d: " fmt, (fb_info)->node, ##__VA_ARGS__)
> +#define fb_info(fb_info, fmt, ...)					\
> +	pr_info("fb%d: " fmt, (fb_info)->node, ##__VA_ARGS__)
> +#define fb_dbg(fb_info, fmt, ...)					\
> +	pr_debug("fb%d: " fmt, (fb_info)->node, ##__VA_ARGS__)
> +
>  #endif /* _LINUX_FB_H */
>=20

Thanks, queued this and the next one for 3.13.

 Tomi



--jaaaffjqUprTnRBq6W75XFthipxtdBRII
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSb5RVAAoJEPo9qoy8lh71I1kP+wVWswxZmLhG5b1Lm6RjH5Zp
b3CKmlV9McimKHC6zNZ2PpL0/ZyiD12dsfKZrxdVrDxXBdfCjOCRGST6VGLZ39Q5
IRvM3+FzRpbuKW5tiYCERvYYhbv9sgW7AXHXfbb+zoaOgtijBtHZ8/JYEOaaqctV
Wg8jqDhOhlDcJzrghOLwfmvxdE5AZujFeyVlNoPK/dkUF0LBZPdTHoZ5+39GYZqZ
viwORZwmUibApdnYoCE7L3SDiM0q4c6DsPkFcuedUM9+woN2C6vElk4QzxtRNM5u
P2CA4sy6ZghjaihYZBIir5s8vqFmiup5ZNiNI59S9JJQmjoYjBbU7C5UMGhVeOX5
xMAkcbaULzrQJFOt6cI1kp3U8eiraZiktKFIRp0JEsZrop/qbQ3jhFFYcsDL5xHO
JOMuHR4tAUHwU+5sIigl0tT7jfCgrqRGys/EmE/AdmDjUjqEH3anOZUvgiQwjFUD
Xx/zrUezrWlXnTUXDu3EJnbvgcg8Q5Z+RN/LfbXLE9BFoyO8p3sCnsxyDFK9MDdo
wQU6niqzZExLaXGOjKnHeab9t+yJF2PQS+aIuep00wqhaLAoAD3LN1x+XjR90D5w
0JHxPlhJ4ptTYfgYb1KwMBaM94IH0hfqXenuTNbb+bJNFSwkzH2NrtSMmM3eHODS
IxV4eICyBEjHGSndYGDx
=aKhs
-----END PGP SIGNATURE-----

--jaaaffjqUprTnRBq6W75XFthipxtdBRII--
