Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3HLN2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:28:34 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:44269 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab3HLN2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:28:30 -0400
Message-ID: <5208E2EC.8050106@monstr.eu>
Date: Mon, 12 Aug 2013 15:28:12 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: David Miller <davem@davemloft.net>, michal.simek@xilinx.com,
        renner@efe-gmbh.de, Greg KH <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 7/8] net: xilinx_emaclite: use platform_{get,set}_drvdata()
References: <5208E22C.4090101@huawei.com>
In-Reply-To: <5208E22C.4090101@huawei.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="KUDqQuPKPGUVCDmomxEaLrrq30iKQO0fu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KUDqQuPKPGUVCDmomxEaLrrq30iKQO0fu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/12/2013 03:25 PM, Libo Chen wrote:
>=20
> Use the wrapper functions for getting and setting the driver data using=

> platform_device instead of using dev_{get,set}_drvdata() with &pdev->de=
v,
> so we can directly pass a struct platform_device.
>=20
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/ne=
t/ethernet/xilinx/xilinx_emaclite.c
> index fd4dbda..4c619ea 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> @@ -1230,8 +1230,7 @@ error:
>   */
>  static int xemaclite_of_remove(struct platform_device *of_dev)
>  {
> -	struct device *dev =3D &of_dev->dev;
> -	struct net_device *ndev =3D dev_get_drvdata(dev);
> +	struct net_device *ndev =3D platform_get_drvdata(of_dev);
>=20
>  	struct net_local *lp =3D netdev_priv(ndev);
>=20
> @@ -1250,7 +1249,6 @@ static int xemaclite_of_remove(struct platform_de=
vice *of_dev)
>  	lp->phy_node =3D NULL;
>=20
>  	xemaclite_remove_ndev(ndev, of_dev);
> -	dev_set_drvdata(dev, NULL);
>=20
>  	return 0;
>  }
>=20

Acked-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--KUDqQuPKPGUVCDmomxEaLrrq30iKQO0fu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlII4u0ACgkQykllyylKDCGMwgCeIqpETSseY5FO1pvWk382rjF5
IkkAoJq8g9oE3mH/AlV7neMwv9n6m9hq
=Ojw7
-----END PGP SIGNATURE-----

--KUDqQuPKPGUVCDmomxEaLrrq30iKQO0fu--
