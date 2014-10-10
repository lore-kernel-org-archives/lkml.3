Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaJJR4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 13:56:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60221 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaJJR4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 13:56:38 -0400
Date: Fri, 10 Oct 2014 12:55:26 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, <nsekhar@ti.com>,
        <t-kristo@ti.com>, <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 01/12] rtc: omap: fix clock-source configuration
Message-ID: <20141010175515.GM31348@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-2-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hXth9cGL35Nvpk4x"
Content-Disposition: inline
In-Reply-To: <1412881594-25678-2-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hXth9cGL35Nvpk4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 09:06:23PM +0200, Johan Hovold wrote:
> Make sure not to reset the clock-source configuration when enabling the
> 32kHz clock mux.
>=20
> Until the clock source can be configured through device tree we must not
> overwrite settings made by the bootloader (e.g. clock-source selection).
>=20
> Fixes: cd914bba03d8 ("drivers/rtc/rtc-omap.c: add support for enabling
> 32khz clock")
> Cc: stable <stable@vger.kernel.org>
>=20
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/rtc/rtc-omap.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> index 21142e6574a9..f842c216f2dd 100644
> --- a/drivers/rtc/rtc-omap.c
> +++ b/drivers/rtc/rtc-omap.c
> @@ -431,8 +431,10 @@ static int __init omap_rtc_probe(struct platform_dev=
ice *pdev)
>  	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
> =20
>  	/* enable RTC functional clock */
> -	if (id_entry->driver_data & OMAP_RTC_HAS_32KCLK_EN)
> -		rtc_writel(OMAP_RTC_OSC_32KCLK_EN, OMAP_RTC_OSC_REG);
> +	if (id_entry->driver_data & OMAP_RTC_HAS_32KCLK_EN) {
> +		reg =3D rtc_read(OMAP_RTC_OSC_REG);
> +		rtc_writel(reg | OMAP_RTC_OSC_32KCLK_EN, OMAP_RTC_OSC_REG);
> +	}
> =20
>  	/* clear old status */
>  	reg =3D rtc_read(OMAP_RTC_STATUS_REG);
> --=20
> 2.0.4
>=20

--=20
balbi

--hXth9cGL35Nvpk4x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOB2OAAoJEIaOsuA1yqRElE8P/2meYd7iu2b3E4RxjaSOSmpA
BK3hp/sq43m5JRvx3pzNozKoNhXwo1PFUgL0WZxzeBFduVKhUApoVgsr1+JZTrN/
BuoyOP5BIIOvmi9VbsVB3E8rHD9bjQZHDSbwPQqfi0yw0DXbBJGFjpaGEK53RnZf
9I8tqzkByzxLFnLm42iMWUphsKY3IGhwMmy0epPLP2LhU6r+cvUO5FBYo71qOVOb
LKF6buHPfil+gqk8bcHx1DTe5SulXnTeANKVMxJn1pTFYwWxQdktcR3pPj18IDoy
nxxyI+ZX+YFuCYVZad/eQw/rEq2PnHi/gXcYFzAwh1YhaK71AV9yEV1SppUNVdfO
i7ENfBRLX6cr+KKyZ7hyiu0qrf82RQYIEWU2GCX6QOmvFcHSfoKXaoHd9ffwnGUm
KelHzveM7ym97Jj+t8XWSA0mzFl4XlnuYYepzEImgyuZGBznaNoXWeyacasOKtgq
LxpQMHqVfeElYP1k/QP7F20A+gVrpydgSdYBQjv4d2sg5jG8lEVgiZ3dPiXWx0zO
NdOTwhwTi2VeGoPXO3+EvT+tZfd1HwI4y5UJFF8qTtZH6jJxBrHXz63z07J05lw6
DvyNIQlxOH5z28T8YeG9Xf9d1eVlI1MJqVqCWPLwWtmgO3dw/0SzNdZs6WwmW5ei
6ciPAl8dK84FYDaQZ5gO
=SwEh
-----END PGP SIGNATURE-----

--hXth9cGL35Nvpk4x--
