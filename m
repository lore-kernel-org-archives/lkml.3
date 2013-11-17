Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3KQLJB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 06:09:01 -0500
Received: from sauhun.de ([89.238.76.85]:46775 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab3KQLIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 06:08:54 -0500
Date: Sun, 17 Nov 2013 12:08:46 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Andreas Werner <wernerandy@gmx.de>
Cc: khali@linux-fr.org, jacmet@sunsite.dk, hskinnemoen@gmail.com,
        dianders@chromium.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] I2C: busses: i2c-eg20t Do not print error message in
 syslog if no ACK received
Message-ID: <20131117110846.GA3093@katana>
References: <1384678731-10399-1-git-send-email-wernerandy@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <1384678731-10399-1-git-send-email-wernerandy@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 17, 2013 at 09:58:51AM +0100, Andreas Werner wrote:
> Revision 2:
> 	- delete the pch_err completly instead of changing to pch_dbg
> 	  because there is already a pch_dbg at the function who calls
> 	  pch_i2c_getack.
> 	- Fixed message line issue

I prefer this below "---" after Signed-off.

>=20
> diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20=
t.c
> index 0f37529..5c39f90 100644
> --- a/drivers/i2c/busses/i2c-eg20t.c
> +++ b/drivers/i2c/busses/i2c-eg20t.c
> @@ -321,10 +321,8 @@ static s32 pch_i2c_getack(struct i2c_algo_pch_data *=
adap)
>  	void __iomem *p =3D adap->pch_base_address;
>  	reg_val =3D ioread32(p + PCH_I2CSR) & PCH_GETACK;
> =20
> -	if (reg_val !=3D 0) {
> -		pch_err(adap, "return%d\n", -EPROTO);
> +	if (reg_val !=3D 0)
>  		return -EPROTO;

That could be fixed to -ENXIO according to
Documentation/i2c/fault-codes.

> @@ -367,8 +365,7 @@ static int pch_i2c_wait_for_check_xfer(struct i2c_alg=
o_pch_data *adap)
>  	adap->pch_event_flag =3D 0;
> =20
>  	if (pch_i2c_getack(adap)) {
> -		pch_dbg(adap, "Receive NACK for slave address"
> -			"setting\n");
> +		pch_dbg(adap, "Receive NACK for slave address setting\n");
>  		return -EIO;

What about returning the value we got from pch_i2c_getack?

Regards,

   Wolfram


--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSiKO+AAoJEBQN5MwUoCm2XhwP/ioZyoAz5j0SOm+8DnvKAFQc
hdEl5bAuFx7adXCtCZVEfOHhZS9V+D17bgqj6S/PWbBHepwIZu4hYLvrvl0HgeRN
59fcJpi7U0pgvi7fQCSk2OdNRX177m64kkm+xZe0D2XaA5CwdvEjOpHuamIcBUSj
sVK2RkxgZxRYq4FpltVZll3/7nd/SMPzDvXw0nn05hDKgZsyz061yH/x0zendRtH
3Vp1qUC7dT7asFwSQf+5Zo9T9xAU5iKo5ddpht/i3yhFx2BrfhlpytEHzcF38eJW
rFNky3bP81b+P/w8yKTk83N5XC3LW2a3FEle6xtF9WD9bs/MSROPECRNRJFIwgVT
XnSozvXOq/QTewJMjiRbEnFgPXtO6CQWTgfMkSrRS/m4raKOoaDDa9032UtH9Oas
oZhLP0HtPIaLYQOHMlrgJVzLzA2qHFuwj+Lgh0DSmBSrQqPHWtAEWzD4EJ5jaUVz
HTddnmM8abNGlxNGiJir1cyHyZCs0GYjaOUsI2Sy1b8eQuhG4htCqw212k0RODfW
z83WPX8bYXxxsTMJmZrDuDrBEpLylDWE3KFQ0hg4GgWvsq2RA5Jax9hWtQOmfvxO
OT2oUhFb0tv8achFcnKUUflB+5eLYDQf5HE7gVap5MEl5Et83RjuQgCRUDSm1p//
IPP4jdOMctMnp4QV0niE
=ayKs
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
