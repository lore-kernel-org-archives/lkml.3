Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbaEFPkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:40:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34471 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbaEFPkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:40:39 -0400
Date: Tue, 6 May 2014 10:39:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 06/20] usb: host: xhci-plat: Add support for the
 Armada 38x
Message-ID: <20140506153953.GF25849@saruman.home>
Reply-To: <balbi@ti.com>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
 <1399335255-589-7-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iBwuxWUsK/REspAd"
Content-Disposition: inline
In-Reply-To: <1399335255-589-7-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iBwuxWUsK/REspAd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 06, 2014 at 02:14:01AM +0200, Gregory CLEMENT wrote:
> For the Armada 38x SoCs which come with an xhci controller, specific
> initialization must be done during probe related to the MBus windows
> configuration. This patch adds the support of this quirk.
>=20
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/usb/host/Kconfig      |  7 +++++
>  drivers/usb/host/Makefile     |  1 +
>  drivers/usb/host/xhci-mvebu.c | 71 +++++++++++++++++++++++++++++++++++++=
++++++
>  drivers/usb/host/xhci-mvebu.h | 21 +++++++++++++
>  drivers/usb/host/xhci-plat.c  |  6 ++++
>  5 files changed, 106 insertions(+)
>  create mode 100644 drivers/usb/host/xhci-mvebu.c
>  create mode 100644 drivers/usb/host/xhci-mvebu.h
>=20
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 3d9e54062d62..e70943fac4a1 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -29,6 +29,13 @@ if USB_XHCI_HCD
>  config USB_XHCI_PLATFORM
>  	tristate
> =20
> +config USB_XHCI_MVEBU
> +	tristate "xHCI support for Marvell Armada 38x"
> +	select USB_XHCI_PLATFORM
> +	---help---
> +	  Say 'Y' to enable the support for the xHCI host controller
> +	  found in Marvell Armada 38x ARM SOCs.
> +
>  endif # USB_XHCI_HCD
> =20
>  config USB_EHCI_HCD
> diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
> index 7530468c9a4f..7a8db7f7dc01 100644
> --- a/drivers/usb/host/Makefile
> +++ b/drivers/usb/host/Makefile
> @@ -19,6 +19,7 @@ xhci-hcd-$(CONFIG_PCI)	+=3D xhci-pci.o
> =20
>  ifneq ($(CONFIG_USB_XHCI_PLATFORM), )
>  	xhci-hcd-y		+=3D xhci-plat.o
> +	xhci-hcd-$(CONFIG_USB_XHCI_MVEBU)	+=3D xhci-mvebu.o

hmm, this has the potential of resulting in:

	xhci-hcd-m +=3D xhci-mvebu.o

I guess it's best to turn this into:

ifneq ($(CONFIG_USB_XHCI_PLATFORM), )
	xhci-hcd-y +=3D xhci-mvebu.o
endif

no ? Other than this comment:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--iBwuxWUsK/REspAd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTaQJJAAoJEIaOsuA1yqREsJAP/39cmJ8jyTRPtPgR57qyf1l5
M9y3VnAec9Aob6bhhMMm+zhq9nvUoqbLSdNNrmy4f5BDq4KJRV2KpTJN70/E98Au
mlwX0XsEg1bN0ehmIG9hukGPyof/LUBcEy18BZLxeJVgQcKnsGpYRUoQ/rmGAXRK
/7LE37nHnaM0EBxdg/P7drIIUSoK1cxpHy6yKOjfMRdTM4n2m1egrJ1a3wLVNUFS
l0N7wv/d0Oh9zgsAN5Y5Flxvf33A9V/m9iuJ0RDCcWGTqQEKYWI8cDdZlO6OQfud
0A6arl5Oqct3njUry8ZibJRjHtndFdsoS6Zri8WykxIhYxUwcA2VwT23e8Ubo+Dq
L5n92sfVeyqJ15BXWXsw0z2G29Yzhl272fH6yGEUOSuceRZwaI5pkxoqDhAj8VgE
Go3Gpy2cPbGwk0ebXqiO/Tt/G7AgediBkU3NtQF+cbwWAiChWKw4Bg0BBhXTPTgu
A9k2xZz2fn0lFoWiQd5bcTTg3baQ0+TgGd/dy2g/TS5hIjwM45z9ERzDGJtE0omF
iyxiuqMf9alxT/BckGZDkhvUxa9794f7TXxOuAq6MEt+T7JmBOoHM2Fb70RF0RcF
V0gns9CIPRr45Y/Lb+SJRPoaoRVpngbY7lnNCr2sscw6ZtGCxsOkegOAmUhEOjA7
xkV1jCxc27DAex2PZvBs
=y1dE
-----END PGP SIGNATURE-----

--iBwuxWUsK/REspAd--
