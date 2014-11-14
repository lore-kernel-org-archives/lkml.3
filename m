Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaKNJa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:30:26 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62587 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaKNJaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:30:22 -0500
Date: Fri, 14 Nov 2014 10:30:17 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Simon Horman <horms@verge.net.au>, Joe Perches <joe@perches.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Herring <robh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus <magnus.damm@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3] of: replace Asahi Kasei Corp venter prefix
Message-ID: <20141114093016.GB3810@ulmo>
References: <20140922130026.GK3290@leverpostej>
 <CAMuHMdX22z97SbGS1HDiYfJ1PXxyEN2S8D7w4sr+4bUwD+mJZw@mail.gmail.com>
 <20140922132743.GM3290@leverpostej>
 <87y4rfhmgl.wl%kuninori.morimoto.gx@renesas.com>
 <1415845309.4269.6.camel@perches.com>
 <20141113025105.GA16652@verge.net.au>
 <87vbmjhj00.wl%kuninori.morimoto.gx@renesas.com>
 <20141113110740.GE3815@sirena.org.uk>
 <87k32yd0bd.wl%kuninori.morimoto.gx@renesas.com>
 <5465BFA2.9050706@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Content-Disposition: inline
In-Reply-To: <5465BFA2.9050706@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2014 at 05:38:58PM +0900, Alexandre Courbot wrote:
> On 11/14/2014 10:43 AM, Kuninori Morimoto wrote:
[...]
> >diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/=
tegra20-seaboard.dts
> >index a1d4bf9..7f5cf80 100644
> >--- a/arch/arm/boot/dts/tegra20-seaboard.dts
> >+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
> >@@ -405,7 +405,7 @@
> >  		clock-frequency =3D <400000>;
> >
> >  		magnetometer@c {
> >-			compatible =3D "ak,ak8975";
> >+			compatible =3D "asahi-kasei,ak8975";
>=20
> Mmm. So does this mean this device was never probed because the driver did
> not recognize its compatible property?

I2C (like SPI) has a fallback in case the OF table yields no match. The
of_modalias_node() that it uses extracts the module name from the device
tree node's compatible string by skipping the vendor prefix. The
resulting string is then set as the I2C client's name and causes the I2C
standard ID matching to succeed (see of_i2c_register_devices() for how
this is done in detail).

> I cannot find "ak,ak8975" anywhere else in the kernel.
>=20
> If so,
>=20
> Acked-by: Alexandre Courbot <acourbot@nvidia.com>

Technically this is breaking backwards-compatibility from a DT
perspective, but I think it's safe to do because the Linux kernel has a
way of dealing with this and other operating systems should be able to
deal with this in a similar way (or even easier by letting the driver
match on the ak prefix as well for this particular chip).

So:

Acked-by: Thierry Reding <treding@nvidia.com>

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUZcuoAAoJEN0jrNd/PrOhijEP/0fWBqWZTvD71aj6UyH4xq3U
9EmL389EXehLKgnx7cjPW98QN0MPEDHotakxbVPD3Vn2IhU/SI2/c1w7BAQH8OdM
FZjm1ujoHRk5ePM27/23OWPZd5L/9p54K7ko5qpZvxDj4tmxcMiOWL694RgSRW8q
HkuFd+WcVOdD67uQRcY5xRNRB/egnLzFI5N2jaQUZE8adL9OTWo6objaOigTXAFl
mMlqIpIwK9oGhuJygi05ESp3LcJYMA8i3kdKJv45YH8ctKonRBOmOQqjgxjgMeF6
drzGcz/oiIgd4vV41N9OsKWyTY5gamX/6t604ur+UyKlf/7vgiW72EGMflwcMyKd
reps8t+ZrRQfDBgqy9/+cpQsSnhnLLhFjl/b3jkveNZoEFwf7MWmNdF4VdMdD/mV
BKPNkHHQDI5xbAZJpdZfD9o5zWupkxFt0PrvU8fg78UPXg/pG8Pa91m6S8w77iD6
NyJmWdc8x3R0ADT4DtLelemJalcPaJzcWABYlgDQMBSCms6o6KpFVfIc0VqQUtup
1TzB+QkXNhJdWd6cVbK/XF9wyuiwzCfmXR0+gAK1hOxHfj8IKt+4MtiRDSKmdgSH
S3Cz7OcHCqElXp4QQpuKtNkp1CQffH9rzqF4/aH3zXxayCyz+8hI7a3Twet9UauE
Z967FL/gqnn5QOLMuUfF
=BXjP
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
