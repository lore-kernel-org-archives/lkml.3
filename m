Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab3JMQX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 12:23:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:31603 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab3JMQX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 12:23:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,486,1378882800"; 
   d="asc'?scan'208";a="392373551"
Date: Sun, 13 Oct 2013 21:01:11 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Dan Williams <dan.j.williams@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH] dma: pl330: Support per channel irq allocation
Message-ID: <20131013153111.GN2954@intel.com>
References: <08a752258a021feb91eba25eafd28ea2bacf72e4.1380523844.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="//IivP0gvsAy3Can"
Content-Disposition: inline
In-Reply-To: <08a752258a021feb91eba25eafd28ea2bacf72e4.1380523844.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--//IivP0gvsAy3Can
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2013 at 08:50:48AM +0200, Michal Simek wrote:
> Some pl330 have per channel irq and it is necessary
> to allocate all of them. Loop over irq assigned for this
> device to support these pl330 IPs.
>=20
> For example this IP is available on Xilinx Zynq platform.
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> Hi Vinod,
>=20
> this is the patch I told you about it. I have tested it
> just on Zynq(8 dma channels) but it shouldn't break
> any other pl330 clones.
> One more change has to be done to support all 8 dma channels
> which is to extend AMBA_NR_IRQS which is still 2.
> But I will send separate patch for it directly to Russell.

Thanks, this patch looks fine, Lars can you try testing this if you have th=
is HW
please?

~Vinod
>=20
> Thanks,
> Michal
>=20
> ---
>  drivers/dma/pl330.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 58623dc..96de393 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2922,11 +2922,18 @@ pl330_probe(struct amba_device *adev, const struc=
t amba_id *id)
>=20
>  	amba_set_drvdata(adev, pdmac);
>=20
> -	irq =3D adev->irq[0];
> -	ret =3D devm_request_irq(&adev->dev, irq, pl330_irq_handler, 0,
> -			dev_name(&adev->dev), pi);
> -	if (ret)
> -		return ret;
> +	for (i =3D 0; i <=3D AMBA_NR_IRQS; i++) {
> +		irq =3D adev->irq[i];
> +		if (irq) {
> +			ret =3D devm_request_irq(&adev->dev, irq,
> +					       pl330_irq_handler, 0,
> +					       dev_name(&adev->dev), pi);
> +			if (ret)
> +				return ret;
> +		} else {
> +			break;
> +		}
> +	}
>=20
>  	pi->pcfg.periph_id =3D adev->periphid;
>  	ret =3D pl330_add(pi);
> --
> 1.8.2.3
>=20



--=20

--//IivP0gvsAy3Can
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJSWry/AAoJEHwUBw8lI4NHRxoP/36Yg/6UQjSk6ZfohwOsi9g1
MEuYisMcQscBETxz0IMMpAM1g5hmlz7cS5hICOTVxRTHXN9u17Olgoj5bSzo9RB2
b1sf0Oqa93ggAZSU4RDzPAMbVyBmgwYS5c05HLrtlaITBNMhHpWBXZoU/6qLfgTw
LB6qbzQ7RSG06AIuMuMzvd9QyRqCkyUrZf5Q1lUrKifzD8+17muyDienfn1gOYJQ
NVnzk0HT7UBVsfWSWU0qgim1YhgU99e8BMTsxo+dHUqwSk49sN63YiG+ps4ywa3L
wbwj77nUwmgRAhdDvSXShSagBV00lYwWX+b8ap5TU5s2C2ew7L16ph/ia1UYYfEH
6XBArt6nRbl9/0JEgEfkKJgcbpDMa1IxnuegrID0qaAAOY/4ZatJhic3aQ/YW7Et
NfxETLZTbIzHoKxUByrCKIP5XZb+5O0OIVPDzbiUFYYHrO9KUhcGCr5XZP8c7OMR
gZoTULnySK4IDE+7ehRLzIO+EYjigS5SjMCUorZexAZxfLKdBkZHus7uEAVLBAmA
GRYYtLXBBr32iKhHBROfxM+7pmYA4VEFf4LIG20Z+FD2QQIROk0SHW8bSaBLnSvd
+lJcRSUoDQKB1ns/WKjS8oFwc7SeTEWAj+RkH1zLnhoRt5dieg13wNpLNFWflo9a
mIKrKsKlGkVg+u/68Kfx
=i31y
-----END PGP SIGNATURE-----

--//IivP0gvsAy3Can--
