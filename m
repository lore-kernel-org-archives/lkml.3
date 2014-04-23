Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbaDWP3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:29:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34506 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbaDWP3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:29:14 -0400
Date: Wed, 23 Apr 2014 10:26:23 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>, <marcel@holtmann.org>,
        <gustavo@padovan.org>, <johan.hedberg@gmail.com>, <jslaby@suse.cz>,
        <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 10/13] tty: serial: omap: remove some dead code
Message-ID: <20140423152623.GJ9593@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
 <1398265117-11793-10-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z8yxTSU1mh2gsre7"
Content-Disposition: inline
In-Reply-To: <1398265117-11793-10-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Z8yxTSU1mh2gsre7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

+Neil

On Wed, Apr 23, 2014 at 09:58:34AM -0500, Felipe Balbi wrote:
> nobody passes a DTR_gpio to this driver, so
> this code is not necessary.
>=20
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/tty/serial/omap-serial.c | 39 ----------------------------------=
-----
>  1 file changed, 39 deletions(-)
>=20
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-s=
erial.c
> index b46aaf3..6654682 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -163,10 +163,6 @@ struct uart_omap_port {
>  	u8			wakeups_enabled;
>  	u32			features;
> =20
> -	int			DTR_gpio;
> -	int			DTR_inverted;
> -	int			DTR_active;
> -
>  	struct serial_rs485	rs485;
>  	int			rts_gpio;
> =20
> @@ -694,16 +690,6 @@ static void serial_omap_set_mctrl(struct uart_port *=
port, unsigned int mctrl)
>  	serial_out(up, UART_MCR, up->mcr);
>  	pm_runtime_mark_last_busy(up->dev);
>  	pm_runtime_put_autosuspend(up->dev);
> -
> -	if (gpio_is_valid(up->DTR_gpio) &&
> -	    !!(mctrl & TIOCM_DTR) !=3D up->DTR_active) {
> -		up->DTR_active =3D !up->DTR_active;
> -		if (gpio_cansleep(up->DTR_gpio))
> -			schedule_work(&up->qos_work);
> -		else
> -			gpio_set_value(up->DTR_gpio,
> -				       up->DTR_active !=3D up->DTR_inverted);
> -	}
>  }
> =20
>  static void serial_omap_break_ctl(struct uart_port *port, int break_stat=
e)
> @@ -847,9 +833,6 @@ static void serial_omap_uart_qos_work(struct work_str=
uct *work)
>  						qos_work);
> =20
>  	pm_qos_update_request(&up->pm_qos_request, up->latency);
> -	if (gpio_is_valid(up->DTR_gpio))
> -		gpio_set_value_cansleep(up->DTR_gpio,
> -					up->DTR_active !=3D up->DTR_inverted);
>  }
> =20
>  static void
> @@ -1672,28 +1655,6 @@ static int serial_omap_probe(struct platform_devic=
e *pdev)
>  	if (IS_ERR(base))
>  		return PTR_ERR(base);
> =20
> -	if (gpio_is_valid(omap_up_info->DTR_gpio) &&
> -	    omap_up_info->DTR_present) {
> -		ret =3D devm_gpio_request(&pdev->dev, omap_up_info->DTR_gpio,
> -				"omap-serial");
> -		if (ret < 0)
> -			return ret;
> -		ret =3D gpio_direction_output(omap_up_info->DTR_gpio,
> -					    omap_up_info->DTR_inverted);
> -		if (ret < 0)
> -			return ret;
> -	}
> -
> -	if (gpio_is_valid(omap_up_info->DTR_gpio) &&
> -	    omap_up_info->DTR_present) {
> -		up->DTR_gpio =3D omap_up_info->DTR_gpio;
> -		up->DTR_inverted =3D omap_up_info->DTR_inverted;
> -	} else {
> -		up->DTR_gpio =3D -EINVAL;
> -	}
> -
> -	up->DTR_active =3D 0;
> -
>  	up->dev =3D &pdev->dev;
>  	up->port.dev =3D &pdev->dev;
>  	up->port.type =3D PORT_OMAP;
> --=20
> 1.9.2.459.g68773ac
>=20

--=20
balbi

--Z8yxTSU1mh2gsre7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTV9ufAAoJEIaOsuA1yqREPLoP/2lEWmyEexZWZdcWALzE5cAo
P0Z6opKX6Mahm5gGPcN82Rj+FiSKsSoVqorAxEtkiHPVVlhfyyuUVVGIWRc5eDlo
Mh+Zabrs6Ahg/8V9AokSlVlbTfHPcdXMHAKACfdNRbGbm8VcpMoEFm2izRefY2dm
jwJ6c+lZF2RBObkyXUVahJxDB5vVd6nIH+xOaH7LfAzfA6Xqk1hLIMD9yRKNXu2h
CCe5C7yqYi/yYulY6vlDrgbPy4xpfZpmNdGY4rMtaj/O3qSX9TrFJgKBBVkYoC/f
QlmUfVwpfEiw8Ed1tgBOvSrDH8Snfw4frtMTwod9i/CZMxf5XGQmJiU5poAv0eUc
kltcotMaXhTo3/JKzZ48sHqkJZfsIvib8GGPQ61O89lSnuoVOF8IpyMlSgh2XAsv
aEKz5J9nGJkaJkF21sPfxSeNFbh53IuvTUMSYOIeCF9Wa1y8QmptUL9Jke0wYIRd
nR+s2gpJLUpVUkqsLaZI34aD6fwCWu0RvXlwPrmZLQ2k2YfHYcVP6tgkMKDxHxiN
zMQ644xafRC7Uh/onZajfFIqyS1nsre0O6XpvhhLYgX+oKEVYZnuV1/ZoKKWR08Q
WobXmV6YHErKF2oNEsS58+56AqTAMq/hW6jz3bln2bKHbGYEcjFh3M3PJUMy99J8
Mlgy0btpH0vSKJyL9J9t
=IEBI
-----END PGP SIGNATURE-----

--Z8yxTSU1mh2gsre7--
