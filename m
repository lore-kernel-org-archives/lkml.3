Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3BEJ0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:26:09 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37101 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3BEJ0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:26:05 -0500
Date: Tue, 5 Feb 2013 11:25:54 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 09/30] USB: ehci-omap: Use devm_request_and_ioremap()
Message-ID: <20130205092554.GR32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-10-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5xr6Gr0irOxp3+3c"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-10-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5xr6Gr0irOxp3+3c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:10PM +0200, Roger Quadros wrote:
> Make use of devm_request_and_ioremap() and correct comment.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/host/ehci-omap.c |   19 +++++--------------
>  1 files changed, 5 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
> index 30fc482..fd2f5450 100644
> --- a/drivers/usb/host/ehci-omap.c
> +++ b/drivers/usb/host/ehci-omap.c
> @@ -216,23 +216,17 @@ static int ehci_hcd_omap_probe(struct platform_devi=
ce *pdev)
> =20
>  	res =3D  platform_get_resource_byname(pdev,
>  				IORESOURCE_MEM, "ehci");
> -	if (!res) {
> -		dev_err(dev, "UHH EHCI get resource failed\n");
> -		return -ENODEV;
> -	}
> -
> -	regs =3D ioremap(res->start, resource_size(res));
> +	regs =3D devm_request_and_ioremap(dev, res);
>  	if (!regs) {
> -		dev_err(dev, "UHH EHCI ioremap failed\n");
> -		return -ENOMEM;
> +		dev_err(dev, "Resource request/ioremap failed\n");
> +		return -EADDRNOTAVAIL;
>  	}
> =20
>  	hcd =3D usb_create_hcd(&ehci_omap_hc_driver, dev,
>  			dev_name(dev));
>  	if (!hcd) {
> -		dev_err(dev, "failed to create hcd with err %d\n", ret);
> -		ret =3D -ENOMEM;
> -		goto err_io;
> +		dev_err(dev, "Failed to create HCD\n");
> +		return -ENOMEM;
>  	}
> =20
>  	hcd->rsrc_start =3D res->start;
> @@ -285,8 +279,6 @@ err_pm_runtime:
>  	pm_runtime_put_sync(dev);
>  	usb_put_hcd(hcd);
> =20
> -err_io:
> -	iounmap(regs);
>  	return ret;
>  }
> =20
> @@ -306,7 +298,6 @@ static int ehci_hcd_omap_remove(struct platform_devic=
e *pdev)
> =20
>  	usb_remove_hcd(hcd);
>  	disable_put_regulator(dev->platform_data);
> -	iounmap(hcd->regs);
>  	usb_put_hcd(hcd);
> =20
>  	pm_runtime_put_sync(dev);
> --=20
> 1.7.4.1
>=20

--=20
balbi

--5xr6Gr0irOxp3+3c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENAiAAoJEIaOsuA1yqREzJUP/3rqnwdmz35GOwBIYLQUVjSK
yDR3Eew0vKbDXHhhSInr43O7g1gd2D8CJ5yT3Mbe87P5WF0Iucf8NiGhl6Syy2ZD
S5XqgHsICB+0555hU+AeGz5snz99VjWpmTYdY2fo9QloygH0BZ67gRZnBAF74Ce6
cr/vNOQpLyIw2z16XHTcNvukZi+E8thh3QBYt0plBfBkSMfUfCMnmV88NiNeFMn2
kTp9uP5NadccZPbFvnc12JszaTOFriaSwwb2mKMgAE3Y3tkC716kN8pUKi0/m/3a
oLSvHcmMK4CpbUrj8o8FdKn5Rc7huBtDDlpd0YDPLU7TErg6fSFUcqLdsjLu6LeM
7EolNAZ651gyMGUwWiZ/mKKGz9QdkgdcGx/9iSzcn9OkmJsRnwmDRB5HfaQbJA5l
qyFGbtCI7FN7lM1h7FA0qgSqtEHWFj+0WJ4+5Y96iQxQGuyt3AfpFIcTmzdKmmR/
ggwOLFn4IAXvE0DQR8IKymYOcRq4oBcDCVQ0ON9pr9fIBX0yR5v2Y28Ar0QJOJn9
pnZvss91hoALyKfeeKPvBdE0yogzL1oeb/w6KU2B+HsP2bC9DZt+QMXdcVCNcsPk
ts8rN0uNwscYUS+xvRUxpplD2d19k1lA2gxFGL6KHJbGn0C2uYnbe8ia821obhFA
YFS24KY8UWYTXOghhV+c
=rfk7
-----END PGP SIGNATURE-----

--5xr6Gr0irOxp3+3c--
