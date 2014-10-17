Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaJQO40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:56:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49526 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbaJQO4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:56:25 -0400
Date: Fri, 17 Oct 2014 09:56:06 -0500
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
Subject: Re: [PATCH v2 12/16] usb: dwc3: add delay phy power change quirk
Message-ID: <20141017145606.GH26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-13-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X+8siUETKMkW99st"
Content-Disposition: inline
In-Reply-To: <1413536021-4886-13-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--X+8siUETKMkW99st
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 17, 2014 at 04:53:37PM +0800, Huang Rui wrote:
> AMD NL needs to delay PHY power change from P0 to P1/P2/P3 when link state
> changing from U0 to U1/U2/U3 respectively.
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
> index a9f1d4c..920a8ab 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -383,6 +383,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
>  	if (dwc->quirks & DWC3_QUIRK_DEPP1P2P3)
>  		reg |=3D DWC3_GUSB3PIPECTL_DEP1P2P3(1);
> =20
> +	if (dwc->quirks & DWC3_QUIRK_DEPOCHANGE)

	if (dwc->delay_p0_change_quirk)

> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index 23ae6a7..0eb8b2a 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -153,7 +153,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
>  			| DWC3_QUIRK_U2EXIT_LFPS
>  			| DWC3_QUIRK_U2SSINP3OK
>  			| DWC3_QUIRK_REQP1P2P3
> -			| DWC3_QUIRK_DEPP1P2P3;
> +			| DWC3_QUIRK_DEPP1P2P3
> +			| DWC3_QUIRK_DEPOCHANGE;

combined with the last patch

--=20
balbi

--X+8siUETKMkW99st
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQS4GAAoJEIaOsuA1yqREONIQAIk26JDdrIJKrU/heF2zvPIe
hTD9Mu3BPNLXMi1+joSBh0kbYkk6k9ZB7vcMuBBrD0s71wRVZ3jX7a26WCwf06IR
/+/LGVPf0x3weUwvy8/B0jxF9JT70kshlDTNdg064GDRDkmAMOGGwmiJ6Tyvidyz
kLU11R8BGkfI0o2J7EiJSkPfxXGIoptDK4fRzkJARemxZe49y6NpM90CZvqXU+rf
9BSbXzxH7uv/4wUSzjLrEYmtMf5OmuG9vj88ZXk7MgE/miL8b9I9v7bNw5J2Cqa7
TN7zywe53HZtjW65FyTcAI2Tayz6rQ1q0BxmaZiekVijmpR9BNhZt9PEC9h0vAvv
9yk1iH37Z6lQuxNyhUQsxK0uOAH+s8VILJbkfeQk7W/6claNSrpX9rfWIYdXyKvy
vP9SaxpoSF/tGup1dtLTkNgbpTh5ge6WPSDnSVTg/LDKP+vcx2Zlsj01riCO1vtQ
maDinGQQsDpELw36ebxMvu0OZhLs4PhbPdwAqZe65IIFk6kMZPmQ1HjStsxVRdby
YtorT7WyPTYdo+pUeD8CNOXr1lPvSn3tdtAVmLo4yGgaYZDMKapCK75DtSb0WxJr
VNxrWI//p04eqV9aEz8PeuBxuBarjv+k1nErDezqAEA1jTXj+wd8KNLyHHhrCFq/
4rtEnDgwjJFdUXKgODZb
=pTmI
-----END PGP SIGNATURE-----

--X+8siUETKMkW99st--
