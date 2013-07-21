Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3GUGfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 02:35:44 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:38682 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3GUGfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 02:35:43 -0400
Date: Sun, 21 Jul 2013 08:35:34 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Huang Shijie <b32955@freescale.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of: match the compatible in the order set by the dts file
Message-ID: <20130721063531.GA16516@mithrandir>
References: <1373013818-11365-1-git-send-email-b32955@freescale.com>
 <20130709070541.GQ516@pengutronix.de>
 <51DBBFDA.70302@freescale.com>
 <20130709075124.GR516@pengutronix.de>
 <51DBC58D.90002@freescale.com>
 <20130720054439.308B33E13F0@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <20130720054439.308B33E13F0@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 20, 2013 at 06:44:39AM +0100, Grant Likely wrote:
> On Tue, 9 Jul 2013 16:10:53 +0800, Huang Shijie <b32955@freescale.com> wr=
ote:
> > =E4=BA=8E 2013=E5=B9=B407=E6=9C=8809=E6=97=A5 15:51, Sascha Hauer =E5=
=86=99=E9=81=93:
> > > On Tue, Jul 09, 2013 at 03:46:34PM +0800, Huang Shijie wrote:
> > >> =E4=BA=8E 2013=E5=B9=B407=E6=9C=8809=E6=97=A5 15:05, Sascha Hauer =
=E5=86=99=E9=81=93:
> > >>> Why don't you set the matching order in the driver the way you want=
 it
> > >>> to be, i.e.:
> > >>>
> > >>> 	{ .compatible =3D "fsl,imx6q-uart", ... },
> > >>> 	{ .compatible =3D "fsl,imx21-uart", ... },
> > >>> 	{ .compatible =3D "fsl,imx1-uart", ... },
> > >>>
> > >> yes. i can set it like this.
> > >>
> > >> but this method looks like a ugly workaround.
> > > If a driver has different ways of supporting a single device, then
> > > putting the preferred or most feature rich on top doesn't look very u=
gly
> > > to me.
> > this method makes it much _coupled_ between the driver and the dts file.
> >=20
> > IMHO, it's an unnecessary _burden_ to the driver programmer:
> >     he should puts the most feature compatible on the top.
> >=20
> > it's much graceful if we let the driver programmer be transparent about=
=20
> > this.
>=20
> Absolutely true. Applied, thanks.

I don't think this will work. The patch looks very similar to one that I
posted about a year ago (commit 107a84e "of: match by compatible
property first"). The problem it was trying to address was exactly the
same. However the patch caused regressions on SPARC and had to be
reverted in commit bc51b0c "Revert "of: match by compatible property
first"".

The revert commit quotes Rob having a fix for this, and I remember that
I pinged him about it occasionally, but I suspect that those must have
fallen through the cracks.

Grant, before applying this patch we should make sure that it doesn't
cause a regression again, so perhaps asking Meelis Roos (mentioned in
the revert commit) to test would be good. I have a strong feeling that
this patch will break in the same way than mine did a year ago, because
it looks too similar and doesn't handle the compatible & name
combination that Rob mentioned.

Thierry

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR64EzAAoJEN0jrNd/PrOhUTYP/im+mJwerQCqIngwmkWkfEvs
cbyQ9HYr/mmNaMkFSBfRJ8oTFT6srbfPR3us7bkk//OCGjX9tJmZN8N9TX7QNIPi
eO/MPS0asNoBC+38WyIFH3fJe4McN4Q1kWQpkRsf/RdkCU1/YlO7ecqS0710fe5a
qcVEYk4ouAgflfA2IlY+wYcLOrd6CmWbMF1EBa9q5/tEOxyruy7XiSu3GMzrkkt6
u0peEvNbi6NWK4gcztHZxS2A6c39V56OTCJaNUl/CeedgpVlfvdOQiKX85Jrbvar
urtq9Vsb1Zb4vSCZtBgF+lssZkwctRd4MHeSjLUpjwLq4ux9WCrLqZ3JyrzUvIrC
A6Z8aPECzm80V2yQellHNeQ8eYCVgBl5ts8Yu+wirJC7F8Kxlxc4o1fG/DkR8FYe
RTw3BKcnuQiSUN0XlvXTyKVSIJgfTPaRBNDNKEfTlAicNWEJekW8hOZoVTEj7RAZ
SjGV4Ju9FXG+JeBonUBTNnqT90AlusakcBbvB+TqWd1oicOVjYSwq5aSjJe7eBF4
HS3WFjZLGE5ERvYt7FxJpenjB6lITd8LGcy3x21MGOKW1laTWPoXOOZnNfPzq+fO
ZRR41a0V3jF+Hitg9RVwTKuC9K4oMXFfkqAMZ6Fgs2exjWSlm9Kkf0of7BUSdmt0
464UhbRh74NId4ltslee
=S00a
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
