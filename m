Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3J3Rg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:36:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43139 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab3J3RgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:36:25 -0400
Date: Wed, 30 Oct 2013 12:36:51 -0500
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: David Cohen <david.a.cohen@linux.intel.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Paul.Zimmerman@synopsys.com>
Subject: Re: [PATCH v3 1/3] usb: gadget: add quirk_ep_out_aligned_size field
 to struct usb_gadget
Message-ID: <20131030173651.GQ12193@gimli>
Reply-To: <balbi@ti.com>
References: <1383152778-30739-2-git-send-email-david.a.cohen@linux.intel.com>
 <Pine.LNX.4.44L0.1310301329350.1312-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SWsnvgFfkTS2ATo5"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1310301329350.1312-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SWsnvgFfkTS2ATo5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2013 at 01:31:50PM -0400, Alan Stern wrote:
> On Wed, 30 Oct 2013, David Cohen wrote:
>=20
> > Due to USB controllers may have different restrictions, usb gadget layer
> > needs to provide a generic way to inform gadget functions to complain
> > with non-standard requirements.
> >=20
> > This patch adds 'quirk_ep_out_aligned_size' field to struct usb_gadget
> > to inform when controller's epout requires buffer size to be aligned to
> > MaxPacketSize.
> >=20
> > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > ---
> >  include/linux/usb/gadget.h | 3 +++
> >  1 file changed, 3 insertions(+)
> >=20
> > diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> > index 942ef5e..9405d0f 100644
> > --- a/include/linux/usb/gadget.h
> > +++ b/include/linux/usb/gadget.h
> > @@ -540,6 +540,9 @@ struct usb_gadget {
> >  	struct device			dev;
> >  	unsigned			out_epnum;
> >  	unsigned			in_epnum;
> > +
> > +	/* epout requires buffer size to be aligned to MaxPacketSize */
> > +	unsigned			quirk_ep_out_aligned_size:1;
> >  };
> >  #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))
>=20
> Instead of adding this new bitflag to the end of the structure, where=20
> it will cause the structure to grow by at least 4 bytes, why not add it=
=20
> in the middle, along with all the other bitflags, where it won't cause=20
> any change in the structure's size?
>=20
> If you prefer, you can move the name, dev, out_epnum, and in_epnum=20
> fields higher up, so that the bitflags come last.

I'd prefer moving the fields and having all bit-fields, last. Thanks

--=20
balbi

--SWsnvgFfkTS2ATo5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJScUOyAAoJEIaOsuA1yqREjEYP/3xLvgvUyaZkPkUmSeL4aZRN
e+cQsUfKloCwhXsDoJxFjxn2+F9rKRxs/78Zx8q1oip7wW+ejmytfiiBAOnIUzmu
IhXFcp0yTsB+qjtVqZ5FCGW/OkXWRn59wx8tBXmVD8uG+KAbnekN4W46AM6RtPtx
kHk0nGAstvaUGw+ZLotasFO8e5lF88KvDWBU3NI6lAymQXF/gWcGri9wWmpZi4pJ
t2a4a/umrS/8zo9yzK+4t3cBBhLXrHhoH2j454rC1VBhzhjatO/DZlgS36u0W7wS
MaRH36hVeiFfOk9X2xXAdtTYONoS0hk1SJLVVHrPzoi39hd1n/4YKPQR52Da7m1Y
WESAfWT9bMgo8d1jlhjCO42N94IXAxCfpwnRNWHEMohOTlS0XvCHrXLb0G4XpYGO
YrCSLIdoMhzv4w2PT29pRWJckUAxF6KQm4kjkA57A1qZUskPq07iqdbu/8Yzcq8V
nOMatWwzhgW5LhwJdcKxoGvsOWe+qH0IFkjjIcO6AZwoTfzmuGtwouH5HAw6YjBN
2QBGFZmTbJbMNA85RxbqffsD+NmuYMVrZWFbRBNsl4cAytZY5VLNWv4pHlHMzf5b
cXO8XYaG8ZZ8s0dVfyJTJT/VYeeldVy7jdZQ7FaM4z7juum0cuqhMDC6BVWOYbVe
ucXrVwLyEAtcZgYtBiC5
=qYNG
-----END PGP SIGNATURE-----

--SWsnvgFfkTS2ATo5--
