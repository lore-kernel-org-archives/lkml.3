Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaJQOxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:53:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48931 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbaJQOxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:53:41 -0400
Date: Fri, 17 Oct 2014 09:53:25 -0500
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
Subject: Re: [PATCH v2 10/16] usb: dwc3: add request p1p2p3 quirk
Message-ID: <20141017145325.GF26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-11-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V4b9U9vrdWczvw78"
Content-Disposition: inline
In-Reply-To: <1413536021-4886-11-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--V4b9U9vrdWczvw78
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2014 at 04:53:35PM +0800, Huang Rui wrote:
> AMD NL needs to enable always request P1/P2/P3 for U1/U2/U3 for AMD own p=
hy.
>=20
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>  drivers/usb/dwc3/core.c          | 3 +++
>  drivers/usb/dwc3/core.h          | 1 +
>  drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
>  drivers/usb/dwc3/platform_data.h | 1 +
>  4 files changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 9d0a249..ec8b667 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -377,6 +377,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
>  	if (dwc->quirks & DWC3_QUIRK_U2SSINP3OK)
>  		reg |=3D DWC3_GUSB3PIPECTL_U2SSINP3OK;
> =20
> +	if (dwc->quirks & DWC3_QUIRK_REQP1P2P3)

	if (dwc->request_p1p2p3_quirk)

> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index 1235eb3..7154d18 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -151,7 +151,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
>  		dwc3_pdata.has_lpm_erratum =3D true;
>  		dwc3_pdata.quirks |=3D DWC3_QUIRK_AMD_NL
>  			| DWC3_QUIRK_U2EXIT_LFPS
> -			| DWC3_QUIRK_U2SSINP3OK;
> +			| DWC3_QUIRK_U2SSINP3OK
> +			| DWC3_QUIRK_REQP1P2P3;

to be combined with the last patch in this series.

--=20
balbi

--V4b9U9vrdWczvw78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQS1lAAoJEIaOsuA1yqREvy4QAKzRs4UqXWseG48ICi3EyKHr
HnOLePDdpCppx0qx8oqwaqE0TN55oItxtSeNIhqG5CM1Dl7jLT6fkSNFX94S04EU
klGNa2CZJYuPjXmDR3aRk7rJ4qO4bGzddmoo6n3RXnJC5aWwU7oT9LnifjeSGVW8
LR8zaj1SLyd5Few7Go41A3NLF3ftBXDIVRI1pfgQA76b0KL9oD0InVORDJYBSZHl
igMf9d9oYtPknMQ81NrSCCRJMFQobC2HjtozLc+i/haO5Sc3sVxe3cADktZMtwat
rkToj3m7o5SGmIKcWrZQfE8u4GVyaSSP6zB95Kf1IBIMs+sMLO2axP3Gpl+oZik4
3ERa47Rq1SowWFje2laPtcrIl5lWtsn6jY5yywClkWlX0g4QEC2X3BYFS7hHXyHt
ZEbP+UnALkQXf7rBYWWzSUesonLWUrHzfru01rxVENlbkUqvxn2P5LIPIu+i6oZr
Tx44P2Crj5NHw82I1dEOtIOeKxREbH86O61qnWZ/XRMaiQySvj2Qt86TJxNFwt1L
IyPIBusLWn6qNScodHZvNnKMtTQ71WzBu/QCsGc58Vu4CGg6eCB6wXNCYClumMhj
9AryK+uua0vOQQKstLevo0KdLVr3Q6ZMKJdD1myMJSB4U04OQx3CExJsyry05poq
ji+dS8JdVGcgUDMPOgJW
=ySw0
-----END PGP SIGNATURE-----

--V4b9U9vrdWczvw78--
