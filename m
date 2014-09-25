Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaIYHzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:55:15 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:52388 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaIYHzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:55:12 -0400
Date: Thu, 25 Sep 2014 09:55:09 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: hachyang@gmail.com
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ryang <ryang@hach.com>, Nikolaus Voss <n.voss@weinmann-emt.de>
Subject: Re: [PATCH 1/1] PWM-atmel: Fixed a bug which set the pwm clock
 prescaler incorrectly. In the defect code the prescaler was always one more
 than expected value, which resulted in the pwm output with wrong frequency
 and duty cycle.
Message-ID: <20140925075508.GB11843@ulmo>
References: <1410384919-41303-1-git-send-email-ryang@hach.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <1410384919-41303-1-git-send-email-ryang@hach.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2014 at 03:35:19PM -0600, hachyang@gmail.com wrote:
> From: ryang <ryang@hach.com>
>=20
> Signed-off-by: ryang <ryang@hach.com>
> ---
>  drivers/pwm/pwm-atmel.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
> index 6e700a5..2dca0bf 100644
> --- a/drivers/pwm/pwm-atmel.c
> +++ b/drivers/pwm/pwm-atmel.c
> @@ -128,7 +128,8 @@ static int atmel_pwm_config(struct pwm_chip *chip, st=
ruct pwm_device *pwm,
>  			return -EINVAL;
>  		}
>  	}
> -
> +	/* Need to reduce the prescaler by 1 */
> +	pres--;
>  	/* Calculate the duty cycles */
>  	prd =3D div;
>  	div *=3D duty_ns;
> --=20
> 1.9.1

I think this was fixed by a different patch by Nikolaus in a more direct
way, see: https://lkml.org/lkml/2014/9/24/28

I've pushed that patch to the for-next branch of the PWM tree. Can you
verify that the issue you were seeing is gone?

Thierry

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUI8pcAAoJEN0jrNd/PrOh+OwQALGSQB07KaYP/0qgVVHzAFbg
wX++lMeo+XVW4Jp2PEixLLsLK2C3/65btup+nTRDvtOno85xCnrKnyNvs30bUSyW
xUZggPU9HVG9C1g+ON/Sj9YZbody3AgALlwxi3n/PbFPPWpUsciD1MMVVaCbMgdL
MAXsAOXvWbXWx/DYpA70QXle63oaffewBV9bdgvJYwgEnjh9bB23yI+ekMHFtnrh
rVXVzzbH/8/sF8btx+s+sXhGRrXVW8cKS7JulgqdeV9pIAZjn5bPGHXezRgJ9nl8
E/TnDbjk/kG6w73C/LwflTOoSTy8CBy3tUOErXAHTjPV1vPtnQ4O1w/HFcJRBs/p
aG+RMWetKrLY2WgJYChRUCD9UcMQ1GHXAjQ/0XShW0GjTBU67J0i1e7jSExkQPp7
VR79+EqnIKs3x+S1VxvPREUNDpS7uv+S5CS+2rk3HwznEuZL0XBZo4+zHggw/4f8
k8mkiYnc9s/2mTjygqrep3Z0cl4YCMPr8DZ/6TqEBaCqWqVuUA5V5BHJAaa0W30c
nPKuLn/1LgeCeOpuy13wX3E01nLjsQZjUK4KLLj6QWmlbiUjCwL6+panHd81an2q
XD9l0MiZZu1Ik7KouFOSnCy3koOBir9T52bSG4YpNxOZbarenUCKxGmhoUDfAy6s
L5O4PE5XHn3qeB2tmzP2
=KDV+
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
