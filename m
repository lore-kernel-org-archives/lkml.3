Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab3FZM0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:26:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55923 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab3FZM0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:26:03 -0400
Date: Wed, 26 Jun 2013 15:25:55 +0300
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH] usb: host: xhci-plat: Enable XHCI_SPURIOUS_SUCCESS quirk
 for xhci-plat
Message-ID: <20130626122555.GE12640@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372237137-17351-1-git-send-email-george.cherian@ti.com>
 <20130626090213.GQ12640@arwen.pp.htv.fi>
 <51CADB9D.3070206@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i6ZTfQE1Row3TVml"
Content-Disposition: inline
In-Reply-To: <51CADB9D.3070206@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--i6ZTfQE1Row3TVml
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 26, 2013 at 05:46:29PM +0530, George Cherian wrote:
> >>@@ -25,6 +25,16 @@ static void xhci_plat_quirks(struct device *dev, str=
uct xhci_hcd *xhci)
> >>  	 * dev struct in order to setup MSI
> >>  	 */
> >>  	xhci->quirks |=3D XHCI_BROKEN_MSI;
> >>+
> >>+	/*
> >>+	 * In some xhci controllers which follows xhci 1.0 spec gives a spuri=
ous
> >>+	 * success event after a short transfer. This quirk will ignore such
> >>+	 * spurious event. Hit this issue in synopsis xhci controllers with
> >>+	 * hci_version > 0.96
> >>+	 */
> >>+
> >>+	if (xhci->hci_version > 0x96)
> >>+		xhci->quirks |=3D XHCI_SPURIOUS_SUCCESS;
> >>  }
> >doesn't look like the correct way to do this. What if enabling that
> >quirk on hosts which don't have the quirk cause problems ?
> For a controller which does not have this issue will never get a
> spurious success for short packet ( and that too for only ISOCH).
>=20
> per this commit ad808333d Intel xhci: Ignore spurious successful event.
>=20
> This spurious successful event behavior isn't technically disallowed by
> the xHCI specification, so make the xHCI driver just ignore the spurious
> completion event.

still we don't want to enable quirks for devices which aren't quirky :-)

Now how Sarah correctly enables the quirk flag only for the known "bad"
Panther Point device.

> >I would suggest adding a platform_data which (in our case) dwc3 will
> >pass to xhci-plat. Then you can do proper revision detection of the
> >synopsys controller and set the quirk only on the failing hosts.
> >
> >BTW, do you have the STARS number for this errata ?
> No STARS number yet.

once we have it, let's make sure to follow what we do on the dwc3 and
list it in a comment. You already that you found the bug with a Synopsys
controller anyway, might as well point to the fact that there is a
ticket with synopsys to track this issue.

cheers

--=20
balbi

--i6ZTfQE1Row3TVml
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyt3TAAoJEIaOsuA1yqREEWsP/Ri7pEcSN6lgGJOdTwh78hVs
2zw089WbBSWavcsF25laRMFnBmVOf1EC7nhR3enpo5sTvb7NDyDtF1s5X/5EFQpZ
mV3hwCzSOrjArRxpva1lNG+qSVEF7/L8BkH2Z5lYDHFntgVkn+hEkOX8P4CELpU4
vlCURMmmuEtZVHYU4NE9Pms1W+Az1MnFvoPdoNclBAlR5mBKZX6U+i0EeIf9nhWa
ij6lFaKPVPHLM3I3QhjK9RpTUoTKKmeENedRFbmknrX7Bh574ar66yQEUYLM36Ex
tJueNGpFfQK3aqHBH+/pmLHIO9U0Sko9V5M7qUs1NNVUhNJ13mDc+iVtRB5HpdpD
kjYpArJ30E/3rmp7NK1IQgtW4n3h7FE3zYCxeECUpjm8XGwr583D+nwfVI5227s8
9SASUifpECfzDsFGCSsqLVEnkJivHHPgP9WlTnZldXrOWHpnE/yo9rYb1HsovTB6
n91H3PeuA/qfa0wU0EtNqufN/SDrsmbW8cnktKyFnBPbC5vOw2Gn15d0Y9ag7+Qq
2nu/l0na9u1s9oEXmWossFrAJ6mNwy+7j09YAGO5o/QRvpKlnS453flbLfwOd2OF
dkK0SsLTRwdN7lZleIbyQs+NZaCNVMdqsL0AX7vdsE67u8HD5TrfaEE5dGfJd0wC
BUYZuCNXGM0QG0D4f/Gv
=lkWq
-----END PGP SIGNATURE-----

--i6ZTfQE1Row3TVml--
