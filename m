Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbaHZLrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:47:25 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbaHZLrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:47:23 -0400
Date: Tue, 26 Aug 2014 13:47:19 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Grant Likely <grant.likely@linaro.org>, Jon Loeliger <jdl@jdl.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver
 initialization order based on the DT)
Message-ID: <20140826114718.GB641@ulmo>
References: <20140825093931.GB2399@ulmo>
 <E1XLu15-0002DP-6o@jdl.com>
 <20140825133714.GH4163@ulmo.nvidia.com>
 <20140826084208.AE5F0C40989@trevor.secretlab.ca>
 <20140826084922.GG17263@ulmo>
 <53FC566C.30904@ahsoftware.de>
 <20140826102503.GC31124@ulmo>
 <53FC6513.5040800@ahsoftware.de>
 <20140826110827.GA31350@ulmo>
 <53FC6E4A.6030407@ahsoftware.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline
In-Reply-To: <53FC6E4A.6030407@ahsoftware.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 01:23:54PM +0200, Alexander Holler wrote:
> Am 26.08.2014 13:08, schrieb Thierry Reding:
> >On Tue, Aug 26, 2014 at 12:44:35PM +0200, Alexander Holler wrote:
> >>Am 26.08.2014 12:25, schrieb Thierry Reding:
> >>>On Tue, Aug 26, 2014 at 11:42:04AM +0200, Alexander Holler wrote:
> >>
> >>>>You need either the type information in the DTB (that's why I've add =
those
> >>>>"dependencies" to identify phandles), or you need to know every bindi=
ng (at
> >>>>"dependency-resolve-time" to identify phandles. The latter is impract=
icable
> >>>>to implement in a generic way (for use with every possible binding).
> >>>
> >>>Like I already mentioned, this could be done in drivers who contain th=
at
> >>>information already anyway. Or parts of it could be done in subsystem-
> >>>specific callbacks where a generic binding is available.
> >>
> >>That would end up with almost the same ugly driver-based workarounds as=
 now.
> >>It's much better if a driver author only has to define it's prerequisit=
s (in
> >>form of dependencies in the dts) and could be sure the driver will only=
 be
> >>probed if those are met, than to do that stuff based on a subsystem or =
even
> >>driver level.
> >>
> >>If you add dependency-information to drivers, you have two problems:
> >
> >We already have all that dependency information in drivers anyway. Each
> >driver requests the resources at .probe() time. What I proposed (it was
> >really Arnd who proposed it first) is to move that information out of
> >code and into some sort of table that could be used by the driver core
> >to figure out dependencies.
> >
> >>- How do you get these information from the driver (remember, currently
> >>there is only one initial call, a initcall which might do almost anythi=
ng)
> >
> >While I don't think it's necessary, that's something that could be
> >changed. I mean, we have access to the full source code of this
> >operating system, so we can change every aspect of it. If we can't find
> >a way to make this work with the current initcall sequence it's always
> >an option to extend that sequence so that it meets our needs.
> >
> >>- These information might become outdated and you would have to change =
all
> >>drivers. E.g. if the name of a dependency (driver) changes it wouldn't =
be
> >>done with changing the dts (maybe plural), but you would have to change=
 the
> >>source of all dependant drivers too.
> >
> >No. Drivers implement a DT binding. That binding defines what power
> >supplies, clocks, pinmux, ... the device needs. Those constitute the
> >dependencies. We most certainly don't want to depend on driver names
> >since there can be a multitude of different drivers that provide a given
> >dependency.
> >
> >What drivers should provide (and what they already provide today) is the
> >name of the property and the index of the cell that they expect to find
> >a phandle in as well as the type of the phandle. That's all that's
> >necessary, really. Everything else can be derived from that phandle and
> >the type.
>=20
> Drivers don't provide that information (dependencies) in any usable way. =
And
> as you said yourself, it's already contained in phandles. So what we are
> discussing here about? The proposal to use phandles for that is already on
> the table since several month. ;)
>=20
> Sorry, but I don't understand what you want to propose.

In many cases we simply don't know where phandles are stored since we
don't have the type information in DT. But drivers already know the type
of a specific phandle and where to get it from, so the proposal is to
make that knowledge more generally useful so that it can be used for
dependency resolution.

Thierry

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/HPGAAoJEN0jrNd/PrOhlmoP/jA9hpYXpuZKg6a1P2oIKICF
dAksyM2/s7CAdAVhsMHFmNqNqI914EP/Gg6LxpufKDJmzP7tjaU8vPltIsfelaMv
7ntbYVOeLfto3l+bBsXRDieKQ87MIiSTTdY7KqxglFJknPNDec+C/UjXyHEaPvkZ
vUjKZJtwa3URdDlRsW55QwuUW0NpeoMJ6bjfn+HGmJ9Syu+bN6MpXqeYyva19Gzl
iyGv+ks4Kqkloyl5eux2GCz+fS024vNcuQwkbEW/V2D9t5O3IOdSo9iNufBaCH8c
cHsWkJ5d1oa2Z5do176PhcfRH81kE3ouLGCkUNVODsKL4QcgyRcRkKKyt7eETZKm
Ol31d3dAOiHVUgMrjcWZYLjof5yPcfcnkE8tk4e2mofSq4DEditVT8kmBNhNPIhD
C3Sc6uMVl4nJI/2R068t+aj1EIKTHFSd9tEyi4NwxsMrIYNO4UB2y9j2Yhlc894H
htazJbuizsVt/pqrN+w2g8cyCXZvm8GBdMwanCazkWDSLm7hT6mKmSayN7PKPI5Q
iP9MTX+prFkhqLGlCF7OypI1NlirO/b8HQffcoQsV0Py8ie5PjXRU/2hZym11dNV
O9hv24Ju4ay6NNmaAPRHVfsHiECckYKgGC/h2WTZdkvzT3+bFsj9umCtxhULY0QB
N9PZgfPX1L4exCinJWaL
=W1VK
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--
