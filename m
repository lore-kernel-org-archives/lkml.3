Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaHMIBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:01:46 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49064 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaHMIBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:01:42 -0400
Date: Wed, 13 Aug 2014 10:01:39 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/3] of: Add descriptions of thermtrip properties to
 Tegra PMC bindings
Message-ID: <20140813080138.GB7735@ulmo>
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
 <1407226380-747-2-git-send-email-mperttunen@nvidia.com>
 <20140813073541.GA17466@ulmo>
 <53EB18E6.3070203@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <53EB18E6.3070203@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 10:51:02AM +0300, Mikko Perttunen wrote:
> On 13/08/14 10:35, Thierry Reding wrote:
> >On Tue, Aug 05, 2014 at 11:12:58AM +0300, Mikko Perttunen wrote:
[...]
> >>+Required properties for hardware-triggered thermal reset:
> >>+    (only tegra30, tegra114, tegra124)
> >>+- nvidia,thermtrip-pmu-i2c-addr : I2C address of the power management =
unit.
> >>+- nvidia,thermtrip-i2c-controller : Index of the I2C controller the PM=
U is
> >>+                                    attached to.
> >
> >This duplicates information already associated with the PMU device. Can
> >this be turned into something like:
> >
> >	nvidia,thermtrip-pmu: phandle to Power Management Unit
> >
> >Then we can query the relevant information from the I2C client resolved
> >from the phandle.
>=20
> True, that would look nicer.
>=20
> >
> >One problem with that might be that the I2C controller index may not
> >match the hardware ID.
>=20
> Maybe we could resort to checking the controller address in this case. Th=
is
> is a safety feature, so programming the wrong controller index accidental=
ly
> would be bad.

What we've done in the past (for the display controllers) is to add a
special property that has the "hardware index" of the controller. I
think in this case it would be appropriate to add one as well. That way
we could reach into the I2C adapter of the I2C client and parse it from
the associated device tree node (client->adapter->dev.of_node).

> >>+- nvidia,thermtrip-reg-addr : Address (byte) to send reset command to.
> >>+- nvidia,thermtrip-reg-data : Data (byte) to use as reset command.
> >>+
> >>+Optional properties for hardware-triggered thermal reset:
> >>+    (only tegra30, tegra114, tegra124)
> >>+- nvidia,thermtrip-pinmux : Pinmux ID used for I2C access.
> >
> >I suppose this takes a phandle? If so the description should probably
> >say so.
>=20
> No, it takes a pinmux ID, described in the boot process (non-public in T1=
24
> I guess..) section of the TRM. It seems, though, that all platforms
> supported by the downstream kernel have pinmux =3D=3D 0.

Ugh... we'll need to get this documented publicly.

> >What exactly does "16-bit operations" mean? And isn't this a property of
> >the I2C device, therefore could be queried from the I2C slave via the
> >phandle?
>=20
> That's how it's described in the TRM, but I just found a comment in the
> downstream kernel about it. Apparently it controls the amount of data sent
> to the PMIC. The downstream kernel says, though, that the option is not
> supported and must always be left as zero, so I guess it could be dropped.

Indeed. If ever it becomes necessary we can add it then (and fall back
to 8-bit "operations" if it's not present).

Thierry

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6xtiAAoJEN0jrNd/PrOh0l8P+QG9HsF0PlEAp+8yUNz+ws8p
fQNhnyq3OoRirfV0ECeMpfjb6ibQ01fjAw/y4j88S2jqlhH72vveu3UCNPne+qYH
cukvGohlJPH3QElGmQseV8FCv6mMw1vkdX/NmUhw02RU2KOASfG3uehfCiix805J
cVXjHl2vxNQhqFZQmLZs7Li7bc666nN2MihtLiAYB3Gf7E2K0b9RIoujPzX90PZ0
bj+u6knkySv+oN6s21mRE2dCES97wEV/0X6dMHfWVX8GaCaiKgQdVCNIKUmpdBKD
YSMdPTH5vt8CaI1ZC0aJdRwtJq2MjhDGOYQNrQW0Dxoukt2vQtIJpklC6YwcfJVZ
5VLjRe7MY0sVDxchr7aGnPrqla03YoEVh5LcYIF6AaP32hG+NPBhqsPHd1r/g/DX
wnegxEahSeCaqun5itmNlUQIjFnhVUglv10jp9bcUZ4nFj7jjPXrWc13tk/w66Hd
Rl7195VH4kiRknOdTJwIQqE7ZVyOqxMfaQdo61qf8Lfp7x+SMj5pUMsDzHFlI92e
sXcAx+03jcTPyqDDUMnyuvLqlQxSmzIaH0dJKsPCCCEeHJHLMEa0nFX63r2mWx8H
s1mGrJcESWv/PDuVHqC4uZanJjnwSR1lbqVvzbYSZTgYmVZoqloYoe4NuA9quJcb
Wr+vW1oVKe5vLW7Exuz7
=+L4g
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
