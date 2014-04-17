Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaDQPbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:31:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50698 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaDQPbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:31:08 -0400
Date: Thu, 17 Apr 2014 10:28:51 -0500
From: Felipe Balbi <balbi@ti.com>
To: Suresh Gupta <suresh.gupta@freescale.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Suresh Gupta <B42813@freescale.com>
Subject: Re: [PATCH v2] usb: gadget: fsl: Set dma_ops for FSL USB Gadget
 Device
Message-ID: <20140417152851.GA22861@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395347209-22480-1-git-send-email-suresh.gupta@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <1395347209-22480-1-git-send-email-suresh.gupta@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 21, 2014 at 01:56:49AM +0530, Suresh Gupta wrote:
> From: Suresh Gupta <B42813@freescale.com>
>=20
> DMA mapping functions are moved to common place in udc_core.c
> which expect the DMA operation of gadget device
>=20
> Signed-off-by: Suresh Gupta <B42813@freescale.com>
> ---
> Changes from previous version:
> * Added description
>=20
>  drivers/usb/gadget/fsl_udc_core.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_u=
dc_core.c
> index d68aa77..35cb972 100644
> --- a/drivers/usb/gadget/fsl_udc_core.c
> +++ b/drivers/usb/gadget/fsl_udc_core.c
> @@ -2456,6 +2456,7 @@ static int __init fsl_udc_probe(struct platform_dev=
ice *pdev)
>  	/* Setup gadget.dev and register with kernel */
>  	dev_set_name(&udc_controller->gadget.dev, "gadget");
>  	udc_controller->gadget.dev.of_node =3D pdev->dev.of_node;
> +	set_dma_ops(&udc_controller->gadget.dev, pdev->dev.archdata.dma_ops);

I'm still not convinced this is the best thing to do in a driver.
set_dma_ops() isn't even exposed on include/linux/ and no other driver
tries to call it. This is really something that should be done at arch
level.

Perhaps send a note to lakml and see if anybody has a better idea ?

cheers

--=20
balbi

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTT/MyAAoJEIaOsuA1yqRESt8QAKIIudXhePd9YTmQm5fZQ1rz
uqAvE0jO73QTfm/mJy/WdnsVkMOVhi3ezuiv5rtkKTv9SKKQAIimqbsL5UECWHEH
kJeO12Nr858f8T3jPyqMud9zre7FHWp2TrhINzycALphLzeFQA4YFPMInFLjusSu
pRbNybWgjG1X30INCZgsFPjUYpRtnmKH+3L2f+B8uR1sJxGK8hVwy4gzRAk1cEoc
3afFRdjTuL5s2QplQofOE57jedvIODtDlJzGv+dCPJQgto7IAvL79/RMaCisxLgl
Bro1bHxFC3Ww6B0l26rAqKGuKV8unV7NwU03gXooXn5m85dBCSwQI0j6puE6eRPZ
sh+fsK5IUJunDJ3fEb+kgNop54bIbvVIoYR2igwqwKbIQ1ygKguAYnyTSvVVAudI
TU1/Xl8S8MRzrBQksy0EkO0xLo7B6u2MKupqD4+Oso2LffPR+evfnN+pJ2xogFZO
eo94gezFwtI0OCOB7PntkvWwW5E3mcXUH5P3Eb5xl77FLHfZ8ECSyM37Pbu4s2de
6xBaa7VdtKkyhRzTs1fsHcmU72vm+KNEbPNLZ47jzDjQk71I/9Tf5Gft9+lniX3X
T++4RWweaScZz04cFeCcCD1XHQqyN9Hz/FczD+ngb+wmGSOErLjsi76Q/IlQhg2/
ucwsv4QrwiZ+DpiltWIr
=fFGy
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
