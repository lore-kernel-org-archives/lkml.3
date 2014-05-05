Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaEEShG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:37:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44648 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaEEShE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:37:04 -0400
Date: Mon, 5 May 2014 13:36:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: <linux-watchdog@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/5] watchdog: Add API to trigger reboots
Message-ID: <20140505183606.GJ17875@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398958893-30049-1-git-send-email-linux@roeck-us.net>
 <1398958893-30049-2-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1y6imfT/xHuCvpN0"
Content-Disposition: inline
In-Reply-To: <1398958893-30049-2-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1y6imfT/xHuCvpN0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 01, 2014 at 08:41:29AM -0700, Guenter Roeck wrote:
> Some hardware implements reboot through its watchdog hardware,
> for example by triggering a watchdog timeout. Platform specific
> code starts to spread into watchdog drivers, typically by setting
> pointers to a callback functions which is then called from the
> platform reset handler.
>=20
> To simplify code and provide a unified API to trigger reboots by
> watchdog drivers, provide a single API to trigger such reboots
> through the watchdog subsystem.
>=20
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/watchdog/watchdog_core.c |   17 +++++++++++++++++
>  include/linux/watchdog.h         |   11 +++++++++++
>  2 files changed, 28 insertions(+)
>=20
> diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog=
_core.c
> index cec9b55..4ec6e2f 100644
> --- a/drivers/watchdog/watchdog_core.c
> +++ b/drivers/watchdog/watchdog_core.c
> @@ -43,6 +43,17 @@
>  static DEFINE_IDA(watchdog_ida);
>  static struct class *watchdog_class;
> =20
> +static struct watchdog_device *wdd_reboot_dev;
> +
> +void watchdog_do_reboot(enum reboot_mode mode, const char *cmd)
> +{
> +	if (wdd_reboot_dev) {
> +		if (wdd_reboot_dev->ops->reboot)

you can decrease one level of indentation:

	if (wdd_reboot_dev && wdd_reboot_dev->ops->reboot)

also, shouldn't you test if 'ops' is valid too ? In that case:

	if (wdd_reboot_dev && wdd_reboot_dev->ops &&
		wdd_reboot_dev->ops->reboot)

--=20
balbi

--1y6imfT/xHuCvpN0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTZ9oWAAoJEIaOsuA1yqRECIgP/1JKok5Ayi6RiKCJMZIHnDH6
HeAA8AQgq8d91Lu2AfIhTxJCXTPscg7ANCwko6FSwWNRxwSNMJPtHYBMUrWhY9fC
en2WuMmXX4K6tSDCZVUocV9/+gTg9K/013La3VyFixV02F4m+0bij9PIvrrZAaoQ
zq83H0494bkT74X6SrtAkApDRKtgyE9pRZSDQmx1RK8EOSPEFzvggrvXv7D1gq/E
U/6I7HnmxbrSFB6aagKVJ9nvAPEFHRIe8wF5fIX+7RH5tvD1IEVFVazVsm2Pxf9f
beEkHxJYMeLStEGmnT3xQ/SoG2adn9BR/HEYw/E9VVTGXgZIC18EGSdE2KrVg4uh
OSQQaKpUBkFQw2aehC1b0QivXup9YtfKzY+egwql/+2LMWT85ypZe63fAs+6opJc
8KBCWoJp4jLJ0OVIqu/kf+n0n5/Zj+sEP68fSvU24mjMTkfCrtSvSZlSiqZU/Cww
SoP0+SJlTpSRGc4rSJXHsgAkVPwzGWTETg38erWrqShmccIefb9Z8EOtBDKpVAyP
xDs8c5Ojh9FAsUh8X5mB4MkT+KYnkVZMd90JEoJr9qR1Gzp1/D0/3DN01yVDXaqm
AVXfYkOjT01d/5KKLVMJ4BEmayo4Z+bZX3PVHIJQtozEDi1D9MYTcaNBUdOu1O5s
XSx+AsgCuZubGgkoOLlT
=9bGj
-----END PGP SIGNATURE-----

--1y6imfT/xHuCvpN0--
