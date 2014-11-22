Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaKVBHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 20:07:18 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57800 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbaKVBHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 20:07:16 -0500
Date: Fri, 21 Nov 2014 19:07:28 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
CC: <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2 3/4] i2c: omap: don't reset controller if Arbitration
 Lost detected
Message-ID: <20141122010728.GB26751@saruman>
Reply-To: <balbi@ti.com>
References: <1416518925-20679-4-git-send-email-al.kochet@gmail.com>
 <1416610307-3698-1-git-send-email-al.kochet@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <1416610307-3698-1-git-send-email-al.kochet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 22, 2014 at 02:51:47AM +0400, Alexander Kochetkov wrote:
> Arbitration Lost is an expected situation in a multimaster
> environment. I2C controller (IP) correctly detect and report AL.
>=20
> The only one visible reason for reseting IP in the AL case is
> to avoid advisory 1.94 (omap3) and errata i595 (omap4): "I2C:
> After an Arbitration is Lost the Module Incorrectly Starts
> the Next Transfer".
>=20
> Errata workaround states: "The MST and STT bits inside I2C_CON
> should be set to 1 at the same moment (avoid setting the MST bit
> to 1 while STT =3D 0)." The driver never set MST and STT bits
> separately and doesn't create condition for errata. So the reset
> is not necessary.
>=20
> Also corrected return value for AL to -EAGAIN.
>=20
> Tested on Beagleboard XM C.
>=20
> Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>

you could have kept my tested-by and reviewed-by:

Tested-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>


> On 21.10.2014 21:11, Wolfram Sang <wsa@the-dreams.de> wrote:
> > The errno for AL is -EAGAIN. Curly braces are not needed.
>=20
> Thank you, Wolfram, fixed.
>=20
>  drivers/i2c/busses/i2c-omap.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index 3ffb9c0..02da567 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -707,13 +707,15 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *ad=
ap,
>  		return 0;
> =20
>  	/* We have an error */
> -	if (dev->cmd_err & (OMAP_I2C_STAT_AL | OMAP_I2C_STAT_ROVR |
> -			    OMAP_I2C_STAT_XUDF)) {
> +	if (dev->cmd_err & (OMAP_I2C_STAT_ROVR | OMAP_I2C_STAT_XUDF)) {
>  		omap_i2c_reset(dev);
>  		__omap_i2c_init(dev);
>  		return -EIO;
>  	}
> =20
> +	if (dev->cmd_err & OMAP_I2C_STAT_AL)
> +		return -EAGAIN;
> +
>  	if (dev->cmd_err & OMAP_I2C_STAT_NACK) {
>  		if (msg->flags & I2C_M_IGNORE_NAK)
>  			return 0;
> --=20
> 1.7.9.5
>=20

--=20
balbi

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUb+HQAAoJEIaOsuA1yqRE6kgP/1IadpV93TFytmxBhHWhz89L
BU2OdhZhRWm6P9EBOCQ4G8P+3yC773kiXCLmuV7wK1XgSZmQyBaCMQBLXnCvHIUZ
XA37Do34V2wSgTrEF/bacWfgNBqCPoqNKI37HYWT5Wv9bf0JectVFUvmwuLVG0tF
nKZYiPhS1RsWm9mj3fkf8K2ZqNm25n/DQ1QfsfZDiY/VMzsK5nG2mOO7dOeklOzD
TK1AVHWJ0swMo5ZBC/0Hq3SoLJ93t3eaQMh8PN7vFmv7K2Rs6rYKBwuYfumtDVL7
uTN6BuPYK07uIJeHFxgjqrpu0RoqQJaq5ya9+MFxBFm0ZBZZ4wK1oFJbNoloxZEX
qu1uWv4PQh1iEJ1GonMDqMgVpx0Pbv86bItEljCUSbDJ1M+CQwmHlqjzlRf0jS+L
5oev0fIWd2LncPE0k1Hd7jGRv8wZmsSVNc/tibstqgTM8A60XmUWLAwBkb0fTTTJ
D6deaoKEUbfQn5LGq6I5djlp4xMaJ9t7J1PmM5sWZLyQehyXyVXWMhAqVMgHya4L
EQCGXwLvQpqU/GjwbyJSzpqS9V2GlzdzMmhxhjfJoX4lB+abObplka9436v7+NY/
El+Fyg3wEy0aeOBSmfQ3bwwgImRw41bdaXX3YCniqz4hwUi8Y0w3Yg/Eew4A+aAV
rdbyUZKHKc0eE+WRp1kR
=ZnN9
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--
