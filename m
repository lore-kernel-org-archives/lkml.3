Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbaJJSBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:01:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38344 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbaJJSBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:01:12 -0400
Date: Fri, 10 Oct 2014 13:00:15 -0500
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
Subject: Re: [PATCH 06/12] rtc: omap: use dev_info and dev_dbg
Message-ID: <20141010180015.GR31348@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-7-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VgNP6wxEowREGVu+"
Content-Disposition: inline
In-Reply-To: <1412881594-25678-7-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VgNP6wxEowREGVu+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 09:06:28PM +0200, Johan Hovold wrote:
> Use dev_info and dev_dbg rather than pr_info and pr_debug.
>=20
> Signed-off-by: Johan Hovold <johan@kernel.org>

thanks!

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/rtc/rtc-omap.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> index e50ffd7063f5..1c58920b0c88 100644
> --- a/drivers/rtc/rtc-omap.c
> +++ b/drivers/rtc/rtc-omap.c
> @@ -392,13 +392,13 @@ static int __init omap_rtc_probe(struct platform_de=
vice *pdev)
> =20
>  	omap_rtc_timer =3D platform_get_irq(pdev, 0);
>  	if (omap_rtc_timer <=3D 0) {
> -		pr_debug("%s: no update irq?\n", pdev->name);
> +		dev_dbg(&pdev->dev, "no update irq\n");
>  		return -ENOENT;
>  	}
> =20
>  	omap_rtc_alarm =3D platform_get_irq(pdev, 1);
>  	if (omap_rtc_alarm <=3D 0) {
> -		pr_debug("%s: no alarm irq?\n", pdev->name);
> +		dev_dbg(&pdev->dev, "no alarm irq\n");
>  		return -ENOENT;
>  	}
> =20
> @@ -430,8 +430,7 @@ static int __init omap_rtc_probe(struct platform_devi=
ce *pdev)
>  	/* clear old status */
>  	reg =3D rtc_read(OMAP_RTC_STATUS_REG);
>  	if (reg & (u8) OMAP_RTC_STATUS_POWER_UP) {
> -		pr_info("%s: RTC power up reset detected\n",
> -			pdev->name);
> +		dev_info(&pdev->dev, "RTC power up reset detected\n");
>  		rtc_write(OMAP_RTC_STATUS_POWER_UP, OMAP_RTC_STATUS_REG);
>  	}
>  	if (reg & (u8) OMAP_RTC_STATUS_ALARM)
> @@ -440,22 +439,22 @@ static int __init omap_rtc_probe(struct platform_de=
vice *pdev)
>  	/* handle periodic and alarm irqs */
>  	if (devm_request_irq(&pdev->dev, omap_rtc_timer, rtc_irq, 0,
>  			dev_name(&pdev->dev), pdev)) {
> -		pr_debug("%s: RTC timer interrupt IRQ%d already claimed\n",
> -			pdev->name, omap_rtc_timer);
> +		dev_dbg(&pdev->dev, "RTC timer interrupt IRQ%d already claimed\n",
> +				omap_rtc_timer);
>  		goto fail0;
>  	}
>  	if ((omap_rtc_timer !=3D omap_rtc_alarm) &&
>  		(devm_request_irq(&pdev->dev, omap_rtc_alarm, rtc_irq, 0,
>  			dev_name(&pdev->dev), pdev))) {
> -		pr_debug("%s: RTC alarm interrupt IRQ%d already claimed\n",
> -			pdev->name, omap_rtc_alarm);
> +		dev_dbg(&pdev->dev, "RTC alarm interrupt IRQ%d already claimed\n",
> +				omap_rtc_alarm);
>  		goto fail0;
>  	}
> =20
>  	/* On boards with split power, RTC_ON_NOFF won't reset the RTC */
>  	reg =3D rtc_read(OMAP_RTC_CTRL_REG);
>  	if (reg & (u8) OMAP_RTC_CTRL_STOP)
> -		pr_info("%s: already running\n", pdev->name);
> +		dev_info(&pdev->dev, "already running\n");
> =20
>  	/* force to 24 hour mode */
>  	new_ctrl =3D reg & (OMAP_RTC_CTRL_SPLIT|OMAP_RTC_CTRL_AUTO_COMP);
> @@ -476,7 +475,7 @@ static int __init omap_rtc_probe(struct platform_devi=
ce *pdev)
>  	 */
> =20
>  	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
> -		pr_info("%s: split power mode\n", pdev->name);
> +		dev_info(&pdev->dev, "split power mode\n");
> =20
>  	if (reg !=3D new_ctrl)
>  		rtc_write(new_ctrl, OMAP_RTC_CTRL_REG);
> --=20
> 2.0.4
>=20

--=20
balbi

--VgNP6wxEowREGVu+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOB6vAAoJEIaOsuA1yqREwdEP/jSWNAjh7Xb/1fugK8pwFxuz
rtlJqUzgYbhTp9AMu7hScTC2LIdP2dq9XulwCVKw/9h1YJykCTxNnoKWn7AOj/Wv
+RiWOTpxV+Mmjy2ajvfuWBfqG8IxURJRXbxtnjFJR1fMbfFWLEZlr4cmaJxWUY1D
azi3uW3dfcDrjfN+NrZdBzTAGlM1hF0z/WeS/r6Auc4P15fAsL8dTR8+WCqanAHp
CM1bQhx0rLJZK5TZ1YKro44AoX+zUZQROTxOTmAAY2LQyXl7JIMaYOvcxQh/ypui
OSfkNksnPN86Vehr+Pqa8C25IEH++UIfloc4/MqFaZBvM5IvjPcvdbZn0NmwWut+
N7RsrXEDvs6MR8gDCeJD5wpDJx3t9OHHnWwHXb7x8EVbNoVeHpYZA2u5LYsxiQ4p
8U7+p3uHEHPhGzl4dgiD2FcPWpxM+cGFUQwyqp+VWI6LNuUTUGSRA0ir/6w4Hsuj
mjguUOAB+LyKoTiZntkTL9NoqnwCyOnQcIReef9eXsbIlYryqvjvVB4J09yJtrnL
LQwlm64s99PB8QjDrIlA/pmykzQAu8TQvbtwTqEPwec2criV4/j2aJIqHBtY2TtR
7Id+Pm/Am+yjzUYWAlfEN/b/VflaTHMlUT4hzQE2sZx9JCtr2qFrBjjOXhCBdYYq
S+/g/mIr1UQOtrmv8dC7
=oozy
-----END PGP SIGNATURE-----

--VgNP6wxEowREGVu+--
