Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbaHMKyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:54:00 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62637 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaHMKx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:53:58 -0400
Date: Wed, 13 Aug 2014 12:53:54 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/3] Thermal reset support in PMC
Message-ID: <20140813105354.GA4843@ulmo>
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
 <20140813080744.GD7735@ulmo>
 <53EB1DF5.301@nvidia.com>
 <53EB250D.5070207@nvidia.com>
 <20140813085728.GF7735@ulmo>
 <53EB3556.9010504@nvidia.com>
 <20140813103613.GA7624@ulmo>
 <53EB40F0.4000300@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <53EB40F0.4000300@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 01:41:52PM +0300, Mikko Perttunen wrote:
>=20
>=20
> On 13/08/14 13:36, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Wed, Aug 13, 2014 at 12:52:22PM +0300, Mikko Perttunen wrote:
> >>On 13/08/14 11:57, Thierry Reding wrote:
> >>>>Old Signed by an unknown key
> >>>
> >>>On Wed, Aug 13, 2014 at 11:42:53AM +0300, Mikko Perttunen wrote:
> >>>>
> >>>>
> >>>>On 13/08/14 11:12, Mikko Perttunen wrote:
> >>>>>On 13/08/14 11:07, Thierry Reding wrote:
> >>>>>>>Old Signed by an unknown key
> >>>>>>
> >>>>>>On Tue, Aug 05, 2014 at 11:12:57AM +0300, Mikko Perttunen wrote:
> >>>>>>>Hi,
> >>>>>>>
> >>>>>>>this series adds support for hardware-triggered thermal reset to t=
he PMC
> >>>>>>>driver. Namely, it adds device tree properties for specifying the =
I2C
> >>>>>>>command to be sent when thermtrip is triggered. It is to be noted
> >>>>>>>that thermtrip won't be ever triggered without a soctherm driver to
> >>>>>>>calibrate the sensors, but I'll follow up with that patch.
> >>>>>>>
> >>>>>>>pmc.c required some juggling around to make the match data usable =
in
> >>>>>>>probe, since I didn't want to put the code into the initcall eithe=
r, since
> >>>>>>>the soctherm driver won't be initialized by that point anyway.
> >>>>>>>
> >>>>>>>Series tested on Jetson-TK1. Should work on Tegra30 and Tegra114 t=
oo.
> >>>>>>
> >>>>>>Can you describe the procedure used to test this? We currently have=
 a
> >>>>>>bunch of features in Tegra that some people have tested at some poi=
nt
> >>>>>>during development but the test procedures never got documented. Th=
at
> >>>>>>means whenever we want to test something we need to go and reinvent=
 a
> >>>>>>bunch of tests after the fact.
> >>>>>>
> >>>>>>So what I'd like to start doing is collect tests (preferably in some
> >>>>>>scripted way) so that they can be kept in a repository that people =
can
> >>>>>>easily clone and run on devices.
> >>>>>>
> >>>>>>Could you provide something like that for thermtrip?
> >>>>>
> >>>>>Sure. I'll see if I can make a just a test script or if a local patc=
h is
> >>>>>needed to test. Btw, I also have a pretty nice test script for EMC
> >>>>>ready, and I agree that such a repository would be very nice.
> >>>>
> >>>>Here is a test program. It it works, the device with immediately shut=
 down.
> >>>>
> >>>>https://gist.github.com/cyndis/66126c9c176b5f94a76f
> >>>
> >>>Is there a way to set the trip temperature without going through
> >>>/dev/mem? I'd expect the device to have a sysfs interface of some
> >>>sort.
> >>
> >>The thermtrip "device" isn't currently exposed in any way. If it were
> >>exposed, I suppose it would be exposed as thermal zone devices, each wi=
th
> >>one trip point. Even then, the thermal framework doesn't really support=
 this
> >>properly; none of the trip point types really apply to this kind of trip
> >>point, and x86 systems don't expose their trips either.
> >
> >Okay. The reason why I asked is because I'm not sure yet that having C
> >programs in the test suite would be good, so having something that's
> >easily scriptable would be preferred.
>=20
> I agree. Looks like Python's stdlib has mmap support, so maybe we could u=
se
> that.

Yes, possibly. It still means that somebody needs to have some kind of
advanced scripting available to test this. While having a testsuite is
useful, it would still be nice to occasionally be able to test things
with just simple shell commands.

> >>Anyway, since debugging is pretty much the only use case for modifying
> >>the trip temperature, I thought adding the tz_devices would be a bit
> >>overkill.
> >
> >An alternative could be a file in debugfs.
>=20
> True, though there's the "don't expose dangerous stuff in debugfs" argume=
nt
> against that. I don't really have problem with it, though.
> Although in this case I think the script approach would be good enough.

I've said this before and I don't think "dangerous stuff in debugfs" is
a valid argument. You need superuser privileges to access debugfs, and
if you have such privileges you can do pretty much what you want (run
the test program you posted for example).

Thierry

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT60PCAAoJEN0jrNd/PrOhFUQP/RGzM7wwi06EtOB64s97uReI
Gqj3vl0GBuQhKiHJ72dyyouCElWZKGQttBzIB8Tra8Un1UfelZFS5TAHYeFEG55F
E0dRvcAgpoykbIwWJBS0AUNPkoTGkoCes22vxFOoyI1XSucJ7r97/yvyHQj2XA0Y
fvEtSRiIGKSOc+a6BOL/57vRIVDsO+5B38YwvwLHp3Aqm3URMVYLlaZFifLNEcwg
6EaLjzIzR4H0kz53obs6I/841o/UxaqhJmEGZtczSP5ER1ZBdP1JzRLdupcLU3kT
zQXlMRdy9Zap/83R6r+bUowtM1Fz5d5GziOAKELkQB29RBDo7p+Rb8D0GEpEjBiH
fgD0O3HkQd+p9QNicM2RjAfgmJhcEKm9k7ERjZtlN6+gRoX1+7IJRSWQjXOSBiH2
s30Wg1M4rSNo3/tkktBAQCLra8SkWQCmZvxzGUDiqBsLCBIP3qA6j66E30l3ZQat
tfBMLoD5uROy+LRVFuzMpfR8FyTBtCq2CD9yrJxWVYZP38d4pUe4tG8RRk9hKJci
wDfJ4bNEIlEqBmNVRt1GM0S1XyKi+iEB+0Y4kumlrVjJrElw7wOUAWWCVJ//xPHi
dQeRpCdnG4tBe1xYBvnS32DbLJPfzdzYf0LysH2gaAdj5l7eK0WQpyEmFxlk3Plm
zGjtpCk07molKHDvxJDp
=PxcT
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
