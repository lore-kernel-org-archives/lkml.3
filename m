Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaIPOJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 10:09:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35167 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaIPOJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 10:09:51 -0400
Message-ID: <5418449C.7060808@pengutronix.de>
Date: Tue, 16 Sep 2014 16:09:32 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: Oliver Hartkopp <socketcan@hartkopp.net>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "Christopher R. Baker" <cbaker@rec.ri.cmu.edu>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: can: usb: peak_usb: pcan_usb_core.c:  Cleaning up
 missing null-terminate in conjunction with strncpy
References: <1410715898-15904-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1410715898-15904-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="uAgvDBGiaJiASEu6KDPo4wcV8jQiumRKC"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uAgvDBGiaJiASEu6KDPo4wcV8jQiumRKC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/14/2014 07:31 PM, Rickard Strandqvist wrote:
> Replacing strncpy with strlcpy to avoid strings that lacks null termina=
te.
>=20
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital=
=2Ese>
> ---
>  drivers/net/can/usb/peak_usb/pcan_usb_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net=
/can/usb/peak_usb/pcan_usb_core.c
> index 644e6ab..d4fe8ac 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> @@ -830,7 +830,7 @@ static void peak_usb_disconnect(struct usb_interfac=
e *intf)
>  		char name[IFNAMSIZ];
> =20
>  		dev->state &=3D ~PCAN_USB_STATE_CONNECTED;
> -		strncpy(name, netdev->name, IFNAMSIZ);
> +		strlcpy(name, netdev->name, IFNAMSIZ);
> =20
>  		unregister_netdev(netdev);
>  		free_candev(netdev);
>=20

What about removing the dev_info(), the name array and the str?cpy()
completely?

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--uAgvDBGiaJiASEu6KDPo4wcV8jQiumRKC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlQYRJwACgkQjTAFq1RaXHNFVgCfTa+BDlMUpQkqqLbrm+yAxnKg
0xEAn0XC/whypEq/c1aDdTX0NPFJY/Vu
=yOFv
-----END PGP SIGNATURE-----

--uAgvDBGiaJiASEu6KDPo4wcV8jQiumRKC--
