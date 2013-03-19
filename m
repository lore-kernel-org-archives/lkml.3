Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969Ab3CSUbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:31:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47430 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757343Ab3CSUbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:31:38 -0400
Message-ID: <1363725088.3937.387.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 45/82] USB: EHCI: dont check DMA values in QH overlays
From: Ben Hutchings <ben@decadent.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 19 Mar 2013 20:31:28 +0000
In-Reply-To: <Pine.LNX.4.44L0.1303191125100.15684-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1303191125100.15684-100000@netrider.rowland.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-id3N8bnucTz6dr/VL5AK"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:5944:e226:2c7e:1b17
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-id3N8bnucTz6dr/VL5AK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-19 at 11:27 -0400, Alan Stern wrote:
> On Tue, 19 Mar 2013, Ben Hutchings wrote:
>=20
> > On Mon, 2013-03-18 at 04:22 +0000, Ben Hutchings wrote:
> > > 3.2-stable review patch.  If anyone has any objections, please let me=
 know.
> > >=20
> > > ------------------
> > >=20
> > > From: Alan Stern <stern@rowland.harvard.edu>
> > >=20
> > > commit feca7746d5d9e84b105a613b7f3b6ad00d327372 upstream.
> > >=20
> > > This patch (as1661) fixes a rather obscure bug in ehci-hcd.  In a
> > > couple of places, the driver compares the DMA address stored in a QH'=
s
> > > overlay region with the address of a particular qTD, in order to see
> > > whether that qTD is the one currently being processed by the hardware=
.
> > > (If it is then the status in the QH's overlay region is more
> > > up-to-date than the status in the qTD, and if it isn't then the
> > > overlay's value needs to be adjusted when the QH is added back to the
> > > active schedule.)
> > >=20
> > > However, DMA address in the overlay region isn't always valid.  It
> > > sometimes will contain a stale value, which may happen by coincidence
> > > to be equal to a qTD's DMA address.  Instead of checking the DMA
> > > address, we should check whether the overlay region is active and
> > > valid.  The patch tests the ACTIVE bit in the overlay, and clears thi=
s
> > > bit when the overlay becomes invalid (which happens when the
> > > currently-executing URB is unlinked).
> > >=20
> > > This is the second part of a fix for the regression reported at:
> > >=20
> > > 	https://bugs.launchpad.net/bugs/1088733
> >=20
> > Alan, the first part (commit 6402c796d3b4 aka as1660) didn't apply and =
I
> > couldn't see how to adapt it for 3.2.  Does this second part have any
> > value without the first?  Or, if you could provide a backport of the
> > first part, that would be very much appreciated.
>=20
> Without the first part, the second part can actually be dangerous. =20
> Under the circumstances, I think it is best to apply neither.

Thanks, I've dropped this.

Ben.

--=20
Ben Hutchings
When you say `I wrote a program that crashed Windows', people just stare ..=
.
and say `Hey, I got those with the system, *for free*'. - Linus Torvalds

--=-id3N8bnucTz6dr/VL5AK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUjLIOe/yOyVhhEJAQpJzxAAsdKsVMdm5z4ya38m/13ezBoV+LGXj7x/
QK4LSKBx+pD69vEXJ3oVt5jfOM+u7cT+eUEVF73yrS8rsR/ILVQNJGPuc4binJfn
PEGw/XryTfVfvBCkxu/nSue7KnfoTt5xwjo/9l7VNP8ekUVMlvrC04Cz0RPVvOOM
o5Dv4+3ggocnzsp34sBljzD5xi/Z4RMLjLUQlqvEbty9BI4EP572byo02zd7R8cy
qjiiXAVbuUQKAQg4G/US+S+YNiz5cqch7Kux0tFCPDpnSSClOwX/oji11abuqNuw
CKATHMnPX6yu1E1Vw6SYFGfw9cPz0ejvq5J1k/I5jQf6rfLfQqhtbUwhNE9Jqk7n
Lg94nnodv44MGip5ZXeKmvgbXA1h0naISkYCs8/uVRqZg2NCtaQKuNSmvgrRygR6
NffJS2FVX/9HHJREuLCTZqtMuzBS+pJ+H2pOLolJpZGEnf4rqsCfTUctvAAPxq7Y
PfIdwrQcQ3UZDyNh3Y0Lali+hikZv8xvZayqa2yGc+j5emsoLuOqxSlOE0LDO98n
3tG/Gbpnn4WjmVNxV8qBc239J6tme7LftfwjZnlJ/BKMNErEDnuGFQ67gKJNA+bV
k71Gl676qYeeWFCqMCFOja9uiGvD2+boxYvBVuvOF6WVLY+R0Qm/PL+k7Yl9Evcy
WyB1jTNXNG8=
=Yurc
-----END PGP SIGNATURE-----

--=-id3N8bnucTz6dr/VL5AK--
