Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbbAJLSO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 06:18:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49032 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbbAJLSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 06:18:10 -0500
Date: Sat, 10 Jan 2015 11:17:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Chen-Yu Tsai <wens@csie.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        devicetree <devicetree@vger.kernel.org>,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-ide@vger.kernel.org, Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Message-ID: <20150110111748.GB4160@sirena.org.uk>
References: <1420799989-10645-1-git-send-email-gregory.clement@free-electrons.com>
 <1420799989-10645-3-git-send-email-gregory.clement@free-electrons.com>
 <54AFF7E3.4070506@redhat.com>
 <54AFFFDC.7020307@free-electrons.com>
 <CAGb2v674q4Cjp9qy9CbUXe2j5pT_ez98CKxXHC8u4Diap2TT1A@mail.gmail.com>
 <20150109171131.GH2634@sirena.org.uk>
 <54B0FCDD.7000300@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FsscpQKzF/jJk6ya"
Content-Disposition: inline
In-Reply-To: <54B0FCDD.7000300@redhat.com>
X-Cookie: Keep out of reach of children.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/4] Documentation: bindings: Add the regulator
 property to the sub-nodes AHCI bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 10, 2015 at 11:20:13AM +0100, Hans de Goede wrote:
> On 09-01-15 18:11, Mark Brown wrote:

> >Or if the supply is for the device at the other end of the link (which
> >is what it sounded like) then use that.  This just sounds like the same
> >problem we have for all the enumerable buses in embedded systems where
> >we need to be able to understand that the device exists prior to it
> >being fully ready to appear in the system.  Having the link/slot be a
> >device in Linux does indeed seem to be a common way people think about
> >doing this, it sounds like for this one it might be the most direct.

> I think we should be careful to not think too much from an implementation
> pov here, the purpose of the devicetree description is to describe the ha=
rdware,
> as is.

I don't think anyone is talking about changing the DT here, only the way
it's represented inside Linux.

>                 sata0: sata-port@0 {
>                         reg =3D <0>;
>                         phys =3D <&sata_phy 0>;
> 			target-supply =3D <&reg_sata0>;
>                 };
>=20
>                 sata1: sata-port@1 {
>                         reg =3D <1>;
>                         phys =3D <&sata_phy 1>;
> 			target-supply =3D <&reg_sata1>;
>                 };
>         };

> Seems to match the hardware pretty exactly, and also matches how we've
> been describing similar devices with only one sata port + power plug sofa=
r,
> so from a consistency pov it also is a good model.

Right, I think that makes sense - it also looks to me like these things
should be representable as devices within Linux.

> So supporting this model requires having a regulator_get API which allows
> specifying which of_node to get the regulator from, e.g. the proposed

It requires nothing of the sort.

> of_regulator_get function. I know you (Mark) do not like this, but all
> other subsystems have an of_foo_get function taking an of_node as argumen=
t,
> I do not see how the regulator subsys is so special that it cannot have o=
ne,
> and also notice that this is only a kernel internal API which we can alwa=
ys
> change later.

Two things there.  One is that mostly those APIs are legacy APIs from
before we made DT a first class citizen and generally they shouldn't be
used these days.  The other is that at least for regulators we have
constant problems with people abusing the API in various ways, as a
result the API has a goal of not helping undesirable usage patterns in
order to help people spot problems.  Having an API which makes it easy
create broken bindings means that it is much more likely that people
will do just that.

--FsscpQKzF/jJk6ya
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUsQpbAAoJECTWi3JdVIfQxwYH/iEzJFcp4qFzIVt/Af9ri40/
1g1Wjuujq3TMMYu/OcutyMvYEp8VBK8LOV0dYnQ6CJ08g+0+Tbg+RHzmOjtG3eeE
XCGxoVOn6HwRLBledYyoAsFEzqdVaBGTYRUBGnU4Yhq6XGzQBrqigZyiSbWrR4nV
oO0gj5We4WsB4Y0bCZhxJwG6nVIMoLdbDHjQCyGf2PdhhyW6CogHJ5fIWMG3HPKr
i8h/RbK/qkaFmmGGtdZrkiVG03fH46YvcGmdvUswBoZISRRIrCH5C9m9OBF4NvI6
dt48gKFuMQsflZ4/EoO+tPhu3dIE4rbz8EBVSaxHqNm3pYIaPuVv64qv4QwwbG4=
=+bOd
-----END PGP SIGNATURE-----

--FsscpQKzF/jJk6ya--
