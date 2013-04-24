Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab3DXHMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 03:12:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55767 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab3DXHMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 03:12:03 -0400
Date: Wed, 24 Apr 2013 09:11:57 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Chao Xie <chao.xie@marvell.com>
Cc: linux-kernel@vger.kernel.org, xiechao.mail@gmail.com
Subject: Re: [PATCH V3 3/3] pwm: pxa: add device tree support
Message-ID: <20130424071157.GD1429@avionic-0098.mockup.avionic-design.de>
References: <1366770234-5829-1-git-send-email-chao.xie@marvell.com>
 <1366770234-5829-4-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C+ts3FVlLX8+P6JN"
Content-Disposition: inline
In-Reply-To: <1366770234-5829-4-git-send-email-chao.xie@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:/OSX3szKjPKKLT4mmn9qnJvfAutLTFZof8ovkirkLbO
 jFRaFf2UE2tEKnTRjxIkTeWi0k8A3brKSE5rtJeSegJuO7Cty9
 O9T7A57qlyKInqyMQsMpljknhqxk6hD0TwGXkCpSct4t1HME11
 rKDLX2URYGsbI9C3M0sbpSrpwXRg5gBrwv9nyfjqlwdtBO98e2
 dcoc2tCEtD1BoRz2a28DERJEzWjuKQG78OCD7LRlHK53EzuI0h
 k12AX2CSRNbbg9KCugWKHMelxRLAQR9IuZybh6k/Ldn8ZZLl49
 KieTI/RG1hTUNdrgAz9Q9vf21b/vXzCqpnXMjapPloFCE+MD38
 fZA/+Z8E9lvJ4xuXZkU25y+RVkkb2723bkCrxuKK0JZd3sKUsE
 KKRXi8sq4t5Cf/MSaiEUKJvOdqbcm7Psx0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2013 at 10:23:54PM -0400, Chao Xie wrote:
[...]
> @@ -124,9 +128,52 @@ static struct pwm_ops pxa_pwm_ops =3D {
>  	.owner =3D THIS_MODULE,
>  };
> =20
> -static int pwm_probe(struct platform_device *pdev)
> +static struct of_device_id pxa_pwm_of_match[] =3D {

static const, please.

> +#ifdef CONFIG_OF
> +static int pxa_pwm_parse_data(struct platform_device *pdev,
> +				struct pxa_pwm_chip *pwm)
> +{
> +	const struct of_device_id *of_id =3D
> +			of_match_device(pxa_pwm_of_match, &pdev->dev);
> +	unsigned int npwm;
> +
> +	if (!of_id)
> +		return -ENODEV;
> +
> +	npwm =3D (unsigned int)(of_id->data);

The parentheses around of_id->data are unnecessary.

Thierry

--C+ts3FVlLX8+P6JN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRd4W9AAoJEN0jrNd/PrOh9ZgP/i9HicXVgw7FM/R16PfKYYa0
6eh8DHBkO1z5qdD4MzOJpFis43A0gwQW7YA2LqGraSKWroHnT3jfAbS9wF+fWLkO
F9KnPnGbipiQlrRUuf79j8r72Ulf4Nzpot0ecQXz99zGXp8O2UXqYhU8PAZPYBZg
VgHw90WF0igDcxW0h379bf070WPFwbPBanVllDQOe/0//uGbjfS+FOxs5xC9NSEi
Tw9agpcyg2qlTW2MOVrl505/v3v9xiZaPLLyqK5UHqbTgheQGcSd8dxWWcPyUjyu
ua7/bGeBv0B1tbTP3foJzE3Bi3aZxfbZeJgD8+lUW1N+j2zPJGSRjKmJHXsZbMSQ
liy9Emsj4fKUCfdcWZXXQPU2qnBxrgDtZXyjT2eIuKn6GmyUK4EmXiiZ+SxavmSr
Zcy+lyko7ZMLUPwEf7oGDsKmSFRCFp4D3VuBJnFozfR9JpcQOovQnZU0nC3JSqGx
ZCUV9QoiYeZzorHECWB6K9PdQ3A4Bx10MfO/Aw8ajkmlNYAYrXAmMKkffJ/bOBqu
ahmB28CAy7HLl3cFGVqLTktQdG2d2I+3pQ45Yl4EF+C94xHqj0Cl5NHaCwA5MTpl
F9NWkjuElywoPSf3PM1CFOenvHaRpQ5EqSQnxEC5SFdpCuQjx+t9mxan79P3yHSR
IpDR0a1I5EEmuQathfl8
=55SU
-----END PGP SIGNATURE-----

--C+ts3FVlLX8+P6JN--
