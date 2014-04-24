Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbaDXR6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:58:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42405 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757354AbaDXR6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:58:23 -0400
Date: Thu, 24 Apr 2014 12:58:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: <airlied@linux.ie>, <airlied@redhat.com>, <robdclark@gmail.com>,
        <bparrot@ti.com>, <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Darren Etheridge <detheridge@ti.com>
Subject: Re: [PATCH] drm/tilcdc: restore correct display mode and contents on
 pm resume
Message-ID: <20140424175817.GB4659@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393873736-26867-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <1393873736-26867-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2014 at 01:08:56PM -0600, Felipe Balbi wrote:
> From: Darren Etheridge <detheridge@ti.com>
>=20
> On resume the screen contents were not being restored properly.  Looking =
at
> other DRM drivers it seems a call to drm_helper_resume_force_mode() is ne=
eded
> in the resume handler to force restoration of the mode and framebuffer da=
ta.
>=20
> Signed-off-by: Darren Etheridge <detheridge@ti.com>

ping

> ---
>  drivers/gpu/drm/tilcdc/tilcdc_drv.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc=
/tilcdc_drv.c
> index 171a820..1a5ddfa 100644
> --- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
> +++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
> @@ -563,6 +563,13 @@ static int tilcdc_pm_resume(struct device *dev)
>  		if (registers[i].save && (priv->rev >=3D registers[i].rev))
>  			tilcdc_write(ddev, registers[i].reg, priv->saved_register[n++]);
> =20
> +	/*
> +	 * if this call isn't here, the display is blank on return from
> +	 * suspend.  With this call here the contents of the framebuffer
> +	 * during suspend are restored correctly.
> +	 */
> +	drm_helper_resume_force_mode(ddev);
> +
>  	drm_kms_helper_poll_enable(ddev);
> =20
>  	return 0;
> --=20
> 1.9.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWVC5AAoJEIaOsuA1yqREh4UQAJR0uUQmsbIKaDWMvMd5i2OY
q7OOKncL+3lS5VJANzop156iOt2OMo+TUnNS1XOWHHjBDvPCZg2/Mry5RYm/RyfD
B25shnhj/GOXRUS1Dq7ey+WRFtMs8RWiQFd8HRogtcyjLVEh6TuyfMhF3/dwyI5i
6rtUPR8abu+wyHVhHySJsOKNVMLJjMqa+ub/AACQMJfxFiK9MMBTN3WJOdsGgPHE
L3rzX+ga1HX1HdkR4uG4pahiCqIODfhjk5+bMlucn4hpl05maEKQCRZRyHl02KKA
lks4jML4P//lr0gVTflGeRwXtz0ebnSa344G2aMhwFCttxjBBknLiEOwC+V4cfWf
CmYj3diC7vAOWSJSGv0bL8iebXkFC/xz0QE+xZE23UJbRbbRaSlrH3GOw0nUp8EU
xDr7QRGq2Fop5tjh+06aTRG4rbyODRiVVW121oLAD3XTfqCbBpObHF9Kze5secwE
Ag0YHQ6ALowGGRH+SmEdFfPTIyX0YoIynqJzDljRrYSHPDM4zJiGGWFAKXFtebnk
8ygVN63aipMmHXQX/paKKsBJ6kwzHMZrk/WJTXmkiy5WNs+b7fmOlw5Z7adWE65b
B2ZbngU3mCNsgIMSosANKra+ejX/Ram9A/NnTxrecP34UFZu7KSPP/yv6S6OcUdl
megQLwj2OKknEXH2TEsq
=gDQR
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
