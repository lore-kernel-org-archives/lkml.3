Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab3BYJTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 04:19:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41302 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758250Ab3BYJTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 04:19:46 -0500
Date: Mon, 25 Feb 2013 11:19:35 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>
Subject: Re: [PATCH RFC] usb: dwc3: Set GCTL.PrtCapDir based on selected mode.
Message-ID: <20130225091935.GF25749@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1360071958-20797-1-git-send-email-gautam.vivek@samsung.com>
 <20130225081723.GD25749@arwen.pp.htv.fi>
 <CAFp+6iHaP96F0OF9_C1DTsfmkPNZMVC78tj7m0YGdV=d_znWrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SxgehGEc6vB0cZwN"
Content-Disposition: inline
In-Reply-To: <CAFp+6iHaP96F0OF9_C1DTsfmkPNZMVC78tj7m0YGdV=d_znWrA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SxgehGEc6vB0cZwN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 25, 2013 at 02:21:46PM +0530, Vivek Gautam wrote:
> >> @@ -514,6 +511,14 @@ static int dwc3_probe(struct platform_device *pde=
v)
> >>       }
> >>       dwc->mode =3D mode;
> >>
> >> +#if IS_ENABLED(CONFIG_USB_DWC3_HOST)
> >> +     dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_HOST);
> >> +#elif IS_ENABLED(CONFIG_USB_DWC3_GADGET)
> >> +     dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_DEVICE);
> >> +#else
> >> +     dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_OTG);
> >> +#endif
> >
> > you can actually use:
> >
> > if (IS_ENABLED(CONFIG_USB_DWC3_HOST))
> >         dwc3_set_mode(dwc...
> > else if (IS_ENABLED( ...
> >         ...
> > else
> >         ...
> >
>=20
> I am actually hoping to change this to something like below (after
> of course changing the preprocessor conditionals) :
>=20
> commit 9a62ed948dcb6ac5d78aff41f5355c0a5ea86475
> Author: Vivek Gautam <gautam.vivek@samsung.com>
> Date:   Thu Jan 24 11:58:05 2013 +0530
>=20
>     usb: dwc3: Set GCTL.PrtCapDir based on selected mode.
>=20
>     Now that machines may select the mode of working of DWC3,
>     we can set the Port capability direction based on selected mode.
>=20
>     Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 79f335f..9444fbe 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -478,7 +478,13 @@ static int dwc3_probe(struct platform_device *pdev)
>                 goto err1;
>         }
>=20
> -       mode =3D DWC3_MODE(dwc->hwparams.hwparams0);
> +#if IS_ENABLED(CONFIG_USB_DWC3_HOST)
> +       mode =3D DWC3_MODE_HOST;
> +#elif IS_ENABLED(CONFIG_USB_DWC3_GADGET)
> +       mode =3D DWC3_MODE_DEVICE;
> +#else
> +       mode =3D DWC3_MODE_DRD;

looks alright.

--=20
balbi

--SxgehGEc6vB0cZwN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRKyynAAoJEIaOsuA1yqREVsAP/3OcdifeAWcDTdq7i9e4hYlT
0nKazxAvZ8zvylNHpoNASTUS4p0XAkE6ZZmfi16nhyb4cL8TR8jRWyPVqFouwXHQ
k+GbVuPeSs2L2wEu2m6a+l+pPMB/bfV7c7HZzGIjBDSwjL6Axhin7wBgcAEvP9fH
QamO2wuKIkUaEL7TqqtCOId6/2/rxT1i1rmt9oFo9UenDU1u5K/ZRuvxw16CcIeZ
CrIBPfkCqLDPcnDk7NQdbeiL55wjaUeK9MUIokvb58KfuK1yKFa3YGRcySo/9045
URvEG4+kwQGtBmOy4Hk/HuKCm6TEbU63qVAXbAZKAbnmK7fMFbkE5BIk4ndLus2r
1bz/6z8BtvZ83pq9tb4KQM1vxRQyliIWYQ1J448w6qbXvmK/DBZzG12gc5RCGtRn
s9AXBWaDTtUxg5bCQEF55HUH+zw0OaHL0eM43n1Gn7nUgiGVk/6B0Gz26mvAd9AA
nuhTX5KTaYDvsROqbHNV9nFRRor1vrmlqfyGO8BT6qQUaSbEcDb8M+KNCx39OGrc
jSYvHbQdF0QHHj7/YNZo1ZjJerYiIpRIGaNB+AjXjqRJbwU4xSbcF50hkKsfDVxt
Zigq9dFrjO6kJlnA7k5FFyUBcxCcJZmYhdYZUpBOTn2LTqAaxKSJmSRQOM6fc7Ld
+yPXGdmBqcbc6YGzgEfs
=xHQ1
-----END PGP SIGNATURE-----

--SxgehGEc6vB0cZwN--
