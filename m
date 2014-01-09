Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaAIMWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:22:16 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43939 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbaAIMWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:22:04 -0500
Message-ID: <52CE9466.3000207@ti.com>
Date: Thu, 9 Jan 2014 14:21:58 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michal Nazarewicz <mpn@google.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] drivers: video: metronomefb: avoid out-of-bounds
 array access
References: <1385743903-9079-1-git-send-email-mpn@google.com>
In-Reply-To: <1385743903-9079-1-git-send-email-mpn@google.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="QExNdmMHqTkhJLMsRmxnvH3LdfXcokIft"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--QExNdmMHqTkhJLMsRmxnvH3LdfXcokIft
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2013-11-29 18:51, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>=20
> load_waveform function checks whether padding bytes in stuff2a
> and stuff2b are all zero, but does so by treating those arrays
> as a single longer array.  Since the structure is packed, and
> the size sum matches, it all works, but creates some confusion
> in the code.
>=20
> This commit changes the stuff2a and stuff2b arrays into pad1 and
> pad2 fields such that they cover the same bytes as the arrays
> covered, and changes the check in the load_waveform function so
> that the fields are read instead of iterating over an arary.
>=20
> It also renames the other =E2=80=9Cstuff=E2=80=9D fields to =E2=80=9Cig=
nore*=E2=80=9D fields to
> give them more semantic meaning.
>=20
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  drivers/video/metronomefb.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/video/metronomefb.c b/drivers/video/metronomefb.c
> index 195cc2d..4f36a2b 100644
> --- a/drivers/video/metronomefb.c
> +++ b/drivers/video/metronomefb.c
> @@ -126,7 +126,7 @@ static struct fb_var_screeninfo metronomefb_var =3D=
 {
> =20
>  /* the waveform structure that is coming from userspace firmware */
>  struct waveform_hdr {
> -	u8 stuff[32];
> +	u8 ignore1[32];
> =20
>  	u8 wmta[3];
>  	u8 fvsn;
> @@ -134,13 +134,14 @@ struct waveform_hdr {
>  	u8 luts;
>  	u8 mc;
>  	u8 trc;
> -	u8 stuff3;
> +	u8 ignore2;
> =20
>  	u8 endb;
>  	u8 swtb;
> -	u8 stuff2a[2];
> +	u32 pad1; /* u16 halfof(pad1) */
> =20
> -	u8 stuff2b[3];
> +	/* u16 halfof(pad1) */
> +	u8 pad2;

I don't quite follow what those comments mean...

I know nothing of the hw in question, but I guess there's some reason
the stuff2a and stuff2b has been separate, and there's even a blank line
between. If they pad a particular block in the data structure, doesn't
your change make it confusing?

It wouldn't be too pad to have those 5 fields as separate ones. One u16
for the stuff2a, and u16 + u8 for the stuff2b. It'd be simple to check
that those are zero.

 Tomi



--QExNdmMHqTkhJLMsRmxnvH3LdfXcokIft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSzpRmAAoJEPo9qoy8lh71QQ4QAIhnFfrJvBwDobmp1uVGW/y5
vceNq+pMt5MQEWlLgjxNFUS4q6q4OyITYHZqz8qgwkEWQTbay9aHOCrFM7sspc51
F+hkHEwyOdBOjGC4m8YgHgFxn19QW5mOEiS29XJyuBmgDdJQ/v1KnSqUg/82piQ0
mUzCCv7nwtR6Q13Y3y7QfrCHAmXEJFuN9kXsCz+r7UlN00WrJ1IfJjqgjZB/K7/S
LuvZmYFeGy9EuGnOE4aHJAHfaAZ1xg95qf1iPaUvE1kZQH9o/5+QMQjTohAMnTW5
tKbromuf3TzTlMGKPl1+i0GPdIQT6y+kSqEfDNYHqBdpkw+M0EAdN2+z9cHD7vlL
SMo/hD6c53qEjchROnecldrZmcMXNf6ZfUeAzkE2vfpvaH99nH9BAlQrN4a0srGa
iXizVuK/fayVzPd9RIpP3F0lObe11rk15DFVLPti5TBQJPckMNMMNFpraNxvPxML
wVF4scjqcMwFzH7/sNoyXzhniDU2FPfIk07EmmfeJG8Ow2ycy1DtQKbAu+bfnrPt
a7Hzs+W4S3jJI8hbRi2ZDRaRUiHvJNaCzTdESEBq3YJ17nuVPVorj2eoeCr0JRRJ
im3WtsUC8HBz04q0owrQKr6B9YMTb3sb72Wma8nnblAA3ounn3FNhClW16qIsTx5
XMZKhqor1cxJP2YyzWg0
=qesP
-----END PGP SIGNATURE-----

--QExNdmMHqTkhJLMsRmxnvH3LdfXcokIft--
