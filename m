Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbaJJSJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:09:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38686 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbaJJSJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:09:02 -0400
Date: Fri, 10 Oct 2014 13:08:03 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, <nsekhar@ti.com>,
        <t-kristo@ti.com>, <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/12] rtc: omap: enable wake-up from power off
Message-ID: <20141010180755.GW31348@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-11-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k8ylJtLa18RSEDYA"
Content-Disposition: inline
In-Reply-To: <1412881594-25678-11-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--k8ylJtLa18RSEDYA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 09:06:32PM +0200, Johan Hovold wrote:
> The ALARM interrupt must not be disabled during shutdown in order to be
> able to power up the system using an RTC alarm.
>=20
> Signed-off-by: Johan Hovold <johan@kernel.org>

nicely done!

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/rtc/rtc-omap.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> index b0319864dd42..8836c58901b5 100644
> --- a/drivers/rtc/rtc-omap.c
> +++ b/drivers/rtc/rtc-omap.c
> @@ -670,7 +670,15 @@ static SIMPLE_DEV_PM_OPS(omap_rtc_pm_ops, omap_rtc_s=
uspend, omap_rtc_resume);
> =20
>  static void omap_rtc_shutdown(struct platform_device *pdev)
>  {
> -	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
> +	u8 mask;
> +
> +	/*
> +	 * Keep the ALARM interrupt enabled to allow the system to power up on
> +	 * alarm events.
> +	 */
> +	mask =3D rtc_read(OMAP_RTC_INTERRUPTS_REG);
> +	mask &=3D OMAP_RTC_INTERRUPTS_IT_ALARM;
> +	rtc_write(mask, OMAP_RTC_INTERRUPTS_REG);
>  }
> =20
>  MODULE_ALIAS("platform:omap_rtc");
> --=20
> 2.0.4
>=20

--=20
balbi

--k8ylJtLa18RSEDYA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOCCDAAoJEIaOsuA1yqREMHsP/RTjlZtXHYw3R66qwnWZpGFr
YhgO8lTUZ4Y2CbujqzWR7PU8ChlIyKY/+rEoNfeULywajHrecKcEK4LtyfNJU5mn
9n+IWXTOloRWRDtLq/GK0aHp/wUXpmCGo/xPUVrT2ComwRuPfMq+rz5V0B9arsB1
m/NRxEfpMLrITgdbV3DiW8+WBtGkPfvegMFQ3brrdKUvsxH34IrQKHEmNhvi1fQE
EdlvEmV479r62K/MFNeCDELSOMm7WMmQiOhp48aTnjcINdMq3ua5kbEy66F7DkPK
FwvS1DsuDiZRS2sozvPdrX8isiG3FfOY+rHk+z9al8MZbTJyJ0KHNQHWyXEyKF9F
Oyk2d0RgSSK/AgZu3ZUqpmaFS4Ie7FsGAzUdUkJrhm8uQsg/EU/wlUtat21PFeVt
Yxl8e7VoFtICySvzxWi9xTA4sx4exAlHbef5J86ih2snnS5TVU5liRTnYMSMwxP6
aBpOxLcpcgacpIjHjX+zAOTeWBZvCTn/0Ir29Ql4YVq05G6WNlb/jiUzRjdsRMeI
1qXlrYms+mLbinZ9jc0HRRkFOFcX1dkPqlnGMc2AQeFkJFegnoylmwGKLbLnyD3K
F7TbcqnVfCCVXErXWTnDSCHD39qAFxacfij8KGWK360wwdVYj0Z6mytVqC0Joc4S
LcBrtW6XfQKars2FNNB8
=0nSB
-----END PGP SIGNATURE-----

--k8ylJtLa18RSEDYA--
