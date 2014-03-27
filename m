Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaC0DjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 23:39:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36762 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbaC0DjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 23:39:22 -0400
Date: Wed, 26 Mar 2014 22:37:24 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Hurley <peter@hurleysoftware.com>
CC: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <gregkh@linuxfoundation.org>, <linux-serial@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <m-karicheri2@ti.com>,
        <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/11] Revert "serial: omap: unlock the port lock"
Message-ID: <20140327033724.GB13038@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
 <1395343807-21618-10-git-send-email-balbi@ti.com>
 <20140325182856.GA31906@atomide.com>
 <5333732F.6040803@hurleysoftware.com>
 <20140327021043.GB11651@saruman.home>
 <53338C81.3060600@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oC1+HKm2/end4ao3"
Content-Disposition: inline
In-Reply-To: <53338C81.3060600@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 26, 2014 at 10:27:13PM -0400, Peter Hurley wrote:
> On 03/26/2014 10:10 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Wed, Mar 26, 2014 at 08:39:11PM -0400, Peter Hurley wrote:
> >>On 03/25/2014 02:28 PM, Tony Lindgren wrote:
> >>>* Felipe Balbi <balbi@ti.com> [140320 12:39]:
> >>>>This reverts commit 0324a821029e1f54e7a7f8fed48693cfce42dc0e.
> >>>>
> >>>>That commit tried to fix a deadlock problem when using
> >>>>hci_ldisc, but it turns out the bug was in hci_ldsic
> >>>>all along where it was calling ->write() from within
> >>>>->write_wakeup() callback.
> >>>>
> >>>>The problem is that ->write_wakeup() was called with
> >>>>port lock held and ->write() tried to grab the same
> >>>>port lock.
> >>>
> >>>Should this and the next patch be earlier in the series
> >>>as a fix for the v3.15-rc cycle? Should they be cc: stable
> >>>as well?
> >>
> >>Well, right now the other fix has had _zero_ testing
> >>so not really a -stable candidate just yet.
> >
> >how can you even say that ?
>=20
> I misunderstood when you wrote:
>=20
> On 03/20/2014 02:11 PM, Felipe Balbi wrote:
> > here's a build-tested only patch which is waiting for testing from other
> > colleagues who've got a platform to reproduce the problem:
>=20
> and then the version I reviewed had no Tested-by: tags.

I wouldn't add that tag myself, but Murali (in Cc) did help testing
together with other colleagues.

> >How else would we have found the issue to start with ?
>=20
> Bug report?

touch=E8 :-)

--=20
balbi

--oC1+HKm2/end4ao3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTM5z0AAoJEIaOsuA1yqRE0bsP/iCy3V/lwOh3OUogVRSs6ydK
G6/20Me4nY/LQSanabXL7doAVY3QS7u/A8foiyeDvYplqyXy17F+hddxolenlvaD
5azuIcAiamm4D4T78D7nWZMB6bZ0nhNcEsPcN3u0VHDtyXZwGG40aR4M6dBED+bb
QnpF8w3alnnWGHOfp87dbDAYXbJVBqdozAbhTXs8teFGbfPxfvHuXF+0upt2cPux
yS/PlO1T54H9BE2Wyitx4od28va+9MFre5xAs9ENzPrhzbyYwMtuY55zRahfobID
qrNQvpKTsMhsPc7nHtTrpbNjZoguHVctKDDibsFhSco7Vr3Uct3/vLgUnqWf5pSH
BeDe3bnPf3mQDctXidvzJ531wB6qn5gzRVnm61OagVAYl9hsqqvl2x+W1HtmdBat
atChme2C+g38zizPNc3NW2TUVyHfu1g/soLi6oBu9gMWHOBk5VN7bdJznee2S5Zs
r13UN7mGyYsak0piDDVBEAGCldIqx5PnbIJQN5RHqdwc74Se8Pfw+FsYEYKyctI3
uomzTcQ4NANKOWB13agtz7EprZhicezMx1m7fRNxD6DJ18ic33nCj/0Imw750KqR
ckg17OW+jzrKdISJ/9utvTL8yxdUa1N+4lRBn4rEPtIrnkZCvBqlKHG6UNWwq9y1
vXBBRCzY/IO8zBLsjIVu
=IGOa
-----END PGP SIGNATURE-----

--oC1+HKm2/end4ao3--
