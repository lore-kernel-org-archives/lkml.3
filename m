Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3LSOZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:25:43 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:56292 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab3LSOZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:25:34 -0500
Date: Thu, 19 Dec 2013 15:24:02 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>,
        Arnd Bergmann <arnd@arndb.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Alexey Lugovskoy <lugovskoy@dev.rtsoft.ru>,
        Dmitry Krivoschekov <dkrivoschokov@dev.rtsoft.ru>
Subject: Re: commit e38c0a1f breaks powerpc boards with uli1575 chip
Message-ID: <20131219142400.GA13878@ulmo.nvidia.com>
References: <201312171135.38576@blacky.localdomain>
 <52B1EC15.5070606@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <52B1EC15.5070606@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2013 at 12:40:21PM -0600, Rob Herring wrote:
> [fixed DT maillist address]
>=20
> On 12/17/2013 01:35 AM, Nikita Yushchenko wrote:
> > Hi
> >=20
> > While trying to make freescale p2020ds and  mpc8572ds boards working wi=
th mainline kernel, I faced that commit=20
> > e38c0a1f (Handle #address-cells > 2 specially) breaks things with these=
 boards.
>=20
> Good to see this broke in v3.7 and is just now found...
>=20
> >=20
> > Both these boards have uli1575 chip.
> > Corresponding part in device tree is something like
> >=20
> >                 uli1575@0 {
> >                         reg =3D <0x0 0x0 0x0 0x0 0x0>;
> >                         #size-cells =3D <2>;
> >                         #address-cells =3D <3>;
> >                         ranges =3D <0x2000000 0x0 0x80000000
> >                                   0x2000000 0x0 0x80000000
> >                                   0x0 0x20000000
> >=20
> >                                   0x1000000 0x0 0x0
> >                                   0x1000000 0x0 0x0
> >                                   0x0 0x10000>;
> >                         isa@1e {
> > ...
> >=20
> > I.e. it has #address-cells =3D <3>
> >=20
> >=20
> > With commit e38c0a1f reverted, devices under uli1575 are registered cor=
rectly, e.g. for rtc
> >=20
> > OF: ** translation for device /pcie@ffe09000/pcie@0/uli1575@0/isa@1e/rt=
c@70 **
> > OF: bus is isa (na=3D2, ns=3D1) on /pcie@ffe09000/pcie@0/uli1575@0/isa@=
1e
> > OF: translating address: 00000001 00000070
> > OF: parent bus is default (na=3D3, ns=3D2) on /pcie@ffe09000/pcie@0/uli=
1575@0
> > OF: walking ranges...
> > OF: ISA map, cp=3D0, s=3D1000, da=3D70
> > OF: parent translation for: 01000000 00000000 00000000
> > OF: with offset: 70
> > OF: one level translation: 00000000 00000000 00000070
> > OF: parent bus is pci (na=3D3, ns=3D2) on /pcie@ffe09000/pcie@0
> > OF: walking ranges...
> > OF: default map, cp=3Da0000000, s=3D20000000, da=3D70
> > OF: default map, cp=3D0, s=3D10000, da=3D70
> > OF: parent translation for: 01000000 00000000 00000000
> > OF: with offset: 70
> > OF: one level translation: 01000000 00000000 00000070
> > OF: parent bus is pci (na=3D3, ns=3D2) on /pcie@ffe09000
> > OF: walking ranges...
> > OF: PCI map, cp=3D0, s=3D10000, da=3D70
> > OF: parent translation for: 01000000 00000000 00000000
> > OF: with offset: 70
> > OF: one level translation: 01000000 00000000 00000070
> > OF: parent bus is default (na=3D2, ns=3D2) on /
> > OF: walking ranges...
> > OF: PCI map, cp=3D0, s=3D10000, da=3D70
> > OF: parent translation for: 00000000 ffc10000
> > OF: with offset: 70
> > OF: one level translation: 00000000 ffc10070
> > OF: reached root node
> >=20
> > With commit e38c0a1f in place, address translation fails:
> >=20
> > OF: ** translation for device /pcie@ffe09000/pcie@0/uli1575@0/isa@1e/rt=
c@70 **
> > OF: bus is isa (na=3D2, ns=3D1) on /pcie@ffe09000/pcie@0/uli1575@0/isa@=
1e
> > OF: translating address: 00000001 00000070
> > OF: parent bus is default (na=3D3, ns=3D2) on /pcie@ffe09000/pcie@0/uli=
1575@0
> > OF: walking ranges...
> > OF: ISA map, cp=3D0, s=3D1000, da=3D70
> > OF: parent translation for: 01000000 00000000 00000000
> > OF: with offset: 70
> > OF: one level translation: 00000000 00000000 00000070
> > OF: parent bus is pci (na=3D3, ns=3D2) on /pcie@ffe09000/pcie@0
> > OF: walking ranges...
> > OF: default map, cp=3Da0000000, s=3D20000000, da=3D70
> > OF: default map, cp=3D0, s=3D10000, da=3D70
> > OF: not found !
> >=20
> > Either e38c0a1f should be reverted, or uli1575 (and perhaps other simil=
ar devices) have to be described in device=20
> > trees differently.
>=20
> Reverting would break Tegra PCIe, but you should not have to change the
> DT either. So we need a solution.

We ended up merging a different address representation for Tegra PCIe
and I've confirmed that reverting this commit doesn't cause any obvious
regressions. I think all other drivers in drivers/pci/host ended up
copying what we did on Tegra, so I wouldn't expect any other breakage
either.

Thierry

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSswGAAAoJEN0jrNd/PrOhBwgQAJDizHJfZzFT1RDzdd6TKM28
cR658qJqY+s3bAAz8te+exfItB8iuIIfBujtJVivq2mJsmQvVKJX5TPD4YwCrPKz
Zz7BAx0XmYCoU+e2uhLN5RlFPE25fp+vGB6Py9Ri6wmrx/s5BFJuxwfaMEmrnJRO
WZXIDY2iXx+1/Ysp4fWIMDA6yWSaP5LHeyxW5JUEs1PbDv5lTO9cZhgNiRt3Vl1P
0QB6xIUDJ9KFBrUEy+UVqzlYF3dc4bQyWpMsOeHXAtB1bzToFT4vWbNaWW0FpTbs
GssNqrXRnnmH4RkJJ74CDJKiZ3d4X2mldKJqclGVsIkDKzHzc5DaFzP6sqWHSwGR
UaTyVJaiD+vCQG3HKkBhCResU3DCIdLYPNpkCr93Amgn+0Y0zqsIpTdp8h4aRLnm
8/HNyyJLxbfyFlmOBqymb6t2LPw9JCr/wlqCHW3Q6GwE1iwVbb6Tt3qkxQfd2elZ
PUQNJgizYl612BWAPXSJ9+bhACBjRSqZO8ZDYwjpxq6Muf2thjsTe+xcbjQSoXVZ
Q0IcfY6vHu8+zGSpSc95T9sfQjUksv9AO00qVjX8F2NLYiOOneA9CqHwG+M0QI1U
XnCx/mOXzYNlWhIDwMY18Adlbo39eaqUnB6MYfzAUXweyRtOCOYM5C0oMNqkJqe/
HAVXM6+MoRDDT+jg+OYF
=rrN2
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
