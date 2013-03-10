Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3CJWuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 18:50:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49470 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3CJWuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 18:50:06 -0400
Date: Sun, 10 Mar 2013 23:49:36 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, swarren@wwwdotorg.org,
        rtc-linux@googlegroups.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] rtc: tegra: use managed rtc_device_register
Message-ID: <20130310224936.GH4743@avionic-0098.mockup.avionic-design.de>
References: <1362852816-13460-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+G3HLlWI7eRTl+h"
Content-Disposition: inline
In-Reply-To: <1362852816-13460-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:eVBw9XtTI3Q+tSQ1WJb4cy4tJ+kTZAFRQkFKqDsbB3T
 zSeFeejpmVAemqIHY27VtWIa9thsXj5/RfrIYQl37DFNJl21St
 15JLMBr5MUSdG6gRRqqL7nhQkDH/1y668j0dGPWwCznLK0TMCX
 qUQTRynW2ulTfImfCEYH65PPENl0ihVXWEAkxBUm5j8ZjuZkbx
 fwUDtsHK2lYzgtGltdROwrpU+/VWDipMr5osC+XaCLS87iWeyQ
 9TygBwd3fB2OCY9FpT6zdTF53dyqf3s88K3rJXJoQZ4M2S3r+V
 eoD1AoabPtlzHPYf6he5AI7zvy9BLjUKkpbML3yB7sip70AT4R
 aVFFpzdVTNd04xagJN4lhENrwvs5Hvvcm9j0Rm8wyXC7S13VwI
 mIeIFRgGfN07hvCP2XnVSOQvEGmVJ5ZFqtsZQ4ZMZ8ciKNtmr3
 JQqIV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+G3HLlWI7eRTl+h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 09, 2013 at 11:43:36PM +0530, Laxman Dewangan wrote:
> Use devm_rtc_device_register for registering rtc device.
> This will reduce the code for unregistering rtc device in
> cleanup path and remove the implementation of remove
> callback of platform driver.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/rtc/rtc-tegra.c |   27 ++++-----------------------
>  1 files changed, 4 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
> index 8186405..1ac8199 100644
> --- a/drivers/rtc/rtc-tegra.c
> +++ b/drivers/rtc/rtc-tegra.c
> @@ -348,13 +348,11 @@ static int __init tegra_rtc_probe(struct platform_d=
evice *pdev)
> =20
>  	device_init_wakeup(&pdev->dev, 1);
> =20
> -	info->rtc_dev =3D rtc_device_register(
> -		pdev->name, &pdev->dev, &tegra_rtc_ops, THIS_MODULE);
> +	info->rtc_dev =3D devm_rtc_device_register(
> +		dev_name(&pdev->dev), &pdev->dev, &tegra_rtc_ops, THIS_MODULE);

The formatting looks weird on this one. For consistency with the rest of
the file it should look like this:

	info->rtc_dev =3D devm_rtc_device_register(dev_name(&pdev->dev),
						 &pdev->dev, &tegra_rtc_ops,
						 THIS_MODULE);

With that fixed:

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--k+G3HLlWI7eRTl+h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRPQ4AAAoJEN0jrNd/PrOh1AAP/Rr19SjdR+R3vGO5DuGpBamR
qe69l7rkeYPXq2fudn7fDVc5xC4k4DlZ/75RGZmyY/tUKG1GU9zTo/vE9kYouAnB
Ysc2aAdMyTXTAHuWxf14VcQbY2H2N5iq1kQuI6ro22LR820CjCa32yRKIFA8tkHc
AMkW2zKMD4t6JolmbWd/5kXgCqhAYUFlqvt6z2PW3/7+FNUMnD6Me9Jnci5co6Wf
iITTJFEsBGO1nckONfO1nHyFqoIklqvqF5EXqkvcCeZL+fzBgCZFCHOt99lXFxiL
+SAgjYSvbV08yPNU+N2yo9KCLCyUJ8BbLlF0++uHQP+WtIDW11zgDZr9cOvFWso7
Qz8k6SPgVsUosNnivgGybziNwQwDVtM19lgCLk8p+pPtJmiu792sOSliT6dG/9h3
KbTxVx0aoEd/5rrb0KtpCD3rcSNBKX7AIVld0iFRRG7DFtwcpAPvMuyMVKDSrFFG
PoPfJrCJjvv/Trv8ZtlQZdvraQsRAkuuGT7T0SGKXxKz1rjURV3UIHPGbFKP1QOf
Gq6LvL3hAbmfIc3qfu26kWADW4K/vywfrIKiPJgdhC7Cixcwavv5d4SLlK9IezdX
UuTWduG2YPO9Uurk3+LB0iTeT/QHsLHeuDuJWJzgtj+Z0dqz1oU8JnP6ULZ6cHJV
e2mY9i+xq2oDTE5XZrwR
=xwtr
-----END PGP SIGNATURE-----

--k+G3HLlWI7eRTl+h--
