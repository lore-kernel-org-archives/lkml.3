Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaHUN4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:56:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56724 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaHUN4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:56:53 -0400
Date: Thu, 21 Aug 2014 08:56:21 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Griffin <peter.griffin@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <maxime.coquelin@st.com>,
        <patrice.chotard@st.com>, <srinivas.kandagatla@gmail.com>,
        <devicetree@vger.kernel.org>, <lee.jones@linaro.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <peppe.cavallaro@st.com>
Subject: Re: [PATCH v4 2/3] usb: dwc3: dwc3-st: Add st-dwc3 devicetree
 bindings documentation
Message-ID: <20140821135620.GD9608@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406734091-16202-1-git-send-email-peter.griffin@linaro.org>
 <1406734091-16202-3-git-send-email-peter.griffin@linaro.org>
 <20140820180005.GU24500@saruman.home>
 <20140821133340.GC17487@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Content-Disposition: inline
In-Reply-To: <20140821133340.GC17487@griffinp-ThinkPad-X1-Carbon-2nd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2014 at 02:33:40PM +0100, Peter Griffin wrote:
> Hi Felipe,
>=20
> Thanks for reviewing, see my comments below: -
>=20
> On Wed, 20 Aug 2014, Felipe Balbi wrote:
>=20
> > > +	dwc3: dwc3@9900000 {
> > > +		compatible	=3D "snps,dwc3";
> > > +		reg		=3D <0x09900000 0x100000>;
> > > +		interrupts	=3D <GIC_SPI 155 IRQ_TYPE_NONE>;
> > > +		dr_mode		=3D "host"
> > > +		usb-phy		=3D <&usb3_phy>;
> > > +		phy-names	=3D "usb2-phy";
> > > +		phys		=3D <&usb2_picophy2>;
> >=20
> > why are you using different binding for usb2 and usb3 phys ? Why can't
> > you just:
> >=20
> > 	phys-names	=3D "usb2-phy", "usb3-phy";
> > 	phys		=3D <&usb2_picophy2>, <&usb3_phy>;
> >=20
> > ??
>=20
> Currently (in the vendor tree) one of the phys lives in
> drivers/usb/phy and the other in drivers/phy.
> I believe that is because one is only a usb phy and the other is a
> multi function phy which can drive PCI-E or USB3.

right, but for mainline, we can have both PHYs in drivers/phy only.

> So to make that work, when dwc3/core.c gets the PHYS in
> dwc3_core_get_phy() we need to use the different bindings.
>=20
> I think we are the only platform using "one of each", but luckily
> dwc3_core_get_phy() has been written generically enough that it "just
> works" :-).

true, but I want to drop support for the legacy drivers/usb/phy layer
=66rom dwc3. I'll try to move all PHYs to drivers/phy for v3.18.

cheers

--=20
balbi

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9fqEAAoJEIaOsuA1yqREOKQP/0KFTFCvTtlcv5iiMGx5d+Wz
LK4xUha5vJ1khKD7OYkHj3IvNsllwwBUp8zU+Qek25V+3CCrMn9kYJFTsaYDInrm
/6PxMhy9iXmIUW5pk4gIUGmBc+kLKZeqZxuYr2u/uSC2OQ+ANpI/fA865kFr6o6k
Rl0sWvEV78xC1e1uWvh7nPSKWIxGDwIQfqjji5BbnvCXuih9MER8MiUaVKVJO8J9
voj1xGsxRbKAil6AnbUAGzVOgoYJwCztLEonNLc5cwsm+WcoNgnSqNI2sZGJJxUV
w922WkTn3Da/ZU9b/BXNm33SaXRISYrZtLHQGO7tAlIP/Bax00EF79MOpb8aEFQ3
iS06mwWDLEWRrh/9Jthay1lxSNauTDy3Lc04AFv/oPILyfX9qdsCcpeXVoE3UbiT
7vfAmfAY2NfRJ84W27R5DERa93inzrTCzWP+BzNQZiCWgA74vHvYhEMLGYZThLTY
1CmN30grdJNTk8qTWrv4Q5AsXs+52kBTO407Liy3vMtn2eKryULghSx9ttiHn4VR
dOWFSGEclrsBOhbKNgSXP1vpM6ZyJZ0e3b8NTbFiZcySsjH2vWo0acPRAYvkrbK6
kyE1+vjNtETeVvbIIOmAc5NMqISXyEgBibyrg8fHIJLwsJmEucBANjZNAsmW92EA
OHl0lAflys3AAS/AYDb3
=QkHf
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
