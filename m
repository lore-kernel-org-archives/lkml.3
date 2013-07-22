Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab3GVJ3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:29:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57883 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799Ab3GVJ3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:29:15 -0400
Date: Mon, 22 Jul 2013 12:28:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Rong Wang <wr011235813@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Rong.Wang@csr.com>
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
Message-ID: <20130722092854.GG6264@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130718082240.GD11251@arwen.pp.htv.fi>
 <Pine.LNX.4.44L0.1307180946380.1245-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AzNpbZlgThVzWita"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1307180946380.1245-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AzNpbZlgThVzWita
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 18, 2013 at 09:50:37AM -0400, Alan Stern wrote:
> On Thu, 18 Jul 2013, Felipe Balbi wrote:
>=20
> > > > yes. Only the UDC driver knows when the controller is moving among =
those
> > > > states.
> > >=20
> > > Not quite.  Only the gadget driver knows when the transition between=
=20
> > > ADDRESS and CONFIGURED occurs.  This should be added to composite.c.
> >=20
> > that's not entirely true :-) See how we handle that in dwc3:
> >=20
> > | static int dwc3_ep0_set_config(struct dwc3 *dwc, struct usb_ctrlreque=
st *ctrl)
> > | {
> > | 	enum usb_device_state state =3D dwc->gadget.state;
> > | 	u32 cfg;
> > | 	int ret;
> > | 	u32 reg;
> > |=20
> > | 	dwc->start_config_issued =3D false;
> > | 	cfg =3D le16_to_cpu(ctrl->wValue);
> > |=20
> > | 	switch (state) {
> > | 	case USB_STATE_DEFAULT:
> > | 		return -EINVAL;
> > | 		break;
> > |=20
> > | 	case USB_STATE_ADDRESS:
> > | 		ret =3D dwc3_ep0_delegate_req(dwc, ctrl);
> > | 		/* if the cfg matches and the cfg is non zero */
> > | 		if (cfg && (!ret || (ret =3D=3D USB_GADGET_DELAYED_STATUS))) {
> > | 			usb_gadget_set_state(&dwc->gadget,
> > | 					USB_STATE_CONFIGURED);
>=20
> In theory, this should not occur until the gadget driver has finished=20
> the transition to the CONFIGURED state, which doesn't occur until later=
=20
> in the case of USB_GADGET_DELAYED_STATUS.
>=20
> > |=20
> > | 			/*
> > | 			 * Enable transition to U1/U2 state when
> > | 			 * nothing is pending from application.
> > | 			 */
> > | 			reg =3D dwc3_readl(dwc->regs, DWC3_DCTL);
> > | 			reg |=3D (DWC3_DCTL_ACCEPTU1ENA | DWC3_DCTL_ACCEPTU2ENA);
> > | 			dwc3_writel(dwc->regs, DWC3_DCTL, reg);
> > |=20
> > | 			dwc->resize_fifos =3D true;
> > | 			dev_dbg(dwc->dev, "resize fifos flag SET\n");
> > | 		}
> > | 		break;
> > |=20
> > | 	case USB_STATE_CONFIGURED:
> > | 		ret =3D dwc3_ep0_delegate_req(dwc, ctrl);
> > | 		if (!cfg)
> > | 			usb_gadget_set_state(&dwc->gadget,
> > | 					USB_STATE_ADDRESS);
>=20
> No check on the value of ret?  What if the request was rejected?
>=20
> > | 		break;
> > | 	default:
> > | 		ret =3D -EINVAL;
> > | 	}
> > | 	return ret;
> > | }
>=20
> This illustrates the folly of exposing your code to public review.  :-)

it's always good to have extra eyes looking at the code, I'll patch
those up, but since it has always been like that and nobody complained,
I won't tag it for stable.

--=20
balbi

--AzNpbZlgThVzWita
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR7PtWAAoJEIaOsuA1yqREXh8P/1q7+UMeyXKE9chzK9BtqpsM
jq1jDq74a//YJAnPCBG6ayltaov6aa8ZDgxHtrfu3U0FP0OuS0XG/g2ZReiuZHMu
ps0kFHGHDR/cseXMmePKDXFoBnC1Z7wrqfE+Dra9391KkjT8OSMi9N0oesTFx1Eq
AVxbRk+5DG4uqo2pFur1WUSJ0/h1Zg91RV/m07LvSp5cWHZKVI4O39uvL9o0cOiF
x/jDsGKSKDt8Gyu2f7ZB3nGYf4u4HrqQHnZnDDBi+wna0H/hBLUJI+fCJ2TVmjIs
EjhbhNA9crgFXrrr+dmRY3f/apw2RCgBN35OfL5k/OcYmntSJqgJGe7b4Zd3Babf
p9QhF8WvHjpb4a2RTMEhuQo5wsl3I97PK2C4JBh9boR5UfXNmlpkY78OEvgOsmku
WbcqWXDuYy5VtPQ1UYvkZNiQZvsmZ/0awRQMIc57vXZOkrfEKKCtqwZQGkoUCQl9
4xMUlIHPhoosnxuOeyrL2ubiBneCDo6Nbr1ZISuCGCHEg3jtz0OryH4J/D8vW/ar
3j65/10sCUnpJN9MtPOEyS8/lPNaoxi0MZoxDGIcWhw27b8X28AEW35t6JpbPHT2
30XKkaYbMxXkFHafCgnJcazmT5yMGGmSDfN6fLbbKImaaXFnFy2yIKTgytGOU7cJ
+kEseeKPxyoVAo3Z1HKk
=RbHm
-----END PGP SIGNATURE-----

--AzNpbZlgThVzWita--
