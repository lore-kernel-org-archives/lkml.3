Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab3FGTIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:08:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51309 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab3FGTIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:08:09 -0400
Date: Fri, 7 Jun 2013 22:07:02 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 4/5] i2c: omap: query STP always when NACK is received
Message-ID: <20130607190701.GE15295@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com>
 <1370630768-4077-5-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Content-Disposition: inline
In-Reply-To: <1370630768-4077-5-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 07, 2013 at 09:46:07PM +0300, Grygorii Strashko wrote:
> According to I2C specification the NACK should be handled as folowing:
> "When SDA remains HIGH during this ninth clock pulse, this is defined as =
the Not
> Acknowledge signal. The master can then gene rate either a STOP condition=
 to
> abort the transfer, or a repeated START condition to start a new transfer=
=2E"

right ...

> [http://www.nxp.com/documents/user_manual/UM10204.pdf]
>=20
> The same is recomened by TI I2C wiki:
>  http://processors.wiki.ti.com/index.php/I2C_Tips
>=20
> Currently, the OMAP I2C driver interrupts I2C trunsfer in case of NACK, b=
ut
> It queries Stop condition OMAP_I2C_CON_REG.STP=3D1 only if NACK has been =
received
> during the last message transmitting/recieving.
> This may lead to stuck Bus in "Bus Busy" until I2C IP reset (idle/enable).
>=20
> Hence, fix it by querying Stop condition (STP) always when NACK is receiv=
ed.
>=20
> CC: Kevin Hilman <khilman@linaro.org>
> CC: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/i2c/busses/i2c-omap.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index 46fb8a5..b3daf3f 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -618,11 +618,10 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *ad=
ap,
>  	if (dev->cmd_err & OMAP_I2C_STAT_NACK) {
>  		if (msg->flags & I2C_M_IGNORE_NAK)
>  			return 0;
> -		if (stop) {
> -			w =3D omap_i2c_read_reg(dev, OMAP_I2C_CON_REG);
> -			w |=3D OMAP_I2C_CON_STP;
> -			omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, w);
> -		}
> +
> +		w =3D omap_i2c_read_reg(dev, OMAP_I2C_CON_REG);
> +		w |=3D OMAP_I2C_CON_STP;
> +		omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, w);

=2E.. and this is breaking repeated start.

--=20
balbi

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRsi9VAAoJEIaOsuA1yqREl6cQAKqx4iTs7BFL8grVwwkjyDoW
3Lnj50yS2kWetgywWi0OQ2EZpMJLrHBxUR4ho6soKRPYJmj85rAA4Wb86FLOEf7F
LewUmWr42XPMZdwc2S1hNHXhZw5vsJMRIbxnLfKtylIoq8Da0wZgnBx8ykg2RKJH
g5hG3JrYpHXAeiqIjmTFNJtTUUL/Vy4tqMpg0Kf+lWeUFNss06rYLnn6iD3XpYSg
MU2/qjMBHlUkvMeDUrA3UN8dec/qftrazTpmOAxjeOoQeyS+IsnM6B8iGhu9/jvJ
jKnJ5B760B6PgJ7mrBhKEyA6kzS2xn/6MntO4vC2INavZJXEV3zYJOdNo+1RI0cw
sTMwXzryrXB6KPkU216qVlTSMizjVxZ9Ecs+blH85XyjrGdINpecew+wfShR8AoK
f6hgLWkvo+YO91qAVS/LeDYt1R2FODlsIZflUgEDPbl3iL58lOseWUV8HaDdt7QI
3XBOE9lm8k1pPQbilmce3vVRHVBa0bAy+Z3KGEgsE1NHFqIt33ZB7WtUBr2hZrFS
gO3ZlVS/h4XbupxUpC0vBhQAJOo1zhSCVw4a4ULEmSxejBfSPSIiRRKgtmaq213N
+tqmeK1EqoLFv6eqjqixnlwan6kVxbv/PAV2WQsQ6DS8/17j4cnotVL7wUmj15Gf
I/iff4SQ1/EKUxJdxsMv
=oEY1
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--
