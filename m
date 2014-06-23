Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaFWMBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:01:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33833 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaFWMBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:01:51 -0400
Message-ID: <53A81720.2050507@ti.com>
Date: Mon, 23 Jun 2014 15:01:36 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Franck Jullien <franck.jullien@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
CC: <plagnioj@jcrosoft.com>, <stefan.kristiansson@saunalahti.fi>
Subject: Re: [PATCH] video: OF display-timings support for ocfb
References: <1402517871-27503-1-git-send-email-franck.jullien@gmail.com>
In-Reply-To: <1402517871-27503-1-git-send-email-franck.jullien@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="LUBlqihxMeIloFGaSAW0U7sMEWr3QGKVu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LUBlqihxMeIloFGaSAW0U7sMEWr3QGKVu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/06/14 23:17, Franck Jullien wrote:
> Signed-off-by: Franck Jullien <franck.jullien@gmail.com>
> ---
>  drivers/video/fbdev/Kconfig |    2 ++
>  drivers/video/fbdev/ocfb.c  |   31 ++++++++++++++++++++++++++-----
>  2 files changed, 28 insertions(+), 5 deletions(-)

You need to add binding documentation if you add new things to the
driver's DT support. Actually, we seem to be missing the the binding
documentation totally, even if the driver has 'of_device_id' table...

> diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
> index e1f4727..b4ac6bb 100644
> --- a/drivers/video/fbdev/Kconfig
> +++ b/drivers/video/fbdev/Kconfig
> @@ -942,6 +942,8 @@ config FB_OPENCORES
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT
> +	select VIDEOMODE_HELPERS
> +	select FB_MODE_HELPERS
>  	help
>  	  This enables support for the OpenCores VGA/LCD core.
> =20
> diff --git a/drivers/video/fbdev/ocfb.c b/drivers/video/fbdev/ocfb.c
> index 7f9dc9b..6d15565 100644
> --- a/drivers/video/fbdev/ocfb.c
> +++ b/drivers/video/fbdev/ocfb.c
> @@ -22,6 +22,8 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
> =20
> +#include <video/of_display_timing.h>
> +
>  /* OCFB register defines */
>  #define OCFB_CTRL	0x000
>  #define OCFB_STAT	0x004
> @@ -310,11 +312,30 @@ static int ocfb_probe(struct platform_device *pde=
v)
>  	fbdev->info.device =3D &pdev->dev;
>  	fbdev->info.par =3D fbdev;
> =20
> -	/* Video mode setup */
> -	if (!fb_find_mode(&fbdev->info.var, &fbdev->info, mode_option,
> -			  NULL, 0, &default_mode, 16)) {
> -		dev_err(&pdev->dev, "No valid video modes found\n");
> -		return -EINVAL;
> +	if (!mode_option && IS_ENABLED(CONFIG_OF)) {

This doesn't look correct. The kernel may have CONFIG_OF enabled, even
if the board does not use OF.

 Tomi



--LUBlqihxMeIloFGaSAW0U7sMEWr3QGKVu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqBcgAAoJEPo9qoy8lh71LvkP/jOU7vY9dokfmFu9KeHecJ8+
X3+ug0JGy0htT61GOQHckn4/t5AY0EjzSqlVIi+eHrxBYEEtMChznzTUICLjN4+n
5WK+KcUNMBgeSH5m4/KYb8VmlbwLAREgNOpLQRQK0oxbhWuJ+nqhp23frlqpd9OT
tqNHVkJYstlWvEEVUahOioDNbSQa3x8HFKP6pbCSPhf3qv7DM0L0oFgXx7YsWewO
WUpq8KeEz4gptYIMw8kPLwjV0MqQu55WJwHTNA2q4zToDN7z/GJXvao9RcH2mCB1
krNUvXemUAfK1PmdQGwvzylY8AEcxJXKZ5qCcO/RbkqcBgQqPIqTI3z3RdytUOR7
rUeJDPfJztfM7QmVOH3CeptbBNcNHbjDQM1tbK+9XkzZcIZRPSFFKu6WqYRBGEzG
DFpNM0PoV9R9n8TYw7Bl4SvUU6/+wd/2m60w0S/SuFphxTDxf2ugFQpeCdCKX5Lc
QpJ6xmu5VebVvwC4m9pjIoPB5fMfXQ7ytj1gXz6hjlnfURu8ODmYjWuhyBdQjj2q
cUskNUpVVdzhudhgE5erKfkZUNYH4RaKtdyoWuYzyXE4ug2Qeyhw0p6v5efKMn7X
3q8meGyepx6sGZZDlIFlZ9Qmg4w++YmysFOMzUzdoVAWmcKi81bQiHMCYFrfYwc6
wLQe6IbZrdegGrpwviRr
=gkId
-----END PGP SIGNATURE-----

--LUBlqihxMeIloFGaSAW0U7sMEWr3QGKVu--
