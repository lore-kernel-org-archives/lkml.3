Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966669Ab3DRIDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 04:03:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49833 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966635Ab3DRIDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 04:03:34 -0400
Date: Thu, 18 Apr 2013 10:03:29 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Chao Xie <chao.xie@marvell.com>
Cc: linux-kernel@vger.kernel.org, xiechao.mail@gmail.com
Subject: Re: [PATCH 3/3] pwm: pxa: add device tree support
Message-ID: <20130418080329.GA18212@avionic-0098.mockup.avionic-design.de>
References: <1366095115-21864-1-git-send-email-chao.xie@marvell.com>
 <1366095115-21864-4-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <1366095115-21864-4-git-send-email-chao.xie@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:NqFjwwiWjH5bFZtQ/rcpp+qYDagug/uXqq09PS/kGLm
 l91di6GK7mHmM1YhDcjwtw69mB8GUT4iCyPxn3onWOmTblQXYf
 xvHPn6K6Vydtv6OxymQVz1LpctmmC2Vb6+CPUy0oj2uZlzV2uN
 J4EM77eo1tbMV87xG6CKm/oVx+x5hhOFRJl3aBNYsYa9J6i7Xd
 rWgmUIRdrMgQxdX5vLKb1T8VNs7Zmn4xX+ivGXViVVA8UIEJDg
 k+0mYDG9xhzrmSiNSrpkJTpiGw5awbp9WxNKx5ecNaRZ/oOkAO
 ba6TZmNREo4ASV70AepR8Vk7ByRfu7D+Z1zNMIp4UNaixPb4vy
 vYK5YyvsoqHFFx0egm81S6ZEymusac00eTZSZyeoMIPl+fbrqx
 T5FhJ/rleCO7h24wvJ2SXdo7CRQu8T0skU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2013 at 02:51:55AM -0400, Chao Xie wrote:
> Add the deice tree support for pwm-pxa.

"device" and you can drop "the".

>  drivers/pwm/pwm-pxa.c |   31 ++++++++++++++++++++++++++++++-
>  1 files changed, 30 insertions(+), 1 deletions(-)

This is missing a file in Documentation/devicetree/bindings/pwm that
describe the device tree bindings for this driver.

> diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
[...]
> +static struct of_device_id pxa_pwm_of_match[] =3D {

I know not all drivers do this, but this should be "static const".

> +	{
> +		.compatible =3D "mrvl,pxa25x-pwm",

According to Documentation/devicetree/bindings/vendor-prefixes.txt the
vendor prefix for Marvell is "marvell".

> +		.data =3D (void *)0

Initialization to 0 is redundant here.

>  static int pwm_probe(struct platform_device *pdev)
>  {
>  	const struct platform_device_id *id =3D platform_get_device_id(pdev);
> +	const struct of_device_id *of_id =3D
> +			of_match_device(pxa_pwm_of_match, &pdev->dev);
>  	struct pxa_pwm_chip *pwm;
>  	struct resource *r;
>  	int ret =3D 0;
> +	unsigned int npwm;
> =20
>  	pwm =3D devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
>  	if (pwm =3D=3D NULL) {
> @@ -157,7 +181,12 @@ static int pwm_probe(struct platform_device *pdev)
>  	pwm->chip.dev =3D &pdev->dev;
>  	pwm->chip.ops =3D &pxa_pwm_ops;
>  	pwm->chip.base =3D -1;
> -	pwm->chip.npwm =3D (id->driver_data & HAS_SECONDARY_PWM) ? 2 : 1;
> +	if (of_id)
> +		npwm =3D (unsigned int)(of_id->data);
> +	else
> +		npwm =3D id->driver_data;
> +
> +	pwm->chip.npwm =3D (npwm & HAS_SECONDARY_PWM) ? 2 : 1;

Can you rebase this on my for-next branch since it has some patches that
this conflicts with.

Also I think this patch is missing the assignment of

	.of_match_table =3D pxa_pwm_of_match;

in the platform_driver structure initialization. And I think PXA hasn't
been fully converted to OF-only, so you need to conditionalize the OF
bits.

Thierry

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRb6jRAAoJEN0jrNd/PrOhnwUQAKrkp2IuudUTv0WdkBAad3bY
nU6YOP0jymtQxlvW33Ewrbw11u0B1DC5OL4g7Oee1D4u/V2TR4sFMNUHlKwhsDSv
PjTRWZeMbx5Bt981NVpqgSzMvu0DJq1AdWl6vMROKoTG5di4YXTw2M1T1delrRJ4
auS5/v6htt5PWpIcpqvINcrWnaxLKXbIAUVgO+r1YafJSfxp8CAbSqdICwT9iM02
FxYjL/t5rO9aF72uHNdDSGghDhvYynQwFf//VjMxz7bDveLfzx1YmjC0EGvXLFlF
WcNoIRcpfc772DWztkGT25ybzSUsRAsRDUyWje0uMkHTpdLAgyj1GezL0jfBcLex
KlTLvcHYvXx0IUbS7Ycos6G4lQgjrMX2ikOCGJqvvIhEwNr7Tnkgkio4aQK4wDHz
reWbhZTzC2mmXfO2AGogH3Gvk9BT1vBycVRqfwdVIAXYPpz6JTIz5E7f8MTjVlky
fDz0B8HGJRPgPALZ2fkqIoHR4spJ+0Ghjd4onzC4oYZlLy2GT+FV8GI5dJabfCCh
UTgQguxZC0Wf7sYFVnTmbbc93IgGn7MSfY2m60wu8kWQw3xsmQNpmsATrMZ+Ck7a
blItPP8GMsLPcKJmWgT2nRQOkwGfvSDViS6f3qsPzXh64Kxi4jS9w8Y8mRg9r+pt
vOG6VyMJ1mOBHrb2HwMx
=VeSa
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
