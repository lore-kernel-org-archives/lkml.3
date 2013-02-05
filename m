Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab3BEJO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:14:29 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36610 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab3BEJOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:14:24 -0500
Date: Tue, 5 Feb 2013 11:14:12 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 02/30] usb: phy: nop: use devm_kzalloc()
Message-ID: <20130205091412.GK32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-3-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mPOSj6iWmtyhwOMz"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-3-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mPOSj6iWmtyhwOMz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:03PM +0200, Roger Quadros wrote:
> Use resource managed kzalloc.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---

Acked-by: Felipe Balbi <balbi@ti.com>

>  drivers/usb/otg/nop-usb-xceiv.c |   16 ++++------------
>  1 files changed, 4 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xc=
eiv.c
> index a3ce24b..7ffb0c8 100644
> --- a/drivers/usb/otg/nop-usb-xceiv.c
> +++ b/drivers/usb/otg/nop-usb-xceiv.c
> @@ -100,15 +100,13 @@ static int nop_usb_xceiv_probe(struct platform_devi=
ce *pdev)
>  	enum usb_phy_type	type =3D USB_PHY_TYPE_USB2;
>  	int err;
> =20
> -	nop =3D kzalloc(sizeof *nop, GFP_KERNEL);
> +	nop =3D devm_kzalloc(&pdev->dev, sizeof *nop, GFP_KERNEL);
>  	if (!nop)
>  		return -ENOMEM;
> =20
> -	nop->phy.otg =3D kzalloc(sizeof *nop->phy.otg, GFP_KERNEL);
> -	if (!nop->phy.otg) {
> -		kfree(nop);
> +	nop->phy.otg =3D devm_kzalloc(&pdev->dev, sizeof *nop->phy.otg, GFP_KER=
NEL);
> +	if (!nop->phy.otg)
>  		return -ENOMEM;
> -	}
> =20
>  	if (pdata)
>  		type =3D pdata->type;
> @@ -127,7 +125,7 @@ static int nop_usb_xceiv_probe(struct platform_device=
 *pdev)
>  	if (err) {
>  		dev_err(&pdev->dev, "can't register transceiver, err: %d\n",
>  			err);
> -		goto exit;
> +		return err;
>  	}
> =20
>  	platform_set_drvdata(pdev, nop);
> @@ -135,10 +133,6 @@ static int nop_usb_xceiv_probe(struct platform_devic=
e *pdev)
>  	ATOMIC_INIT_NOTIFIER_HEAD(&nop->phy.notifier);
> =20
>  	return 0;
> -exit:
> -	kfree(nop->phy.otg);
> -	kfree(nop);
> -	return err;
>  }
> =20
>  static int nop_usb_xceiv_remove(struct platform_device *pdev)
> @@ -148,8 +142,6 @@ static int nop_usb_xceiv_remove(struct platform_devic=
e *pdev)
>  	usb_remove_phy(&nop->phy);
> =20
>  	platform_set_drvdata(pdev, NULL);
> -	kfree(nop->phy.otg);
> -	kfree(nop);
> =20
>  	return 0;
>  }
> --=20
> 1.7.4.1
>=20

--=20
balbi

--mPOSj6iWmtyhwOMz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREM1jAAoJEIaOsuA1yqREHhQQAKeYF7jzHYEMq+zZNdWeBJkC
aJfpdW3zJHciLLCOcimDVuzpAjq8X6+4IP4cFtxa9glK9UHp07bQh8Cg1fw42lBX
eiWnn5mSxrEh3od8KjlCfPWlzRAPMTHQsLFg9aXCLbdLBpqivx6coXgXV3sAmMNc
vSLEnd5j5qnFwcBmgFaDLZP2SKmcBF4D04s6U0DdfdluKAs1GSfM8u1JV/VVPfQJ
MluMuloq8YTD/ljhDGbrcGM88yRHPTobOA8ASBxqI6MyeO+1mqIJBBo1lG2B+K3p
WsiGQXOcAtpJyA1GCiO9ONfGiMiQJQj8wRJVv3JMqsdAnTOsoDu8PLK7WotEkGTw
+HY530hIgY4SnzdAl7d94o4fmyZ4Kq009QoXbeKN2wb2JigmbJA7qFFev+BnPHBa
85/qx/9J02VcSVrNjYj0M+N/4mWPfuj/UtIT+BJcwS/ke7gCFIXk92UDslEf4acj
7lAyzTxcn/jPC3GmvvKOf+6FBln6jySj8nBcFcL3WN93aSVLTKjsvXgGKhclAYd/
IrEq3CIlGYYJ/jdsMmt4eKEJngOPOmc/HrbqPqc97J5oCrbVpfp9Lz1BDxTol5lY
CprmxFzFDmHzkmn+JrrTPiCoFBzDLTxiaID9ILirWdgBfSQLhvHHbhP/wT0QHoNd
2WoSNswIbTwQRtPvVnqP
=WH7C
-----END PGP SIGNATURE-----

--mPOSj6iWmtyhwOMz--
