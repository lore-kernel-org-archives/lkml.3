Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3BALYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:24:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52294 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3BALYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:24:20 -0500
Date: Fri, 1 Feb 2013 12:24:13 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Input: tegra-kbc- Convert to
 devm_ioremap_resource()
Message-ID: <20130201112412.GA29105@avionic-0098.mockup.avionic-design.de>
References: <1359713277-14228-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <1359713277-14228-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:07Xme0+hj5aTbg3Sce/OX6yy/muEWNBAW2S89kJFxZl
 zp6uGhpY53IVdJ+qLSpaDf9y6Q0fmRd3lUdfdJXuFuyfTV+HaQ
 Chb7Uktjv/JRs+9KWEk/UN75jX3zOl/IHCfGxXUsse9ByrfmiL
 L8iRacu/0NKk8ow4BwWgSKbh7cXoLQe6joHv++qFfjbirD/dWq
 zJp1hL4d4YxYF3kjT6nkBWEhN8isoIz+K/VNnRQFRGNx317dDH
 1taCgpa7yh0TqkxOZzwleTg5NMayQ/73731NwzDRmqrk80VAeh
 VzteGBgbGSzsvdSSnsvSBqWXonFmjkV24HwH6NB4ZSURrrKVWt
 MQu4SSzFykGqUGZZU0Fm12kamUNyr7S59Uhy//JShflNm0zyTQ
 1ouu/CdKq3wrq0YdGjPy9RD4raGgaPb3pE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 01, 2013 at 03:37:56PM +0530, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
>=20
> devm_ioremap_resource() provides its own error messages; so all explicit
> error messages can be removed from the failure code paths.
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> ---
>  Patch based & compile tested on linux-next tree (20130128).
>  Changes since v1:
>  * Dropped the error message as it is now handled by devm_ioremap_resourc=
e()
>  itself.
> ---
>  drivers/input/keyboard/tegra-kbc.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/=
tegra-kbc.c
> index 46e8ad2..fc43806 100644
> --- a/drivers/input/keyboard/tegra-kbc.c
> +++ b/drivers/input/keyboard/tegra-kbc.c
> @@ -31,6 +31,7 @@
>  #include <linux/slab.h>
>  #include <linux/input/tegra_kbc.h>
>  #include <linux/clk/tegra.h>
> +#include <linux/err.h>
> =20
>  #define KBC_MAX_DEBOUNCE_CNT	0x3ffu
> =20
> @@ -615,11 +616,9 @@ static int tegra_kbc_probe(struct platform_device *p=
dev)
>  	spin_lock_init(&kbc->lock);
>  	setup_timer(&kbc->timer, tegra_kbc_keypress_timer, (unsigned long)kbc);
> =20
> -	kbc->mmio =3D devm_request_and_ioremap(&pdev->dev, res);
> -	if (!kbc->mmio) {
> -		dev_err(&pdev->dev, "Cannot request memregion/iomap address\n");
> -		return -EBUSY;
> -	}
> +	kbc->mmio =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(kbc->mmio))
> +		return PTR_ERR(kbc->mmio);
> =20
>  	kbc->clk =3D devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(kbc->clk)) {

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRC6XcAAoJEN0jrNd/PrOh3ZkP/0b/VYGXrNAQkkVsMlBFtQg0
MY8W8K0JFC7Nr26tiTQrVEiGvVoo1XtU3HzmeML+KXi8PKv8IqfPNmL88ng81UxF
M5yBDAhpY+S5hqlMWk9RCdMjikun0tx+9GxwYFAolnMVLw1hn6r7ceBFQQH1djxu
hWM0sU+r1DW6QmWh+pEPflZrWV+34nUULt9XaGYzc5zi/7zixZtWIrewvmP2yj36
cIvkaDWkVfaZ/UA1K72GNr91QJ/c32qc7uYEJ5MQA1iZPmzw8UYqb0tiopQKPIsr
LbZS3fgsy2vYYV8Dppvthf1UPjpc3o1H2p8Ujbt71x7ayngoPkCrj82wHVVW1QMA
AiZhkXqlaaPZcbkK62TtWgwwb1mxWK2ODwAmgd/AcSmzrd0buO7t83oxzkwbcfmd
dZgDb4fmWENWGR+BHiXPZzWBe9oZMalnJn9biWVgnGMG3N76A7Tmer9Vly55xZQ8
s0U6f+jC53tXSHfm7vfZxkpeshvW+8u6stOwy1/aDRdTO1tbexAI5uic9huxfbct
wUE2Ysx3Gxwx6z1pRfnRq/UTg2cLpYWrsBlvT8XK7xiUvdzsxF4bK2IyWXCPOsWa
nTtpuHSsGij/Gk7DyuDzEvxYTnc30aumctDDGvQ5t0lDh6ELI0Uq9gGfl6QVsXIB
CpnE1oAawjg2a0HgANMJ
=gRtj
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
