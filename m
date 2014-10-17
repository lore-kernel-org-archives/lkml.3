Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaJQOya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:54:30 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48986 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbaJQOy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:54:28 -0400
Date: Fri, 17 Oct 2014 09:54:12 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 11/16] usb: dwc3: add delay p1p2p3 quirk
Message-ID: <20141017145412.GG26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-12-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1giRMj6yz/+FOIRq"
Content-Disposition: inline
In-Reply-To: <1413536021-4886-12-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1giRMj6yz/+FOIRq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 17, 2014 at 04:53:36PM +0800, Huang Rui wrote:
> AMD NL needs to delay P0 to P1/P2/P3 request when entering U1/U2/U3.
>=20
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>  drivers/usb/dwc3/core.c          | 3 +++
>  drivers/usb/dwc3/core.h          | 2 ++
>  drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
>  drivers/usb/dwc3/platform_data.h | 1 +
>  4 files changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index ec8b667..a9f1d4c 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -380,6 +380,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
>  	if (dwc->quirks & DWC3_QUIRK_REQP1P2P3)
>  		reg |=3D DWC3_GUSB3PIPECTL_REQP1P2P3;
> =20
> +	if (dwc->quirks & DWC3_QUIRK_DEPP1P2P3)

	if (dwc->delay_p1p2p3_quirk)

> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index 7154d18..23ae6a7 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -152,7 +152,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
>  		dwc3_pdata.quirks |=3D DWC3_QUIRK_AMD_NL
>  			| DWC3_QUIRK_U2EXIT_LFPS
>  			| DWC3_QUIRK_U2SSINP3OK
> -			| DWC3_QUIRK_REQP1P2P3;
> +			| DWC3_QUIRK_REQP1P2P3
> +			| DWC3_QUIRK_DEPP1P2P3;

combined with last patch.

--=20
balbi

--1giRMj6yz/+FOIRq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJUQS2UAAoJEIaOsuA1yqREwgEP9ioMyC3ByGxNphp896PmiXz9
ly+vBwDyUQUUXUtEehi5f93BXSdNNGNNOccH/AOSWyCTFuoAEwFymGMJl6XlF8n0
Fg9jNPiKwsasNEEQwLUcMuNEgz/f4Zq/Ck5oJUYg0P9GETu0oxtCCkE3wIZpAjTR
SbmfZcgq9tkRf5NlTUg/+nMIJTeZuwCO88m4y/OKkDY3RMB8eHrh0Z4zbRn9uTUW
VmI+/1qxc7ZDn8+5QJH3lmziGCGt62oXGqYLbYTOihPsNJmexFAkHDvlk0JQvq+B
lp/6WwyvTpyD+szPKThU2SClNB1at4VdS331HjUPNHZ0+AIoU8u0WHiq6XpuoR+H
4ZGLQBgpy6iiQyFOF+XNv7w/TzalFCh4+YkCJEaHsMQEWdcAqS0NyVwBZNq42Pgw
nvi5riU4kq8wfs4ay9hDPQeHcEr/aeqBEwq27h4jX5m0mO8kEAbuRG+7gB1rTJLD
q4pd2OTgBMnhnQUafpIl8z4EKKmgGa3LsEleRZvyejdAKm5gKpAMvk/qKbqo2IaU
VX034EJ+z91RMi+ZnSZ7QCiopokhuoKz7kTbF3qGsxEUkVI0+aLI2IlReDMC82C3
yVWtBvf2gxTYQ9fElMyQb09ujKugMrIkUd1fITZ5WMXyPbj18+qVEVHelvsTxukW
mCl24kxmtmtDy5nVqv4=
=7vH0
-----END PGP SIGNATURE-----

--1giRMj6yz/+FOIRq--
