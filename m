Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761961Ab3DBKNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:13:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48136 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761943Ab3DBKNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:13:44 -0400
Message-ID: <515AAF50.9010504@ti.com>
Date: Tue, 2 Apr 2013 13:13:36 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrei Epure <epure.andrei@gmail.com>
CC: <FlorianSchandinat@gmx.de>, <archit@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: omap2: dss: use PTR_RET function
References: <1364416537-25367-1-git-send-email-epure.andrei@gmail.com>
In-Reply-To: <1364416537-25367-1-git-send-email-epure.andrei@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigFC07AC7C235DE6BE0BECC3F8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigFC07AC7C235DE6BE0BECC3F8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 2013-03-27 22:35, Andrei Epure wrote:
> Use PTR_RET function instead of IS_ERR + PTR_ERR.
> Patch found using coccinelle.
>=20
> Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
> ---
>  drivers/video/omap2/dss/core.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>=20
> diff --git a/drivers/video/omap2/dss/core.c b/drivers/video/omap2/dss/c=
ore.c
> index f8779d4..60cc6fe 100644
> --- a/drivers/video/omap2/dss/core.c
> +++ b/drivers/video/omap2/dss/core.c
> @@ -181,10 +181,7 @@ int dss_debugfs_create_file(const char *name, void=
 (*write)(struct seq_file *))
>  	d =3D debugfs_create_file(name, S_IRUGO, dss_debugfs_dir,
>  			write, &dss_debug_fops);
> =20
> -	if (IS_ERR(d))
> -		return PTR_ERR(d);
> -
> -	return 0;
> +	return PTR_RET(d);
>  }
>  #else /* CONFIG_OMAP2_DSS_DEBUGFS */
>  static inline int dss_initialize_debugfs(void)
>=20

There's an identical patch from Alexandru Gheorghiu already queued.

 Tomi



--------------enigFC07AC7C235DE6BE0BECC3F8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRWq9QAAoJEPo9qoy8lh7119YP/098U8am6Ljox7mOGjoVC86j
puhBovr4Qmtea+FqomExIaS7zmvawpvNnrO/9AKzHGJuqHmUMIbfJFR3VxNm5gZk
iPG29BiI9K0C4h7jCzN4kxVr+waQzCVm2pJNrqtkxow0f39sII3+bv/TULyVR3iw
eVLIwVl0QaQlBNQyonUh++0DIbrsreR77Il4Zid1lA7RP+2nX1L/fCq+2eZp9j/0
TfjPx/CuRykiJJuNCrAIZIYxb4160nzBbjfQ+31YqFTJIhwSGgUQBD1zWRiO3i0K
Np0l0atAikD5h4iUalZctT0XZ+XykQFTgHtQi5FGyep7AM46NIXRmtorO/hjjmv0
/GDYFRtagnOnC8lj4kUGk5aGjRijTL8b6dHs9D+BMfYic5UxsCnFcuaSgtm0C3OE
qh3+5jHFEwOBHpRhqNRYO8HnVCdqR121guf3T8SK1GNmy6t2r8iLCTMCcNfX/StP
gSf5tB0O3RMk3Q76ZGxQgoFO1x/d7wYvxHWQnxdwuummIZokkF9GdnhQX5nWldSs
iBt772fetw8XYSlU/RvKfXY+ZhvThVS9dqS8+VQ9mC8WXf49b3wcznXLnWXusBdg
BqB6cyarWGHpr4cBPJVQnvFaYye1WDv292GpCPsU1D4qFIRoMvclxsCILLJoDa5u
of93dqQQJGtgGoqNzWF4
=cgro
-----END PGP SIGNATURE-----

--------------enigFC07AC7C235DE6BE0BECC3F8--
