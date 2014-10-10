Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaJJR44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 13:56:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56527 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbaJJR4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 13:56:54 -0400
Date: Fri, 10 Oct 2014 12:55:49 -0500
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
Subject: Re: [PATCH 02/12] rtc: omap: fix missing wakealarm attribute
Message-ID: <20141010175549.GN31348@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-3-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/DkgDsqJFFamjKX0"
Content-Disposition: inline
In-Reply-To: <1412881594-25678-3-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/DkgDsqJFFamjKX0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 09:06:24PM +0200, Johan Hovold wrote:
> The platform device must be registered as wakeup capable before
> registering the class device, or the wakealarm attribute will not be
> created.
>=20
> Also make sure to unregister the wakeup source on probe errors.
>=20
> Fixes: 1d2e2b65d098 ("rtc: omap: restore back (hard-code) wakeup support")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---

Reviewed-by: Felipe Balbi <balbi@ti.com>

>  drivers/rtc/rtc-omap.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> index f842c216f2dd..828cb9983cc2 100644
> --- a/drivers/rtc/rtc-omap.c
> +++ b/drivers/rtc/rtc-omap.c
> @@ -416,6 +416,8 @@ static int __init omap_rtc_probe(struct platform_devi=
ce *pdev)
>  		rtc_writel(KICK1_VALUE, OMAP_RTC_KICK1_REG);
>  	}
> =20
> +	device_init_wakeup(&pdev->dev, true);
> +
>  	rtc =3D devm_rtc_device_register(&pdev->dev, pdev->name,
>  			&omap_rtc_ops, THIS_MODULE);
>  	if (IS_ERR(rtc)) {
> @@ -484,8 +486,6 @@ static int __init omap_rtc_probe(struct platform_devi=
ce *pdev)
>  	 *    is write-only, and always reads as zero...)
>  	 */
> =20
> -	device_init_wakeup(&pdev->dev, true);
> -
>  	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
>  		pr_info("%s: split power mode\n", pdev->name);
> =20
> @@ -495,6 +495,7 @@ static int __init omap_rtc_probe(struct platform_devi=
ce *pdev)
>  	return 0;
> =20
>  fail0:
> +	device_init_wakeup(&pdev->dev, false);
>  	if (id_entry->driver_data & OMAP_RTC_HAS_KICKER)
>  		rtc_writel(0, OMAP_RTC_KICK0_REG);
>  	pm_runtime_put_sync(&pdev->dev);
> --=20
> 2.0.4
>=20

--=20
balbi

--/DkgDsqJFFamjKX0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOB2lAAoJEIaOsuA1yqREcSUQALM7XKGHjrAuZ+dQQyg+EQ9k
Qi/ALbqbQwJd9ZdsUCM2WH4EKCtdlyRBFR0YWft8Ehzf5KETZ/eV+9liG6ZjQg/+
UZfhFxnP0ne90eiSyEq27cCJWiP+VmBfgyvvGwYYdnVBPW1vlYLIVZtIoCzFhHH4
grGA9N0Dnr+Vo7+ROFxc/hCRICBZgKA2auKiIHiHdVWtLcbFxG2ZSQBovn8+IKlW
AuVOvpQGbwXlidmRN5RZPy8Sz4G8bsA1uZj1XJ377Bw9KQAMO37O1Yn9IQakYkAG
ER4y1n6etbluhObE7l96xlNtOiX87nNohL2CJnRHjkcf+JYSmKMfeB+89AX85znK
8zJMTRkchwjlt53BsKyNbjajO5fVuUUSX9+MdIJIf25PJSOFKkntfdoYsLoIMLbO
e2NdZ8wHaBGCOM7ahF/WWdg97pq3UvthmQXZT2Hw2D4JFw9pT0hgi9EIAgxyaekP
GrnX6geOXg1Tgw3hFgYwlchAEgyS4I/SFwfvGERS9AXmhWTvn21OYoZzP5Om0SNk
7cqAdt75P8Dj+7Ce/Zweol4QebJclJ+PvfC4kRzkU+JpMqRmIt6P807WAwTSrXPm
taEFL6ULnxdm6K3wMTO+92oA+yrdr9vU8Vian7QUvQEM9zyEKkfKcwHVtfv5NLm4
PJm1xSdhlyTRRjRgRt/c
=9uki
-----END PGP SIGNATURE-----

--/DkgDsqJFFamjKX0--
