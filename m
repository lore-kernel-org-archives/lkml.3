Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbaGaKSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:18:16 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64356 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456AbaGaKSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:18:14 -0400
Date: Thu, 31 Jul 2014 12:18:08 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <Will.Deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140731101807.GB7458@ulmo>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140730152646.GC20162@leverpostej>
 <20140731083923.GA31218@ulmo>
 <20140731092241.GA21850@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <20140731092241.GA21850@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 10:22:41AM +0100, Mark Rutland wrote:
> [...]
>=20
> > > > +Examples:
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > +
> > > > +Single-master IOMMU:
> > > > +--------------------
> > > > +
> > > > +	iommu {
> > > > +		#iommu-cells =3D <0>;
> > > > +	};
> > > > +
> > > > +	master {
> > > > +		iommus =3D <&/iommu>;
> > >=20
> > > Nit: this should be iommus =3D <&{/iommu}>, or it's not valid dts syn=
tax.
> >=20
> > Done.
>=20
> Cheers. I take it that was done for the other occurrences too?

Of course. =3D)

> > > > +	};
> > > > +
> > > > +Multiple-master IOMMU with fixed associations:
> > > > +----------------------------------------------
> > > > +
> > > > +	/* multiple-master IOMMU */
> > > > +	iommu {
> > > > +		/*
> > > > +		 * Masters are statically associated with this IOMMU and
> > > > +		 * address translation is always enabled.
> > > > +		 */
> > > > +		#iommu-cells =3D <0>;
> > >=20
> > > I don't follow why translation being always enabled is relevant to the
> > > example; that would seem to be independent from the binding.
> > >=20
> > > Surely the key point is that with no way to distinguish devices, they
> > > presumably share the same translations?
> >=20
> > Both aspects are important I think. For #iommu-cells =3D <0> there is no
> > way for the IOMMU driver to know how to enable translation for a given
> > device. So it must be either always on or always off.
>=20
> Sure. But "always on or off" is not the same as "always enabled", which
> was what confused me.

Yes, this was indeed awkwardly formulated. I think the point that I was
trying to get across was that there could be IOMMUs that are always on,
with no means to disable translations at all. But since that's now
mentioned in the "Notes:" section that Olof commented on I think we have
that covered as well.

>=20
> > I guess one could say that this is implicit if all masters share the
> > same translations. And I guess translations don't always have to be on
> > or off technically. Let me try to rephrase this:
> >=20
> > 		/*
> > 		 * Masters are statically associated with this IOMMU and share
> > 		 * the same address translations because the IOMMU does not
> > 		 * have sufficient information to distinguish between masters.
> > 		 *
> > 		 * Consequently address translation is always on or off for
> > 		 * all masters at any given point in time.
> > 		 */
> >=20
> > Does that sound better?
>=20
> That addresses my concern, so yes.
>=20
> Given these are minor and everyone wants this in now, I'm happy for
> these to go through in a fixup patch later.

It looks like this hasn't been applied yet, so I can send out a v5
shortly with the requested changes addressed.

Thierry

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT2hffAAoJEN0jrNd/PrOh3pcP/0gVN98Cf1ILd1b5oVKSLq2g
YgbdR+QRHEj5ZXermjbC6U477vKNV8trViOc3Vp7QlUdtNy2i0ckIY/0SF3HDRAf
BPyvE/sNlYM8tdyOmpfeiP1vmIxfaxOYoSsD4odJmOInetlI0F3PCOFRjOyxFP2o
UO1WAoVxlYxmqzk9gdxTXLXE2VAt7AM3mA9Gumu262zZDXzGFkutae0PJP2c/Pt7
bt9mEWE+TuzwjlYQNCbGPxwkY7W7MqNmRK29p9jLkdo++ujYNSKmEYEnvMw+SvKi
NY5pFIOj5TV6pYqZeu0FDUEDcxOz9Zx6+cmRp0mSndZEDJtdVvvSnUU90+NAZ4jm
mTOnRwjMSO+kvpzu2j6heP1Th4xudG4eFqy1jLvZ8hgX9co397JxG5RElQGUUPlT
ZWgTAL16wklR42/70q3ZGPfr5YzopUbu2wbWLfFZgE/ESPZ6KAceBumJLYwyo8/5
iT12ZDi0B2NlpIIY6d6nRVFrxKMNOoU3qWyeCrSh96wyOKj5qew6iRYP33Lls7lo
PY7Ilm5i3UMs5B8JyQac+gSJCkCO+Zfi1YxI/ljunwtMz2Qf8LzDw42K1BTUT8uz
JYKOnfAq6SvlEEMa+insjYDcU8nelXaDYdJo13KIqveVAIMf4pPzm7bOaVHY/OCF
sOwv7iQD8LR8eG5YALcg
=gtMX
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
