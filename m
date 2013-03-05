Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab3CEO5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:57:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:55282 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3CEO5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:57:11 -0500
Date: Tue, 5 Mar 2013 16:56:45 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <s-guiriec@ti.com>,
        <gg@slimlogic.co.uk>, <sameo@linux.intel.com>,
        <broonie@opensource.wolfsonmicro.com>, <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/4] usb: dwc3: dwc3-omap: return -EPROBE_DEFER if probe
 has not yet executed
Message-ID: <20130305145645.GG12123@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1362493320-13913-1-git-send-email-kishon@ti.com>
 <1362493320-13913-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="df+09Je9rNq3P+GE"
Content-Disposition: inline
In-Reply-To: <1362493320-13913-3-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--df+09Je9rNq3P+GE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 05, 2013 at 07:51:58PM +0530, Kishon Vijay Abraham I wrote:
> return -EPROBE_DEFER from dwc3_omap_mailbox in dwc3-omap.c, if the probe =
of
> dwc3-omap has not yet been executed or failed.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/dwc3/dwc3-omap.c  |    7 +++++--
>  include/linux/usb/dwc3-omap.h |    6 +++---
>  2 files changed, 8 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> index 19c6e72..9428f4e 100644
> --- a/drivers/usb/dwc3/dwc3-omap.c
> +++ b/drivers/usb/dwc3/dwc3-omap.c
> @@ -138,11 +138,14 @@ static inline void dwc3_omap_writel(void __iomem *b=
ase, u32 offset, u32 value)
>  	writel(value, base + offset);
>  }
> =20
> -void dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
> +int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
>  {
>  	u32			val;
>  	struct dwc3_omap	*omap =3D _omap;
> =20
> +	if (!omap)
> +		return -EPROBE_DEFER;
> +
>  	switch (status) {
>  	case OMAP_DWC3_ID_GROUND:
>  		dev_dbg(omap->dev, "ID GND\n");
> @@ -185,7 +188,7 @@ void dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status =
status)
>  		dev_dbg(omap->dev, "ID float\n");
>  	}
> =20
> -	return;
> +	return IRQ_HANDLED;

IRQ_HANDLED ????

--=20
balbi

--df+09Je9rNq3P+GE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRNgetAAoJEIaOsuA1yqRE+7YP/2TwLfmHDDw6P9y3LyGISIS3
34GgGJLOPO+LORBu/AaAz9w+vjxpkdo17BIMAl5AsfYg6DeZaJF6yO4EA/I2cS0N
0HJhn/7HFyuxzd1zDHAFHthehdVcLf68q+C3VoCwip382Usverbz0EquVlyg2CTm
iXXYFiFaWCG/ZTfVbhBtPeMdSs0Y0m8oAUduaTXOIIgZUNUSfFl447KPe/6obtgG
URjJ/vOQx0RgR75k58mLd97N60jaevVQPRCcvcwtt0+hna0TQNd1SYKixmWjagvu
BO/r0alGUNoJkxtJVg/BB/8zuvpf4ciDZb5X5RuynzlSqtzdVYzQ90iZ04UucdmT
jFpUexGMOhavm5yyewWjFJ3ijuiRzi4iZgyNO7TfArSet4In+C/HaeLycVL70+P7
mLTm4NL3fsC5hHYfYg+DyhgUUa4GS4+SYiL/LOf+CUAwl1LvqfHMjGnWJWOWdMig
9dQVijJTuekPLOXoG5NYX+aKW3W2d9ILqDSgg8M4BLwhQHnydfLtGalbyXJ2n1bT
OP+I++VOiNYEU789418obJzjhFoANbgtKgoDrceT+CTOyEEurnrn+mC5yGuchwE6
greWUtDYheTpkeCDAtOXEbR+Q82OKA+ps1UKUlO9buDINGN1sWLVj6NA3p6JSnvb
Rf9ho/O1Y7dWGrFeKaRn
=5IBN
-----END PGP SIGNATURE-----

--df+09Je9rNq3P+GE--
