Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaFDNq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:46:56 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:55166 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaFDNqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:46:53 -0400
Date: Wed, 4 Jun 2014 15:44:03 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Hiroshi Doyu <hdoyu@nvidia.com>, Rob Herring <robherring2@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140604134400.GE28484@ulmo>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com>
 <4545972.cM7IP1qTXQ@wuerfel>
 <87tx87rrp2.fsf@nvidia.com>
 <4462924.8iRbdkOPp7@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CGDBiGfvSTbxKZlW"
Content-Disposition: inline
In-Reply-To: <4462924.8iRbdkOPp7@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CGDBiGfvSTbxKZlW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 09:54:37PM +0200, Arnd Bergmann wrote:
> On Friday 30 May 2014 22:29:13 Hiroshi Doyu wrote:
> >=20
> > IIUC the original problem, "a master with 8 streamIDs" means something
> > like below, where some devices have multiple IDs but some have a
> > single. A sinle #address-cells cannot afford those 2 masters at once.
> >=20
> >        iommu {
> >                /* the specifier represents the ID of the master */
> >                #address-cells =3D <1>;
> >                #size-cells =3D <0>;
> >        };
> >=20
> >         master@a {
> >                 ...
> >                 iommus =3D <&smmu 1 2 3>; # 3 IDs
> >         };
> >=20
> >         master@b {
> >                 ...
> >                 iommus =3D <&smmu 4>;     # 1 ID
> >         };
>=20
> This would not be the usual format really. It should instead be
>=20
> 		iommus =3D <&smmu 1>, <&smmu 2>, <&smmu 3>;
>=20
> which can be tedious to type.

"Tedious to type" doesn't sound like a good argument to me. I don't see
why the above would necessarily be a bad notation. It's very much up to
the point and very explicit. This very obviously translates to:

	This device has three master interfaces, one for smmu ID 1, one
	for smmu ID 2 and one for smmu ID 3.

> > Tegra,SMMU has a similar problem and we have used a fixed size bitmap(64
> > bit) to afford 64 stream IDs so that a single device can hold multiple
> > IDs. If we apply the same bitmap to the above exmaple:
> >=20
> >        iommu {
> >                /* the specifier represents the ID of the master */
> >                #address-cells =3D <1>;
> >                #size-cells =3D <0>;
> >        };
> >=20
> >         master@a {
> >                 ...
> >                 iommus =3D <&smmu (BIT(1) | BIT(2) | BIT(3))>; # IDs 1 =
2 3
> >         };
> >=20
> >         master@b {
> >                 ...
> >                 iommus =3D <&smmu BIT(4)>;     # ID 4
> >         };
> >=20
> > The disadvantage of this is that this limits the max number of streamIDs
> > to support. If # of streamID is increased later more than 64, this
> > format cannot cover any more. You have to predict the max # of streamIDs
> > in advance if steamID is statically assigned.
> >=20
>=20
> Well, the iommu specific binding could allow a variable #address-cells.
> That way, you just need to know the number of stream IDs for that instance
> of the iommu.

That sounds fairly complicated to me. I don't see what that buys us over
the clarity and simplicity that the above explicit notation gives us. Is
it not more common for a device to have a single master rather than a
whole bunch of them?

Thierry

--CGDBiGfvSTbxKZlW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjyKgAAoJEN0jrNd/PrOhRf0P/jdz3bs4397dj00jpuTF0eui
kUsbd22FEgEawxAlThmni8hxaNNVqsdd3lbyacsApRFBWDH3dujaFo6QEUNbiue8
qB4IsNbXNFDScgotMlY8Q64tVfU5ulA/3XOBFnuuwAkB1gNo1u1vP5vzShx9sXtJ
1Sj4/8ZcCO248bVgmYp6TtgPV6kQqSVSMe89XrTFGY78ZTXG1KQlsZkVmw6PHBe5
HJBe0/yRTH2KtHHKm8/nWDYcYgBWwkHelmVLV5zis3ehZfNxFAN4LecAu5u6Yw2F
xDohzWfq5FYHSWgWZetG6b7fJb9vUdJK5+qlpaE+Gq642V2XBFMzBzUU9bHf+Pv0
Wd94kHcUAUemfmSyeb2x5Kg0aozK8O8Fgtoz8DWEvgH2E2Ya2smnmFOnYnVE3YE+
E5wZJbDd22nJubKBDgKRojlD6xAsMw4F07YfShqmArmiGOaEsiqdIql+XLA4E6/9
VubZgZCI9nhu7zENYK1Lch/sVysAdBKNdw2qwmTFwlDlOXBwJk2OwKLopQaACP6D
pONFcHXHhFlRsOrYYHItEk7n6QO0uKekAd3u0iQVlSIRWWUg4vK/LkzgLSDKlIUC
xJZYr+kIFKkfd1M4hUyNO47mfbC5w8VnXHR8QEIsWGHHUEOW+47gqdvo6+Yz02DH
uZL5VbO0/o7fv5BNAhzs
=h0zX
-----END PGP SIGNATURE-----

--CGDBiGfvSTbxKZlW--
