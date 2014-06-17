Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbaFQXhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 19:37:23 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52715 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbaFQXhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 19:37:20 -0400
Date: Wed, 18 Jun 2014 01:37:16 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Dave P Martin <Dave.Martin@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140617233714.GD25525@mithrandir>
References: <1400877395-4235-1-git-send-email-thierry.reding@gmail.com>
 <538757B6.4010109@wwwdotorg.org>
 <20140530073006.GA24748@ulmo>
 <20140530112728.GB3949@e103592.cambridge.arm.com>
 <20140604211237.GC18710@mithrandir>
 <20140616125704.GE16758@arm.com>
 <20140617115829.GB18816@ulmo>
 <20140617121811.GG13808@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5gxpn/Q6ypwruk0T"
Content-Disposition: inline
In-Reply-To: <20140617121811.GG13808@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5gxpn/Q6ypwruk0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2014 at 01:18:11PM +0100, Will Deacon wrote:
> On Tue, Jun 17, 2014 at 12:58:30PM +0100, Thierry Reding wrote:
> > On Mon, Jun 16, 2014 at 01:57:04PM +0100, Will Deacon wrote:
> > > On Wed, Jun 04, 2014 at 10:12:38PM +0100, Thierry Reding wrote:
> > > > It can easily be argued that if the algorithm used to remap the ID
> > > > varies, the compatibility of the device changes. Therefore I would
> > > > expect any variant of the GICv3 that deviates from the "standard"
> > > > mapping (if there is such a thing) to have its own compatible strin=
g.
> > >=20
> > > There is no standard mapping; it's a property defined at system integ=
ration
> > > time. I fully expect different SoCs to do different things here.
> >=20
> > My point was that the mapping itself seems to be fundamental enough to
> > make devices with different mappings "incompatible". Therefore I think
> > this could probably be handled by using different compatible values,
> > something along the lines of this:
> >=20
> > 	compatible =3D "vendor,soc-gicv3", "arm,gicv3";
> >=20
> > Then the mapping can be described in code, which should be a whole lot
> > easier and more flexible than a more or less generic notation in device
> > tree.
>=20
> I don't think that scales well beyond a handful of unique mappings, and I
> really anticipate everybody doing something different based on their
> integration constraints.
>=20
> You'd very quickly end up with sets of tables for each SoC, describing the
> topology and associated IDs in the kernel source, which feels like a giant
> step backwards from where we are today with device tree.

Well, today we don't have a generic binding at all, so anything will
really be a giant step forward in my opinion.

But seriously, from what you said earlier I got the impression that some
of the mappings may not be easy or possible to represent in DT, which is
why I proposed to encode it into the compatible property so that it can
be handled in code instead.

We've had similar discussions before (power sequences anyone?) where we
tried to come up with a generic way to describe something in device tree
that just didn't work out too well. Some things are better done in code,
so I think we should at least consider that possibility rather than
blindly try and force everything into device tree.

Thierry

--5gxpn/Q6ypwruk0T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJToNEqAAoJEN0jrNd/PrOhHfkP/20CokZ/MGSysULm7FBTbZfY
9rpRrhTmEWx4gZxW+m8geyWRYroUsxW+M1EXuRSN/fCAPXHA/5tsYZwvX9HB+lrv
ZzkalhrUzVSStM2IA0dG5VcZCJhe9ZIOIbtWnt3xDhnkBw3PCr4yK6gEww6hcOZX
mfV/cqyqQrkT4b5uZXz4zmcGNyE552b1J0DG837f6OpHnFbsm4Nw9PxttdMetiCF
fh/VDgDWxkYP77Sqn56kBRVonYEPPk3AYeouJ3h9vX3yyUzXlPuISBIQX8jXEmp5
qhK9X2XSn0GRUJh7k2fZh/UYdf7DA+hz00zNdpK3KCm83VBt78GK6p+gE3kUSxkm
pITIFAzqJQWJV5PlwVU0g6uS3JRrvmpkMeKkeKx/NNoiAY9PnAhiJC2thm2DTqHp
+HsMeIyPJpi9fUyR/LmlOpMREIt530mhZhCIBoOWa0iPAZ0B2hEAMTlA+S6iDzQN
pZ8Lpbt4sZwPRk16BAFAaLrIs2ErXGtFccoy6ATImjbF5+8bvEB5udVRU93VTImY
6q1lRRMkE7JwXHtm072uP6xXFVUi1Mbl3JPoS2v57X6NQl6DJjMnaPnai9XVV/AM
VMJlrDNBI/TC+ZaE1wTbk81exJ5HGqpP0WwpVqhblssB5bieQcPC0r/NUCm+wFi0
sQNECjGapTL5xAhbmgmP
=sJ1K
-----END PGP SIGNATURE-----

--5gxpn/Q6ypwruk0T--
