Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaDYPRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:17:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50155 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbaDYPRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:17:00 -0400
Date: Fri, 25 Apr 2014 10:16:42 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <myungjoo.ham@samsung.com>, <balbi@ti.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        <ckeepax@opensource.wolfsonmicro.com>, <broonie@kernel.org>,
        <k.kozlowski@samsung.com>, <kyungmin.park@samsung.com>,
        <patches@opensource.wolfsonmicro.com>
Subject: Re: [PATCHv4 6/9] extcon: arizona: Use devm_extcon_dev_allocate for
 extcon_dev
Message-ID: <20140425151642.GJ29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
 <1398386544-16295-7-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iRjOs3ViPWHdlw/I"
Content-Disposition: inline
In-Reply-To: <1398386544-16295-7-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iRjOs3ViPWHdlw/I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2014 at 09:42:21AM +0900, Chanwoo Choi wrote:
> This patch use devm_extcon_dev_allocate() to simplify the memory control
> of extcon device.
>=20
> Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: patches@opensource.wolfsonmicro.com
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/extcon/extcon-arizona.c | 30 +++++++++++++++++-------------
>  1 file changed, 17 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-ariz=
ona.c
> index f63fa6f..6c84e3d 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -91,7 +91,7 @@ struct arizona_extcon_info {
> =20
>  	int hpdet_ip;
> =20
> -	struct extcon_dev edev;
> +	struct extcon_dev *edev;
>  };
> =20
>  static const struct arizona_micd_config micd_default_modes[] =3D {
> @@ -546,7 +546,7 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *d=
ata)
>  	}
> =20
>  	/* If the cable was removed while measuring ignore the result */
> -	ret =3D extcon_get_cable_state_(&info->edev, ARIZONA_CABLE_MECHANICAL);
> +	ret =3D extcon_get_cable_state_(info->edev, ARIZONA_CABLE_MECHANICAL);
>  	if (ret < 0) {
>  		dev_err(arizona->dev, "Failed to check cable state: %d\n",
>  			ret);
> @@ -581,7 +581,7 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *d=
ata)
>  	else
>  		report =3D ARIZONA_CABLE_HEADPHONE;
> =20
> -	ret =3D extcon_set_cable_state_(&info->edev, report, true);
> +	ret =3D extcon_set_cable_state_(info->edev, report, true);
>  	if (ret !=3D 0)
>  		dev_err(arizona->dev, "Failed to report HP/line: %d\n",
>  			ret);
> @@ -664,7 +664,7 @@ err:
>  			   ARIZONA_ACCDET_MODE_MASK, ARIZONA_ACCDET_MODE_MIC);
> =20
>  	/* Just report headphone */
> -	ret =3D extcon_update_state(&info->edev,
> +	ret =3D extcon_update_state(info->edev,
>  				  1 << ARIZONA_CABLE_HEADPHONE,
>  				  1 << ARIZONA_CABLE_HEADPHONE);
>  	if (ret !=3D 0)
> @@ -723,7 +723,7 @@ err:
>  			   ARIZONA_ACCDET_MODE_MASK, ARIZONA_ACCDET_MODE_MIC);
> =20
>  	/* Just report headphone */
> -	ret =3D extcon_update_state(&info->edev,
> +	ret =3D extcon_update_state(info->edev,
>  				  1 << ARIZONA_CABLE_HEADPHONE,
>  				  1 << ARIZONA_CABLE_HEADPHONE);
>  	if (ret !=3D 0)
> @@ -764,7 +764,7 @@ static void arizona_micd_detect(struct work_struct *w=
ork)
>  	mutex_lock(&info->lock);
> =20
>  	/* If the cable was removed while measuring ignore the result */
> -	ret =3D extcon_get_cable_state_(&info->edev, ARIZONA_CABLE_MECHANICAL);
> +	ret =3D extcon_get_cable_state_(info->edev, ARIZONA_CABLE_MECHANICAL);
>  	if (ret < 0) {
>  		dev_err(arizona->dev, "Failed to check cable state: %d\n",
>  				ret);
> @@ -812,7 +812,7 @@ static void arizona_micd_detect(struct work_struct *w=
ork)
>  	if (info->detecting && (val & ARIZONA_MICD_LVL_8)) {
>  		arizona_identify_headphone(info);
> =20
> -		ret =3D extcon_update_state(&info->edev,
> +		ret =3D extcon_update_state(info->edev,
>  					  1 << ARIZONA_CABLE_MICROPHONE,
>  					  1 << ARIZONA_CABLE_MICROPHONE);
> =20
> @@ -999,7 +999,7 @@ static irqreturn_t arizona_jackdet(int irq, void *dat=
a)
> =20
>  	if (info->last_jackdet =3D=3D present) {
>  		dev_dbg(arizona->dev, "Detected jack\n");
> -		ret =3D extcon_set_cable_state_(&info->edev,
> +		ret =3D extcon_set_cable_state_(info->edev,
>  					      ARIZONA_CABLE_MECHANICAL, true);
> =20
>  		if (ret !=3D 0)
> @@ -1038,7 +1038,7 @@ static irqreturn_t arizona_jackdet(int irq, void *d=
ata)
>  					 info->micd_ranges[i].key, 0);
>  		input_sync(info->input);
> =20
> -		ret =3D extcon_update_state(&info->edev, 0xffffffff, 0);
> +		ret =3D extcon_update_state(info->edev, 0xffffffff, 0);
>  		if (ret !=3D 0)
>  			dev_err(arizona->dev, "Removal report failed: %d\n",
>  				ret);
> @@ -1150,11 +1150,15 @@ static int arizona_extcon_probe(struct platform_d=
evice *pdev)
>  		break;
>  	}
> =20
> -	info->edev.name =3D "Headset Jack";
> -	info->edev.dev.parent =3D arizona->dev;
> -	info->edev.supported_cable =3D arizona_cable;
> +	info->edev =3D devm_extcon_dev_allocate(&pdev->dev, arizona_cable);
> +	if (IS_ERR(info->edev)) {
> +		dev_err(&pdev->dev, "failed to allocate extcon device\n");
> +		return -ENOMEM;
> +	}
> +	info->edev->name =3D "Headset Jack";
> +	info->edev->dev.parent =3D arizona->dev;
> =20
> -	ret =3D devm_extcon_dev_register(&pdev->dev, &info->edev);
> +	ret =3D devm_extcon_dev_register(&pdev->dev, info->edev);
>  	if (ret < 0) {
>  		dev_err(arizona->dev, "extcon_dev_register() failed: %d\n",
>  			ret);
> --=20
> 1.8.0
>=20

--=20
balbi

--iRjOs3ViPWHdlw/I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWnxaAAoJEIaOsuA1yqREitoP+gM+oTC9szzaNf7Lvn1OWpnc
n4QBJZEQy2haYSxkRyr5hfa/dDOE+fBFC6vtH+XlBFuBqYVGS1tN6aDWp3kphumD
M5p8sRyOuYu035U2Tp2UnWfcjT9stjb/zl9ISN/dRlEVxjKbF8nLvnwGNGbwFcqw
dWN6CnK4/uOux0pfX8RjPcYiVlcABzuRwnNnItcAo1/hGpCTb8oySo3gTeSsREUr
sGBjQPvj+H5l8eU4ByjGr8ZBAxdgIs/ABi//gGk5JkLcHJy1L9erVDf2L1WVogBF
xuk3pCdZSQGPso6wP4Zd1YSb1IFUqZOFotWLmocGhYDiQwt2Vat/CDg9SD1WC86X
6bBaPBSFs9oN8ku2PfdqxbTa+EL+4ZTM8oQerRi42VqvO1Il1rmTS1ObV7QTGFYy
VrjZila4m9HePPZT3ynhOkTuPKyRvP4foFfFScYsC/jb1VE1OQWixdBjriP+S2jZ
pjaX80XkVkjVAQQYrsuDB0Y/rD8IyqMI+ozc110/NvgR0WN9aLE3q1HNvwEfMswb
5k6yWolaHGz2RhZTusX1Z/227NSjPj601do/NbMTMsW1yXH+K/VEClHHZBnIyCzY
LHToPbPn2Op2SAH/d1ObRMkEhd6HyeO4A/gPr9Pnj4nnqgRNNEUQMur+5rviz+gB
cxS0JYhnlV0214mvR2h9
=CnfK
-----END PGP SIGNATURE-----

--iRjOs3ViPWHdlw/I--
