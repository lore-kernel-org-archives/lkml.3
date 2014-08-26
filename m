Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbaHZLIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:08:35 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:57811 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727AbaHZLIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:08:32 -0400
Date: Tue, 26 Aug 2014 13:08:28 +0200
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
Message-ID: <20140826110827.GA31350@ulmo>
References: <53F64624.5000403@ahsoftware.de>
 <20140822131919.GX21734@leverpostej>
 <20140825093931.GB2399@ulmo>
 <E1XLu15-0002DP-6o@jdl.com>
 <20140825133714.GH4163@ulmo.nvidia.com>
 <20140826084208.AE5F0C40989@trevor.secretlab.ca>
 <20140826084922.GG17263@ulmo>
 <53FC566C.30904@ahsoftware.de>
 <20140826102503.GC31124@ulmo>
 <53FC6513.5040800@ahsoftware.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <53FC6513.5040800@ahsoftware.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 12:44:35PM +0200, Alexander Holler wrote:
> Am 26.08.2014 12:25, schrieb Thierry Reding:
> >On Tue, Aug 26, 2014 at 11:42:04AM +0200, Alexander Holler wrote:
>=20
> >>You need either the type information in the DTB (that's why I've add th=
ose
> >>"dependencies" to identify phandles), or you need to know every binding=
 (at
> >>"dependency-resolve-time" to identify phandles. The latter is impractic=
able
> >>to implement in a generic way (for use with every possible binding).
> >
> >Like I already mentioned, this could be done in drivers who contain that
> >information already anyway. Or parts of it could be done in subsystem-
> >specific callbacks where a generic binding is available.
>=20
> That would end up with almost the same ugly driver-based workarounds as n=
ow.
> It's much better if a driver author only has to define it's prerequisits =
(in
> form of dependencies in the dts) and could be sure the driver will only be
> probed if those are met, than to do that stuff based on a subsystem or ev=
en
> driver level.
>=20
> If you add dependency-information to drivers, you have two problems:

We already have all that dependency information in drivers anyway. Each
driver requests the resources at .probe() time. What I proposed (it was
really Arnd who proposed it first) is to move that information out of
code and into some sort of table that could be used by the driver core
to figure out dependencies.

> - How do you get these information from the driver (remember, currently
> there is only one initial call, a initcall which might do almost anything)

While I don't think it's necessary, that's something that could be
changed. I mean, we have access to the full source code of this
operating system, so we can change every aspect of it. If we can't find
a way to make this work with the current initcall sequence it's always
an option to extend that sequence so that it meets our needs.

> - These information might become outdated and you would have to change all
> drivers. E.g. if the name of a dependency (driver) changes it wouldn't be
> done with changing the dts (maybe plural), but you would have to change t=
he
> source of all dependant drivers too.

No. Drivers implement a DT binding. That binding defines what power
supplies, clocks, pinmux, ... the device needs. Those constitute the
dependencies. We most certainly don't want to depend on driver names
since there can be a multitude of different drivers that provide a given
dependency.

What drivers should provide (and what they already provide today) is the
name of the property and the index of the cell that they expect to find
a phandle in as well as the type of the phandle. That's all that's
necessary, really. Everything else can be derived from that phandle and
the type.

Thierry

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/GqrAAoJEN0jrNd/PrOhyv8QAKiBbg8DL4/0dYdInmyl8EPD
dcb92vMSYN9Wbc6guTjtm/YNdB4T1jCyF6RKmWPD+/pgGJ00iKvrnvbqI9O4DTRn
WIix4j3ihaHYpZYPkLp/ByHf7yg7YXbfPNzoQP5XcVw1htFJcSr/xs5PPI052Iu3
jglHUdG3sT6Q78k1DmV1oaHNxnKz2MS0fObqz0RAfKJu/7pvkf1N8U/DJrrz9coJ
LATEkGdm1mY/ww5zDKUPQmih3iN/eq1dDshg0/qM1ki09HUWp+tv91FN1cug+KbT
mwqCdkGEmXoFDKFOb8bUAjf41qciPdiepHuNFt/55J66+EZgpqJ+hCohevqqpqwX
jmTgkCT5xbIzaw6HMvtiEcJClmiZ/oiwE4qH03OyshKvlAHH5O72MpN7j+ilxwiO
J3igNV2ZEzdjsta2Y8SPVxl3g2ahdkyGkA0/yj7EeYsZimAUsORFRBMd3+l8h6oy
yzMt5rdG45lzT0E0V6TSCoBifRscwZbJrNWeN7Rrc3dfmtmXZTMWD/vKto4N92V8
Co9Jp85KVLnJcotO4sv0apK/EwKKx4CEy9hNwGqfwZ9K5D46O0CndsARMsXHfW6P
WuIlZOS3wcjWLHeMDitYTrMC0uE8/JbxnytgUUygWODOyD+UbeFQOx5ogd9b95o4
ef8EdV0uy0NbvPx5IDbl
=BvsA
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
