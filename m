Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbaBRPyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:54:24 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35708 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbaBRPyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:54:23 -0500
Date: Tue, 18 Feb 2014 09:52:53 -0600
From: Felipe Balbi <balbi@ti.com>
To: Andreas Larsson <andreas@gaisler.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <software@gaisler.com>
Subject: Re: [PATCH 1/6] usb: gadget: gr_udc: Make struct platform_device
 variable name clearer
Message-ID: <20140218155253.GC9878@saruman.home>
Reply-To: <balbi@ti.com>
References: <1389264858-32664-1-git-send-email-andreas@gaisler.com>
 <1389264858-32664-2-git-send-email-andreas@gaisler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GyRA7555PLgSTuth"
Content-Disposition: inline
In-Reply-To: <1389264858-32664-2-git-send-email-andreas@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GyRA7555PLgSTuth
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09, 2014 at 11:54:13AM +0100, Andreas Larsson wrote:
> Rename struct platform_device pointers from ofdev to pdev for clarity.
> Suggested by Mark Rutland.
>=20
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> ---
>  drivers/usb/gadget/gr_udc.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
> index 914cbd8..e66dcf0 100644
> --- a/drivers/usb/gadget/gr_udc.c
> +++ b/drivers/usb/gadget/gr_udc.c
> @@ -2071,9 +2071,9 @@ static int gr_udc_init(struct gr_udc *dev)
>  	return 0;
>  }
> =20
> -static int gr_remove(struct platform_device *ofdev)
> +static int gr_remove(struct platform_device *pdev)
>  {
> -	struct gr_udc *dev =3D dev_get_drvdata(&ofdev->dev);
> +	struct gr_udc *dev =3D dev_get_drvdata(&pdev->dev);

you can use platform_get_drvdata()

> @@ -2083,7 +2083,7 @@ static int gr_remove(struct platform_device *ofdev)
>  	gr_dfs_delete(dev);
>  	if (dev->desc_pool)
>  		dma_pool_destroy(dev->desc_pool);
> -	dev_set_drvdata(&ofdev->dev, NULL);
> +	dev_set_drvdata(&pdev->dev, NULL);

and platform_set_drvdata()

--=20
balbi

--GyRA7555PLgSTuth
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTA4HVAAoJEIaOsuA1yqRESGYP/i/4KsBZ1RqwFvsQnx+YRKSt
uhUFDf4XEiJKjHgiN7a3fqSgjIIVAHGmdn+rUqr7zq5qrIv9n0vQZSDLkX4Zjz/8
DPyEjU01+vbv9/8oyQ/yEfztR53/Y7aTpR6lgamKY1NtnO10LXO59QYdgZw8H3bQ
QNYN1H/Mrk44BK2RDttfUKBxD68KrpIL3yu8dOI4PqiU/w825+2goNPNwCMICabO
MqSzTQ/mkHiq9UUMUHzQG8DYZ+cvB/6Xm6z0DSCczvDfv6iqfNQLBp1XyAnnuC9F
ZRgCk8f5M+WzJQMOkrmNm6qebhZ/JMTWO83/gLQx0s7yeFDlsGYt1/KQbyS0dVAj
ExVO8E8+5asURl9mr9U5IPd9+kmfXblS0PFph2wUdT0T7fqACwqp507rlolzSuQ2
ZQuVcnLlNCQ1sTxMYiYzKBjKBsSVhw9ZAwkZZjxYsFoSYMyN/NfbAK7eG1YjI20s
MF9cJP6zctsZIPxzXpntwt0lCAtvdqVKynpDhE0AQSk+iD97o3nRnnhNyovv8cNN
4c2vwCcku6bWaukEQ11Zkxzf5d+QZmVfrAoq/HM5npybaM7ogG6jEbCyGyD2cEAj
YC9eL6bnMGdTwzujkYsXaslZAMfQeLEymG+1TlF10uxCEwH4P5UOGFnLJbeVMJXK
m5u0BkAmG7H1fr+kcYXB
=gU2Y
-----END PGP SIGNATURE-----

--GyRA7555PLgSTuth--
