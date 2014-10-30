Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbaJ3QjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:39:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53648 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758818AbaJ3QjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:39:12 -0400
Date: Thu, 30 Oct 2014 11:38:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 19/20] usb: dwc3: add support for AMD Nolan platform
Message-ID: <20141030163840.GK10130@saruman>
Reply-To: <balbi@ti.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
 <1414663725-2195-20-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9/GiYV45wF7IL3Iq"
Content-Disposition: inline
In-Reply-To: <1414663725-2195-20-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9/GiYV45wF7IL3Iq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 06:08:44PM +0800, Huang Rui wrote:
> This patch adds support for AMD Nolan (NL) FPGA and SoC platform.
>=20
> Cc: Jason Chang <jason.chang@amd.com>
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>  drivers/usb/dwc3/dwc3-pci.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>=20
> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index ada975f..257fb3f9e 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -145,6 +145,28 @@ static int dwc3_pci_probe(struct pci_dev *pci,
>  	res[1].name	=3D "dwc_usb3";
>  	res[1].flags	=3D IORESOURCE_IRQ;
> =20
> +	if (pci->vendor =3D=3D PCI_VENDOR_ID_AMD &&
> +			pci->device =3D=3D PCI_DEVICE_ID_AMD_NL_USB) {
> +		dwc3_pdata.has_lpm_erratum =3D true;
> +		dwc3_pdata.lpm_nyet_threshold =3D 0xf;
> +
> +		dwc3_pdata.u2exit_lfps_quirk =3D true;
> +		dwc3_pdata.u2ss_inp3_quirk =3D true;
> +		dwc3_pdata.req_p1p2p3_quirk =3D true;
> +		dwc3_pdata.del_p1p2p3_quirk =3D true;
> +		dwc3_pdata.del_phy_power_chg_quirk =3D true;
> +		dwc3_pdata.lfps_filter_quirk =3D true;
> +		dwc3_pdata.rx_detect_poll_quirk =3D true;
> +
> +		dwc3_pdata.tx_de_emphasis_quirk =3D true;
> +		dwc3_pdata.tx_de_emphasis =3D 1;
> +
> +		/* FIXME these quirks should move when AMD NL taps out */

do you mean ?

		/*
		 * FIXME these quirks should be removed when AMD NL
		 * tapes out
		 */

--=20
balbi

--9/GiYV45wF7IL3Iq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUmmQAAoJEIaOsuA1yqREcloQAIYWuyNamu1jTQuS04awCOsW
9sq5zcWdhy64WcUnlWF+KZDuXMaOXEnygbcHmbWh1M+DNX/16NXfa7iQl4srkiFg
uTYCdCvTwskuoH3C0EE2ongP7nlwcYvuX/TvndP1qlndZtqm4vBqYT7gddnJ6S3n
bYjBYGqyb05yS97zn9SZV1HVr5DmP3N17BjapUqqjYFwmcl3P3uAYfsBirTsSQS8
u1P3k4m6UgG1qO+mQZjAoC/JFqELY57A0qGC67ubrZXNSqtUq1MOt5kTMeyOfaJP
QJTOsqBets5pen/FvwXYSWpgZIUL9ZaxV3OfenCYowWzsfXI0pRpmvr78/0R5KbH
zW/AJN6lzEEAA/FAAFp8PvIm15W1/RneyjQ39KWueHLzbf7jTHebI3vOp+bO8nJa
DOv7zkxQAm54FCkpPmvOPyUrjUrJyD7hw0/XilfH9Oz5AzoaUzkUKjAVUWdKq1gc
tS9yIVogHOWhWeW5QumUCqRbO2nItXclHBSlno9fTaJ5jxdCfMY2AUztpPBejdu6
2Bqbonvj5EJgqiyCFpQFfpGMRZB0Is+Da8RHcrQlyNXsC8WoMqRM6CCfHZGVAWEK
z0sf6qsWB8okm3YvR/FE5PyawC+6yhdEe0HwKH5RoXEHrRals+tHawsdjVKm3mD2
2F/gs/Ysl7Gvrrn/wgw+
=x4Sv
-----END PGP SIGNATURE-----

--9/GiYV45wF7IL3Iq--
