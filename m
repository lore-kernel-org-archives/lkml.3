Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbbAZTfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:35:38 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46844 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbbAZTff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:35:35 -0500
Date: Mon, 26 Jan 2015 13:35:28 -0600
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] usb: dwc3: add ULPI interface support
Message-ID: <20150126193528.GF6660@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-7-git-send-email-heikki.krogerus@linux.intel.com>
 <20150123162443.GH8585@saruman.tx.rr.com>
 <20150126114610.GA28539@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cpvLTH7QU4gwfq3S"
Content-Disposition: inline
In-Reply-To: <20150126114610.GA28539@kuha.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cpvLTH7QU4gwfq3S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 26, 2015 at 01:46:10PM +0200, Heikki Krogerus wrote:
> On Fri, Jan 23, 2015 at 10:24:43AM -0600, Felipe Balbi wrote:
> > On Fri, Jan 23, 2015 at 05:12:56PM +0200, Heikki Krogerus wrote:
> > > +int dwc3_ulpi_init(struct dwc3 *dwc)
> > > +{
> > > +	u32 reg;
> > > +
> > > +	/* First check USB2 PHY interface type */
> > > +	switch (DWC3_GHWPARAMS3_HSPHY_IFC(dwc->hwparams.hwparams3)) {
> > > +	case DWC3_GHWPARAMS3_HSPHY_IFC_UTMI_ULPI:
> > > +		/* Select ULPI Interface */
> > > +		reg =3D dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
> > > +		reg |=3D DWC3_GUSB2PHYCFG_ULPI_UTMI;
> > > +		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
> > > +		/* FALLTHROUGH */
> > > +	case DWC3_GHWPARAMS3_HSPHY_IFC_ULPI:
> > > +		break;
> > > +	default:
> > > +		return 0;
> > > +	}
> > > +
> > > +	/* Register the interface */
> > > +	dwc->ulpi =3D ulpi_register_interface(dwc->dev, &dwc3_ulpi);
> > > +	if (IS_ERR(dwc->ulpi)) {
> >=20
> > so, this will only build and link if DWC3_ULPI is enabled, in case of
> > error you return early...
> >=20
> > > +		dev_err(dwc->dev, "failed to register ULPI interface");
> > > +		return PTR_ERR(dwc->ulpi);
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +void dwc3_ulpi_exit(struct dwc3 *dwc)
> > > +{
> > > +	if (dwc->ulpi) {
> >=20
> > ... looks like this branch is unnecessary.
>=20
> We can't do that, or distros that select DWC3_ULPI option can only use
> dwc3 with hardware that really has ULPI PHY. So I guess we'll drop the
> DWC3_ULPI option and build the dwc3 ulpi support always if ULPI bus is
> enabled. OK?

look at your patch again. In case DWC3_ULPI isn't enabled, this file
won't be linked at all. You're using stubs, so taht's fine.

In case it _is_ enabled, you're breaking out early if you can't register
ulpi interface, meaning you're exitting probe() (which, in fact, seems
wrong as I want to be able to run dwc3 with ULPI enabled on a platform
that was configured with ULPI+UTMI, but uses UTMI PHY).

I still think this patch won't work in all cases.

--=20
balbi

--cpvLTH7QU4gwfq3S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxpcAAAoJEIaOsuA1yqRELZ0P/3phqSqLMBrEL3gn9i3JI4cN
vLMpjkMq/anGmt71uYwHmkzbylIfYc9dH5QEwgEsMX7nZhxP/CFbeu97B24Wd+/6
CVAAS9utUXEV/hFeZ4sxKDEoM3dwyB0PpkYHS0bI0z6+p4O027IH9+BnkyCATHrX
wfaqrrHw0AWV0yy/1AZzZ7/0uM2JGxuhVGjhchclYGmekkEZ/tRlneEATIl0jAXO
JCsqWrlnW5ISR4OPGldkoyRxrqF2sCdsFEzXPd1Ti8dyGNphoqvoKg1kO6AvklIn
PUxpOhyXjad9Rj6V3JfYAoudz2i1rZP+os9cqrze/UJ4xbeo4A6fOiLW0mZjvBfL
QRzPYxCERPe+yuiBfiRRo5vOWPL0es6YdNnbezRXmtP7Wx9OaAYErOk8hPejHg6x
IX4szyhIQ07nZ51B+pUc8DEY7E8k/XhSxe4BDtdbrUKIUzWPLi8xQR7ZLdyjwVYa
B5QXPrB3p3/qYxaldWClsbT3NELfYPyVLcHBI7ySaxLtet+yXDV/OgCWRyMEIFXf
JgjeAmEms1WOljWJTHlX9/zDAuHzs6dprqFhc7BFzL/Nw5onqzzrj9Ic3tWGT4GH
/7keA/Ty6cacyPi6DTiguCG3tLkjq7/1FmOi7W7qAQO/3sxXbXjSIte/qlchdZ0/
jGDn7Nvu2YiAicsmWw+t
=jn17
-----END PGP SIGNATURE-----

--cpvLTH7QU4gwfq3S--
