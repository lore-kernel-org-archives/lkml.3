Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934653AbaHZKYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:24:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44406 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934439AbaHZKYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:24:09 -0400
Date: Tue, 26 Aug 2014 12:24:05 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Holler <holler@ahsoftware.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Jon Loeliger <jdl@jdl.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        =?utf-8?B?U3TDqXBoYW5l?= Marchesin <marcheu@chromium.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver
 initialization order based on the DT)
Message-ID: <20140826102404.GB31124@ulmo>
References: <20140821140211.GD19293@ulmo.nvidia.com>
 <53F64624.5000403@ahsoftware.de>
 <20140822131919.GX21734@leverpostej>
 <20140825093931.GB2399@ulmo>
 <E1XLu15-0002DP-6o@jdl.com>
 <20140825133714.GH4163@ulmo.nvidia.com>
 <20140826084208.AE5F0C40989@trevor.secretlab.ca>
 <20140826084922.GG17263@ulmo>
 <53FC566C.30904@ahsoftware.de>
 <20140826101107.GC32315@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <20140826101107.GC32315@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 11:11:07AM +0100, Mark Rutland wrote:
> On Tue, Aug 26, 2014 at 10:42:04AM +0100, Alexander Holler wrote:
> > Am 26.08.2014 10:49, schrieb Thierry Reding:
> > > On Tue, Aug 26, 2014 at 09:42:08AM +0100, Grant Likely wrote:
> > >> On Mon, 25 Aug 2014 15:37:16 +0200, Thierry Reding <thierry.reding@g=
mail.com> wrote:
> > > [...]
> > >>> There are somewhat standardized bindings for the above and especial=
ly
> > >>> for bindings of the type that clocks implement this is trivial. We =
can
> > >>> simply iterate over each (phandle, specifier) tuple and check that =
the
> > >>> corresponding clock provider can be resolved (which typically means=
 that
> > >>> it's been registered with the common clock framework).
> > >>>
> > >>> For regulators (and regulator-like bindings) the problem is somewhat
> > >>> more difficult because they property names are not standardized. On=
e way
> > >>> to solve this would be to look for property names with a -supply su=
ffix,
> > >>> but that could obviously lead to false positives. One alternative t=
hat I
> > >>> think could eliminate this would be to explicitly list dependencies=
 in
> > >>> drivers. This would allow core code to step through such a list and
> > >>> resolve the (phandle, specifier) tuples.
> > >>
> > >> False positives and negatives may not actually be a problem. It is
> > >> suboptimal, certainly, but it shouldn't outright break the kernel.
> > >
> > > There could be cases where some random integer in a cell could be
> > > interpreted as a phandle and resolve to a struct device_node. I suppo=
se
> > > it might be unlikely, but not impossible, that the device_node could
> > > even match a device in the correct subsystem and you'd get a wrong
> > > dependency. Granted, a wrong dependency may not be catastrophic in th=
at
> > > it won't lead to a crash, but it could lead to various kinds of
> > > weirdness and hard to diagnose problems.
> >=20
> > You need either the type information in the DTB (that's why I've add=20
> > those "dependencies" to identify phandles), or you need to know every=
=20
> > binding (at "dependency-resolve-time" to identify phandles.
>=20
> While having type information in the DTB would be fantastic, it's not
> something we can expect from the systems already in the wild, and I
> worry how it would interact with bootloaders that modify the DTB (I
> don't know if any modify properties with phandles).
>=20
> > The latter is impracticable to implement in a generic way (for use
> > with every possible binding).
>=20
> I don't think we necessarily need dependency information for every
> binding and driver. We only need dependency information where a device
> has a dependency on another device and we don't currently have an
> explicit probe ordering guaranteed by Linux.
>=20
> Where a device driver lacks dependency information and fails to probe,
> we can fall back to the current deferred probing.
>=20
> Do we have any worst case example systems / drivers / dts?

Cc'ing St=C3=A9phane who's brought this up not long ago. There seem to be
cases where display initialization can be delayed up to 5-6 seconds due
to deferred probing (where the system would otherwise take 5-6 seconds
to boot).

Thierry

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/GBEAAoJEN0jrNd/PrOh14sP/RsuC7PKbhImqrAgmzM3Ts6V
Tt0aMvWqlh8wPqYVGqtwogZTQG3y8WESW7hUCVtFtIjCjvrYAH6yt7jZ956eI4m3
OJAue0Yt8OI06a7lOLMLA3EWh/BVT0GXeNiCi+WCE641S1hFpS//tC3oEwFZlmtb
+38CNmFNeGHvAiPlQQOXZ3T6hODII4AeuG+zcoQs0RU1HKPHYsVp172ddnw03vVd
+nbamP+ljWagw3bDSuuEnyaFnGwJN/opxQOxs4GxNKEzSo11D6lVIClXwKEhuXvK
XG/Sr9KByRcrDRyn8h3t9wGhaT/3rFm6jlaI+BMVTymVllouq69E6X5FPWdm92zf
Xd9QyseJkUxLy0cbPkeA5Tx3ohgobJLypz7HD6ihaI0wkSIvARADRjk58pUrOc8k
szFrQMtI+DZBOGJgNeCUmTmnZfyEyIjuStF6jxOKFmP6J5lIVZNtVc4zKR98O6Im
p25wMQzljBH0GdqftPX0s1n86VLVigHbjC4gT87Fv8k8mXqpHAiwXeX80Qki42wW
VKjjdRIOW432D0M39gecako38J65n+8TKKs34ro2c5HoX2ZliYiqiG3JNO7vXLAe
eW4GypkpS/QlD4BClDLt/FOAGcEfbBMb9ksBvJ24cNbgV9uxHbNVV9wpeEqeXCn0
Qp6bQFZG/kslf4rvGCOv
=QBAd
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
