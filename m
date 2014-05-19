Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaESUck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:32:40 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:42613 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaESUch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:32:37 -0400
Date: Mon, 19 May 2014 22:32:33 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140519203232.GD30737@mithrandir>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
 <4391809.OTRCiJQXS4@wuerfel>
 <20140519125336.GA9466@ulmo>
 <20140519172113.GA13858@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
Content-Disposition: inline
In-Reply-To: <20140519172113.GA13858@e103592.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 06:22:31PM +0100, Dave Martin wrote:
> On Mon, May 19, 2014 at 01:53:37PM +0100, Thierry Reding wrote:
[...]
> > My understanding here is mostly based on the OpenFirmware working group
> > proposal for the dma-ranges property[0]. I'll give another example to
> > try and clarify how I had imagined this to work:
> >=20
> > 	/ {
> > 		#address-cells =3D <2>;
> > 		#size-cells =3D <2>;
> >=20
> > 		iommu {
> > 			/*
> > 			 * This is somewhat unusual (or maybe not) in that we
> > 			 * need 2 cells to represent the size of an address
> > 			 * space that is 32 bits long.
> > 			 */
> > 			#address-cells =3D <1>;
> > 			#size-cells =3D <2>;
> >=20
> > 			#iommu-cells =3D <1>;
> > 		};
> >=20
> > 		master {
> > 			iommus =3D <&/iommu 42>;
>=20
> Comparing this with the other discussion thread, we have a similar
> concept here, in that the iommu is made a logical parent, however...
>=20
> Firstly, there's an implicit assumption here that the only kind of
> thing the master could possibly be connected to is an IOMMU, with
> no non-trivial interconnect in between.  I'm not sure this is going
> to scale to complex SoCs.

Here we go again. We're now in the very same bad spot that we've been in
so many times before. There are at least two SoCs that we know do not
require anything fancy, yet we're blocking adding support for those use
cases because we think that at some point some IOMMU may require more
than that. But at the same time it seems like we don't have enough data
about what exactly that is, so we keep speculating. At this rate we're
making it impossible to get a reasonable feature set supported upstream.

That's very frustrating.

> If a range of Stream IDs may be issued (especially from something like
> a PCIe RC where the stream ID may be a many-bit value), describing
> the IDs individually may be impractical.

The IOMMU specifier is completely specific to the IOMMU. If an IOMMU has
a need to represent the stream IDs as a range there's nothing keeping it
=66rom defining the specifier accordingly.

Thierry

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTempgAAoJEN0jrNd/PrOh49UQAJaXjkkOPMxasxWoF9dWXyYC
/sF7hp4FG3rp2tJokX5tEtEd9/GM1SSSqYWcoHv1I6Hmhn3WHGiJCQwWYBjxheHW
ftSQsqKvai99taKs+kZH0MEg/4MbReA13bk6HJvIuftxl+KyPhAYxtIJu/ewAIro
CZcMBbVpMg4UF2yDkB9VtjVTnRy2OdgbHwfsh73Dcr129Ultm380uf5X3MSJ9Z/B
FYxiVFmQV+JGD2UzCg6cdOURdlY/xI7/UJ1AowXzhfBw/HJJ0hXHHYF4hwdhyo2f
OVqjb1wv6v6uWPqny9uiyX1HDM6nMkDRkTnXPue/jYkI8+MWkdXghNzCv5XofY8K
ncjo5Iew2SGV9bM7qrrGEPNCex9SojATzNdBxhGMRJcUkzXx/LU6XiHxc52FJdX0
glREVlhzMcU51IG03CbJIISJJ6eNgypSocdLYBgjzI7V0uELRc0Pb2SdPjwmdumU
BTQnTIEm9TIz+Jz6t5oH9/URkv5n9L57KOAusWi/Snzgu3SVnwoJwLBQVoEhfL3e
gl6i8Xz1mdOSeQm79SkPmC8o4817HvC9RQT6LJEJdAJBab2tI/r4zwZqw6uBDU6M
LUiccDtUYzTF9h14ZKLvgmvY0v0LVZCYb7aDSoOBD2Q3xgCFiXXzj479lrvF3O/b
6gqRHs5qDXwVP7jTlOm2
=SkCa
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
