Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab3KYWI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:08:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51781 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab3KYWIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:08:20 -0500
Date: Mon, 25 Nov 2013 16:07:49 -0600
From: Felipe Balbi <balbi@ti.com>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
CC: <linux-omap@vger.kernel.org>, <linaro-networking@linaro.org>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 15/23] usb: musb: raw read and write endian fix
Message-ID: <20131125220749.GA18046@saruman.home>
Reply-To: <balbi@ti.com>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
 <1384560086-11994-16-git-send-email-taras.kondratiuk@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lS0Z/zpizLfakKcP"
Content-Disposition: inline
In-Reply-To: <1384560086-11994-16-git-send-email-taras.kondratiuk@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lS0Z/zpizLfakKcP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 16, 2013 at 02:01:18AM +0200, Taras Kondratiuk wrote:
> From: Victor Kamensky <victor.kamensky@linaro.org>
>=20
> All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
> Need to use endian neutral functions to read/write h/w registers.
> I.e instead of __raw_read[lw] and __raw_write[lw] functions code
> need to use read[lw]_relaxed and write[lw]_relaxed functions.
> If the first simply reads/writes register, the second will byteswap
> it if host operates in BE mode.
>=20
> Changes are trivial sed like replacement of __raw_xxx functions
> with xxx_relaxed variant.
>=20
> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> ---
>  drivers/usb/musb/musb_io.h |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/usb/musb/musb_io.h b/drivers/usb/musb/musb_io.h
> index eebeed7..76f4d2a 100644
> --- a/drivers/usb/musb/musb_io.h
> +++ b/drivers/usb/musb/musb_io.h
> @@ -42,17 +42,17 @@
>  /* NOTE:  these offsets are all in bytes */
> =20
>  static inline u16 musb_readw(const void __iomem *addr, unsigned offset)
> -	{ return __raw_readw(addr + offset); }
> +	{ return readw_relaxed(addr + offset); }

x86 doesn't provide any of the write?_relaxed methods so this breaks
build on x86 at least.

--=20
balbi

--lS0Z/zpizLfakKcP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSk8o1AAoJEIaOsuA1yqREfYYP/iW8R8v9WJ9qkdGNyyy6ASPP
6Bmm6rlHn8WB1UBgIkwoCNwJmL4slsFKYABTXLitb1lVfMHYRS5MdfUBrhRqWzMW
rWHV+BUafKt7rXGlA4aYH91PCBkOE2OTsJA/oAoNLd3rNszck/WbpESkWhJLCrq8
g93B4fuojy5xaudyw9ZKaJEdSjBnnd1DyUGJwvDFPL0iSRVB5YBxK7q2NhXIkq/M
4uiMfWyKcxaWypFXkhloBk2HvyK1kSAniXqKWacKI89LqpyazxCfqi2uZye/rH+9
rYBvfq8B2MMQELtdaa4FvWBMLK8WKKn3aYHIMP4db6yUCx0WK13ZHC9Va30fhm36
EFfe31t5Q3e/4gLpMo0vfuT4slyXJ2c9lYmnz/WhhGxsoAcMOPj+lFpgh4YAAUYN
HOn1GvxAcfQz3g7Nj1RQqgD/IVkoNaewG683CFH46yhP5CjF5EYcaan4b3vQLhSw
hrnVBt5vJWQBM+aN+8R3RiGDTomDNdnpC5V1i7BFWUe3Wf1zY9sUDA1Z6x4jJK1b
EYKXfiur2ipfGmBjtfY1EpuAsnhc/NDAYItPJLheVds7CMis3oGw+I8vzlj9J0TK
fSaYXYvGWASTSkmSpMJ7g5G8PSa6g9hV/8S9bNroCoQItG6tqVDHCWSYkycxQcro
UQ8+DWSdDb5ZSg30IzE4
=TKwl
-----END PGP SIGNATURE-----

--lS0Z/zpizLfakKcP--
