Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaKQXFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:05:11 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60878 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaKQXFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:05:07 -0500
Date: Mon, 17 Nov 2014 17:04:30 -0600
From: Felipe Balbi <balbi@ti.com>
To: Andrew Bresticker <abrestic@chromium.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "Kishon Vijay Abraham I" <kishon@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH V5 01/12] xhci: Set shared HCD's hcd_priv in
 xhci_gen_setup
Message-ID: <20141117230430.GA9716@saruman>
Reply-To: <balbi@ti.com>
References: <1416264102-1323-1-git-send-email-abrestic@chromium.org>
 <1416264102-1323-2-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <1416264102-1323-2-git-send-email-abrestic@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2014 at 02:41:31PM -0800, Andrew Bresticker wrote:
> xhci_gen_setup() sets the hcd_priv field for the primary HCD, but not
> for the shared HCD, requiring xHCI host-controller drivers to set it
> between usb_create_shared_hcd() and usb_add_hcd().  There's no reason
> xhci_gen_setup() can't set the shared HCD's hcd_priv as well, so move
> that bit out of the host-controller drivers and into xhci_gen_setup().
>=20
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
> New for v5.
> Peviously posted here: https://lkml.org/lkml/2014/10/30/726
> ---
>  drivers/usb/host/xhci-pci.c  | 5 -----
>  drivers/usb/host/xhci-plat.c | 5 -----
>  drivers/usb/host/xhci.c      | 6 +++---
>  3 files changed, 3 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> index 9a69b1f..31025e4 100644
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -221,11 +221,6 @@ static int xhci_pci_probe(struct pci_dev *dev, const=
 struct pci_device_id *id)
>  		goto dealloc_usb2_hcd;
>  	}
> =20
> -	/* Set the xHCI pointer before xhci_pci_setup() (aka hcd_driver.reset)
> -	 * is called by usb_add_hcd().
> -	 */
> -	*((struct xhci_hcd **) xhci->shared_hcd->hcd_priv) =3D xhci;
> -
>  	retval =3D usb_add_hcd(xhci->shared_hcd, dev->irq,
>  			IRQF_SHARED);
>  	if (retval)
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 3d78b0c..5bc33bc 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -149,11 +149,6 @@ static int xhci_plat_probe(struct platform_device *p=
dev)
>  	if ((node && of_property_read_bool(node, "usb3-lpm-capable")) ||
>  			(pdata && pdata->usb3_lpm_capable))
>  		xhci->quirks |=3D XHCI_LPM_SUPPORT;
> -	/*
> -	 * Set the xHCI pointer before xhci_plat_setup() (aka hcd_driver.reset)
> -	 * is called by usb_add_hcd().
> -	 */
> -	*((struct xhci_hcd **) xhci->shared_hcd->hcd_priv) =3D xhci;
> =20
>  	if (HCC_MAX_PSA(xhci->hcc_params) >=3D 4)
>  		xhci->shared_hcd->can_do_streams =3D 1;
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 2a5d45b..ae05471 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -4843,9 +4843,9 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_qu=
irks_t get_quirks)
>  		 */
>  		hcd->has_tt =3D 1;
>  	} else {
> -		/* xHCI private pointer was set in xhci_pci_probe for the second
> -		 * registered roothub.
> -		 */
> +		xhci =3D hcd_to_xhci(hcd->primary_hcd);
> +		*((struct xhci_hcd **) hcd->hcd_priv) =3D xhci;
> +
>  		return 0;
>  	}
> =20
> --=20
> 2.1.0.rc2.206.gedb03e5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUan7+AAoJEIaOsuA1yqREciQP/ixPr72oNv2rCgUKGo6cMCIm
Qed6uRREzuOpRBY4CKqquLC9lgBAIGdzkh5nIckwaQmTcU4FqRbTaBrMqdg0rWbZ
A7r1zWLkNG5L4oSdlgW8+LPueJt6LyQyxThm+AjB2blBUQG6cbKkq1P1MUUEB32G
JrGu5O3IN139meNjTLJU8UxsVqpJ1gibwI5/g11jtpTOGPg9jYRxiFr3v5YmEuZn
ZFlAFbNh+2Vsft4a1NGVcbN5wORGWzkexe3xMJM9wfFViXeDgx7f0CXupOftSggD
gFwwKBQ9mH9pbqNKY4ppoQ6zm1/JuLsGYGw5ljaEV7YBBWGPjtAr0MTFUNgTxmPD
tfpEi62fvTZiJ3H6j3bXD1FRvxIsMj4bySlZMsH5T8CmhShFZsX/E9GxBJq7WSAx
n8C6OwhP3P8DeBBw/JmOvk9HJPSWp3GBdcA4GBAs2wKarsRyOeTVESG/F6kJ3Ot/
2LEsWm4qDmoH6zEGaxlsXo94qLddU/Kz/regVnRqsGRs5wgJ6Y48bFu7NiYpkdLD
ymcp1YV03FInCoyevFdqdwPC9Uck13cwPTiOoTSyEL6ZFmF1eOMQYTBaFEIuLxn4
4czLcWTv87KYroyr/acIOrk6vBOMcvDHhnU2FbmBw/8CZvPWxwMP6dElyR0wO4yG
eunPuSIjVPVfaAXRAxK+
=VJo1
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
