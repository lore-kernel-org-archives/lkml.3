Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbbAWQYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:24:50 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39308 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbbAWQYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:24:47 -0500
Date: Fri, 23 Jan 2015 10:24:43 -0600
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] usb: dwc3: add ULPI interface support
Message-ID: <20150123162443.GH8585@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-7-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TKYYegg/GYAC5JIZ"
Content-Disposition: inline
In-Reply-To: <1422025978-178336-7-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TKYYegg/GYAC5JIZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 23, 2015 at 05:12:56PM +0200, Heikki Krogerus wrote:
> +int dwc3_ulpi_init(struct dwc3 *dwc)
> +{
> +	u32 reg;
> +
> +	/* First check USB2 PHY interface type */
> +	switch (DWC3_GHWPARAMS3_HSPHY_IFC(dwc->hwparams.hwparams3)) {
> +	case DWC3_GHWPARAMS3_HSPHY_IFC_UTMI_ULPI:
> +		/* Select ULPI Interface */
> +		reg =3D dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
> +		reg |=3D DWC3_GUSB2PHYCFG_ULPI_UTMI;
> +		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
> +		/* FALLTHROUGH */
> +	case DWC3_GHWPARAMS3_HSPHY_IFC_ULPI:
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	/* Register the interface */
> +	dwc->ulpi =3D ulpi_register_interface(dwc->dev, &dwc3_ulpi);
> +	if (IS_ERR(dwc->ulpi)) {

so, this will only build and link if DWC3_ULPI is enabled, in case of
error you return early...

> +		dev_err(dwc->dev, "failed to register ULPI interface");
> +		return PTR_ERR(dwc->ulpi);
> +	}
> +
> +	return 0;
> +}
> +
> +void dwc3_ulpi_exit(struct dwc3 *dwc)
> +{
> +	if (dwc->ulpi) {

=2E.. looks like this branch is unnecessary.

--=20
balbi

--TKYYegg/GYAC5JIZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwnXLAAoJEIaOsuA1yqRE9a0P/jOSaBX9ETM7JZ5jm+Tu0Lhe
b0Y0LbCI/tZ3vu4fDcU4ROa4+gASM6tW7kBsYrceOQL6vsixZ2K9QdCjSdmMphL0
w9WImk0103H340jKASe7N4xG0R0/MfdEm+Y5LGYR/Fi0JU+X8Dnoj10h6qry/ecI
8EcmqCu6jUwYK0XK9IBlj9oOCOIIyHPIQemRWOz/eoBF2MgRVTgOV5V/PCIpxQGq
fuxUxqBQNUCt49YM5sx6xVSUqxaAtbTvHv9pfLG4wAvoELjATU4sHY8APNz7719I
EQBHvmkoLXfTazN82Fh6WxigpaC9aNg2YU8R1pDCkyNLX95LF1116Fu/3wUJ04e4
VoyUu1DR5/BpZJWLBkPw8hI5h7lA6J3LsCyuDb6SZTymdb1Le89TqCu7GIDkM+Hb
XORsRuCr9Q5c6FrwpATNMiI+GQQMp8JRWEgdgcAwablx++gW3UOdZ8OdiRTXsY9p
6HSN/cqqRd9r9xj6vqy4g9CXYE5pTQR9StOpeZO/Ls56TDyRy0zplFsz2+sjIYq+
w/fg9omXOoDPutP28Vm1QzqnxJY6ewt6Dvh4bkwtQ0jrFed5ym1JGiW9Zfxylq12
eAT3uQX7YAMoVyhHbKhYcrXL5Nm9FWD28c5/JEgHO51Z+rVxKQZ8LOFEhhdrhwcF
ZjaN9NBjC1WIHW8joQ/i
=WnRn
-----END PGP SIGNATURE-----

--TKYYegg/GYAC5JIZ--
