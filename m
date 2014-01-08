Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbaAHNhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:37:51 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53708 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252AbaAHNht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:37:49 -0500
Message-ID: <52CD54A3.7040705@ti.com>
Date: Wed, 8 Jan 2014 15:37:39 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: <linux-fbdev@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: mx3fb: Allow blocking during framebuffer allocation
References: <1387441388-10962-1-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1387441388-10962-1-git-send-email-s.hauer@pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="qQ7gbUbbDuniRh91WCIe7uWmHLHrDOjcn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qQ7gbUbbDuniRh91WCIe7uWmHLHrDOjcn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-12-19 10:23, Sascha Hauer wrote:
> No need to allocate the framebuffer from the atomic pool, we are not
> in interrupt context. Adding GFP_KERNEL to the framebuffer allocation
> allows to use the much bigger CMA pool to allocate the framebuffer.
>=20
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: linux-fbdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/video/mx3fb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
> index cfdb380..c882bec 100644
> --- a/drivers/video/mx3fb.c
> +++ b/drivers/video/mx3fb.c
> @@ -1263,7 +1263,7 @@ static int mx3fb_map_video_memory(struct fb_info =
*fbi, unsigned int mem_len,
> =20
>  	fbi->screen_base =3D dma_alloc_writecombine(fbi->device,
>  						  mem_len,
> -						  &addr, GFP_DMA);
> +						  &addr, GFP_DMA | GFP_KERNEL);
> =20
>  	if (!fbi->screen_base) {
>  		dev_err(fbi->device, "Cannot allocate %u bytes framebuffer memory\n"=
,
>=20

Thanks, queued for 3.14.

 Tomi



--qQ7gbUbbDuniRh91WCIe7uWmHLHrDOjcn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSzVSjAAoJEPo9qoy8lh7187IP/j19e9sgzQRVq7Y3EqdTEMN8
8JIOu57BN/oMVw4QZNqHU1R0pcMb+qgGU8eUCD5n9USm4s0wFm92cJKiT5AwNiR2
FPaTJq2T3sGqTz4/LrX+15B/LBWwsn9+vX3kqRX5pvKtxKBn+oUmn3T61mR7sX0N
n9qsxMm9TFG+DTMNDmWpnqBNgR1TpDiewpWC4eZSQEZMn7iXThr7OCucMdES0wdq
UMcWo61R8SWlfMOm4jBs89G+XAVlHGFdouZlpVpsHn9RmoQMXv2/Y01DUt1G2GY+
eraMjAOPMUoUY4yS5I5ak/0vJ/FV3eQ6PyNAouAkYR68QNMucPdWIo/WHtqC0F2I
3OS5aZFLOWeV9Em6oRueAZEfr42Fp8pJ/GPlIOFoHqyxc9zY5IypkkzKN+BBWf07
Ut/U0jG6fIBDftmZHbhdY7dLnAYoAphBa7G7Z/K7taDBDBswxjg/B5b/DL31Jxs+
C39pnzDafK4GUBRBnTpaCbd8ToNR8G9PDDLmveJgOzXQGFaDJ+4uFmYdu2qzCHWx
4TQCMDPehqkW8l1oYk/4/x2XlUKYH4go9dvpgoCqSvqOfuleTVGSbMo8iVyRwVlu
+Voq1ovQeFJcdYx+YJ5wk/YS+iK5NEOnKWfkLlwCDBOYsVJLS1mbJw4YYMrqwJWf
qw8e9xos3WuRJqPHmPvh
=JhME
-----END PGP SIGNATURE-----

--qQ7gbUbbDuniRh91WCIe7uWmHLHrDOjcn--
