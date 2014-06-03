Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbaFCNKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:10:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46060 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752670AbaFCNKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:10:04 -0400
Date: Tue, 3 Jun 2014 15:09:38 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        lgirdwood@gmail.com, lee.jones@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH 0/5] regulator: Enhance AXP209 DT support
Message-ID: <20140603130938.GI27722@lukather>
References: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140528184752.GA22488@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tBhgiDt8dP1efIIJ"
Content-Disposition: inline
In-Reply-To: <20140528184752.GA22488@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tBhgiDt8dP1efIIJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 07:47:52PM +0100, Mark Brown wrote:
> On Wed, May 28, 2014 at 07:11:04PM +0200, Maxime Ripard wrote:
>=20
> > This patchset modifies the regulator core and axp209 regulator driver
> > to be able to set in each regulators sub-node the supply, that should
> > be possible, given that it's documented as such in the bindings, but
>=20
> It is?  We should fix that.

=46rom Documentation/devicetree/bindings/regulator/regulator.txt:

  - <name>-supply: phandle to the parent supply/regulator node

With the example:

    xyzreg: regulator@0 {
        regulator-min-microvolt =3D <1000000>;
        regulator-max-microvolt =3D <2500000>;
        regulator-always-on;
        vin-supply =3D <&vin>;
    };

If not right, then it's strongly misleading.

>=20
> > is not at the moment, since whenever looking up the supply in the DT,
> > of_get_regulator will always look into the parent's device of_node
> > pointer.
>=20
> > This leads to a common pattern accross the regulators to have multiple
> > supply in the main device node, while it would be more intuitive yet
> > follow the documented bindings to look into the regulator sub-nodes
> > first.
>=20
> No, we've been round this loop several times before.  This reduces
> consistency in how we map supplies since the user has to work out which
> subnode the supply is associated with and what it's called there instead
> of being able to just look at the schematic and translate the supply
> name into a property name.  It also means you have to map supplies into
> multiple child nodes if the same supply is used in multiple places.

Which might be what your schematics actually show. If you have a
single input pin for each regulator, even if the name changes from one
pin to another, you're still pretty much in this kind of construct.

> The idea is that supplies that happen to be used to supply a regulator
> don't get treated any differently to any other supply and that we do
> that at the physical package level.

In our case, each regulator found in the PMIC has an input of its own,
which is a very similar setup than the one found in a gpio-controlled
regulator for example.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--tBhgiDt8dP1efIIJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTjckSAAoJEBx+YmzsjxAgJTMQAMMI1gYY1GBYO1J4vgY/aEYz
BrjYSZVRLdgexRvvkHVSpxyUQ39RaZZTF4kRM6eWIiAi1JjZVEq2JkPWgRqqQf3a
sEVkUjL7ve4EvpfgqlyT8r9DR8WvpQ8FglMA2xRF1sAWIs4Q9UE06oopwziaj3dd
Jxch8cIWLipH7IW76bMSmrVxnyFIiKkSmVeg9Ov4yFAV5Cd/vz0fD92J7CtsRYrq
HRf/C88pZ0MGb5vifMNFdnhOcGQGbPErUDmUFaEXUcg33hKcrtfWr6mdBq3yPda9
b8wwYMWI0GDh1ZcXkCh7oH5PllBj3e4TeGTispGPTnAMffcZHyQW1HGNy+40yO5v
bOBmJMSqfNFAYnrsW54zLLel5MMNNqj4MIJ/RQbxVZeYS9zBXMdXrGfzuKTsMnPi
xdBy+fww9kMj7D1MF54m5Z0sRMAXYGzOQno74KR+7EgOTOy0DVrvqWF38z0uSCzb
1dKNZMD8joj4pfEQF+QdgxRzb45WWYme6JSK5BabnX2gXE6EdlwV0El9qI9fqD1S
nA2AovPRiM3aHTxR4acJOYyWhEac4/XVG68jSqj6ra/mbivlx4E8PdtJnq3E/Uj5
1a6sfVWRlmv/Zapf7vsVYDLECUkmjMMt2B3p8ZoMf+xgrm0GuEW2yg1BRCU6yMXa
6G+8t8x2yxRqd5Bs2QnY
=qzL4
-----END PGP SIGNATURE-----

--tBhgiDt8dP1efIIJ--
