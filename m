Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab3FTMSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:18:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56167 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3FTMSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:18:17 -0400
Date: Thu, 20 Jun 2013 15:17:49 +0300
From: Felipe Balbi <balbi@ti.com>
To: Chao Xie <xiechao.mail@gmail.com>
CC: Roger Quadros <rogerq@ti.com>, Chao Xie <chao.xie@marvell.com>,
        Alan Stern <stern@rowland.harvard.edu>, "balbi@ti.com" <balbi@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2] USB: initialize or shutdown PHY when add or remove
 host controller
Message-ID: <20130620121749.GF9817@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371609080-30595-1-git-send-email-chao.xie@marvell.com>
 <51C162F9.9020705@ti.com>
 <CADApbej+qcvV2EmcB9g_k=DGp7R-1H_dEaA7StimMoR+G6z0Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BzCohdixPhurzSK4"
Content-Disposition: inline
In-Reply-To: <CADApbej+qcvV2EmcB9g_k=DGp7R-1H_dEaA7StimMoR+G6z0Cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BzCohdixPhurzSK4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 20, 2013 at 08:53:05AM +0800, Chao Xie wrote:
> >> @@ -2674,6 +2693,9 @@ void usb_remove_hcd(struct usb_hcd *hcd)
> >>                       free_irq(hcd->irq, hcd);
> >>       }
> >>
> >> +     if (hcd->phy)
> >> +             usb_phy_shutdown(hcd->phy);
> >> +
> >>       usb_put_dev(hcd->self.root_hub);
> >>       usb_deregister_bus(&hcd->self);
> >>       hcd_buffer_destroy(hcd);
> >>
> >
> > I still think that we shouldn't do this because it adds more confusion =
and is not
> > still a generic enough solution.
> >
> > 1) It is better for the piece of code that does usb_phy_get() to do usb=
_phy_init/shutdown,
> > else there will be lot of confusion. (Felipe pointed this out earlier).
> >
> > 2) There is no standard way of getting phy for different controllers. I=
t is mostly platform
> > dependent and it is best to leave this to the controller drivers. (Poin=
ted out by Alan).
> >
> > 3) Controllers can have multiple PHYs. e.g. ehci-omap has one PHY per p=
ort and it supports
> > 3 ports. This is also platform specific and difficult to handle generic=
ally.
> >
> > 4) Controllers can have specific timing requirements as to when the PHY=
 is initialized relative
> > to the controller being initialized. I've pointed OMAP specific stuff i=
n the earlier patch.
> >
> > Considering all these points, I think we should leave things as they ar=
e. It isn't that hard
> > for controllers to manage phy_init() and phy_shutdown(), and there is n=
ot much code space saved
> > when compared to the complexity it creates if we move them to HCD layer.
> >
> In fact, the PHY setting and handling is related to platform or SOC,
> and for different SOC they can
> have same EHCI HCD but they PHY handling can be different.
> Omap'a case is the example, and i think some other vendors may have
> silimar cases.
> From above point, It is better to leave the PHY initialization and
> shutdown to be done by each echi-xxx driver.
>=20
> So Alan and Felipe
> What are your ideas about it?

If we have so many exceptions, then sure. But eventually, the common
case should be added generically with a flag so that non-generic cases
(like OMAP) can request to handle the PHY by themselves.

Alan ?

--=20
balbi

--BzCohdixPhurzSK4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwvLtAAoJEIaOsuA1yqRELI0P/iD2WneU4bV7ADAUkkttOwuH
s7MNxWS6MzqbCBVHqufh3YStf7XlB6kVJy/oHxeInK2BYdjmovykde8GOmVyncYo
mQCDt0NaLIJNVjHyL9krbQf4y3vqFMdqyIF7LCbUANMtddpRIbuzvWkTcsoi8DhU
FSDfg+DlvwYfVXhcobLT6QkGykK5xNJlpMuzxONNY0LsIP/zAScG1lbjCtHEpXIB
DP2lv2hHW9miPfM6OoWHCFeFhh9rDY5UEgd016fHVU59qqMJWEVkbLrqMjFzGuJa
cQqtTQ/KuHaF20MWiEXnZsnnExsXrS8O2r7a9Gob349H90AkpHje7lKEi+F/U+Cb
BZ3UfkGDeJi436nczvTWjIdilXqE/fZkbcG+9DOsGshFDuXy4z7Co7TDfotPiWfl
q+E71baICgeiQD+GX6MCSTzkgxw4337uIr1BaBXGyCxvhjf/hKhQVDeZpX5fULS3
hZrWJ/zExdh5CpeKW1BUEG3sraAzjqwZC2JXTyszY+eoby3l4BovTEIVLU8m32Zc
mPDHevNmxW6ijvbWB0k3oAL8/KcrjtFKsXMymaWxKKywEcR2ys1lkm+A/eD3ZlkO
jd3ic7TKvl/7tCtemH82RdyBNWyY7lHF1w8VnqVKPg5m34rVj7oALO4CO2QYHTBy
tYM3VXiceA9cqqVWM5Hr
=F+Cm
-----END PGP SIGNATURE-----

--BzCohdixPhurzSK4--
