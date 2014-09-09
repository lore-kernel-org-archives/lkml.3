Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaIILAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:00:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58099 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaIILAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:00:46 -0400
Date: Tue, 9 Sep 2014 13:00:43 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Lisovy Rostislav <lisovy@gmail.com>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Michal Vokac <michal.vokac@comap.cz>
Subject: Re: Watchdog start during boot
Message-ID: <20140909110043.GG24081@pengutronix.de>
References: <1410258569.15354.3.camel@lp-lvrv.comap.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IvGM3kKqwtniy32b"
Content-Disposition: inline
In-Reply-To: <1410258569.15354.3.camel@lp-lvrv.comap.cz>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:51:29 up 23 days, 23:11, 91 users,  load average: 0.19, 0.09,
 0.10
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IvGM3kKqwtniy32b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 09, 2014 at 12:29:29PM +0200, Lisovy Rostislav wrote:
> Hello;
> If my understanding is correct, the purpose of the "watchdog subsystem"
> is to provide an unified interface from user-space to watchdog devices
> (via /dev). The issue I am trying to solve is how to start the watchdog
> during boot (it would be sufficient just not to disable it since the
> bootloader enables it) to be controlled later on with the user-space
> tool -- i.e. when the user-space will not boot properly, I would like
> the device to be rebooted.
>=20
> My "quick and dirty" device-specific solution is:
>=20
> diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
> index 3691b15..1e44b03f 100644
> --- a/drivers/watchdog/omap_wdt.c
> +++ b/drivers/watchdog/omap_wdt.c
> @@ -53,6 +53,10 @@ static unsigned timer_margin;
>  module_param(timer_margin, uint, 0);
>  MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
> =20
> +static bool start_on_boot =3D false;
> +module_param(start_on_boot, bool, 0);
> +MODULE_PARM_DESC(start_on_boot, "Start the watchdog during boot");
> +
>  struct omap_wdt_dev {
>         void __iomem    *base;          /* physical */
>         struct device   *dev;
> @@ -269,6 +273,9 @@ static int omap_wdt_probe(struct platform_device *pde=
v)
> =20
>         pm_runtime_put_sync(wdev->dev);
> =20
> +       if (start_on_boot)
> +               omap_wdt_start(omap_wdt);
> +
>         return 0;
>  }
>=20
> however I think it would be much beneficial to do this in a generic way.
> Maybe to create a device tree property, that would store some flag to
> start the watchdog during boot?

The devicetree should be a hardware description, so it may not be the
right way to pass such information.

Some time ago I proposed something similar where the first watchdog
driver that is registered can be activated by a kernel commandline
parameter. Here is some discussion about the topic:
	Mail-id 1393604183-8755-1-git-send-email-mpa@pengutronix.de
	http://www.spinics.net/lists/linux-watchdog/msg04055.html

Best regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--IvGM3kKqwtniy32b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDt3aAAoJEEpcgKtcEGQQfIIP+wZEx09jOfDiINxBqMCU+pf1
stA94CkkpkaCtZKRa/Q6sAj0cj7P9v307AnwZy+ysQ/iFLXc+STbwdrqldPOTYmL
I+SBcp+KbiEXe7wvsz+NDJlmjaYYiBeHJ3O35upxl56iONokM2KtpBZruhBW/zSS
W1UdaqYdvHJdsrUB7k3/JaVBVhawk7C5bj+hZqFjLltrQvuZgKS0v4WGuApf6NM0
ed1k7JJznD0Ozv7X7hksYAwrDMiUVAD8v4qOJUO2wyrbye9EdWLsxYWfvXkMKscB
hYwYQXrm0x5CQ67tH8UdlRSqGJPUiqrp5nFriECeSWB75Wm5F3jPc1K47bIhgDTK
orm4A2aG8NMuXzwE1Mo41Qjg6izzFKgO6wiJFWeJmpaWWPxwIlO9hY6bnv5/goav
M4XAmbF4f9c72WwSHJM/NVOr5Yi/DhJkSsj7lWwe8a6TFDvopaUl/ZhiOXQoNnhJ
6+GLOdGa02EnYqZkc3c3DXu/mIJ4o6orO8qtXkrbNWasjqYNP5RZkdoYBSLPozxP
zXbjW244ymY6CONrz+GUtppzw9ekLAxwLbAY0C7XLgJDThkjpF8wAjpS3Q8wc69I
/jtN0uR2irIudWYjpME5e9w6mokMB1zpSDoUQTMQfeNWAJWcaY+P8fwNEnK8urrt
ddy6Kwal8WYrYH+cK7dV
=3st2
-----END PGP SIGNATURE-----

--IvGM3kKqwtniy32b--
