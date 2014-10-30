Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161082AbaJ3RUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:20:08 -0400
Received: from down.free-electrons.com ([37.187.137.238]:52618 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934059AbaJ3RUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:20:05 -0400
Date: Thu, 30 Oct 2014 18:16:09 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Benoit Parrot <bparrot@ti.com>
Cc: linus.walleij@linaro.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RFC Patch] gpio: add GPIO hogging mechanism
Message-ID: <20141030171609.GQ21251@lukather>
References: <1413922198-29373-1-git-send-email-bparrot@ti.com>
 <20141029104559.GC21251@lukather>
 <20141029164122.GC29965@ti.com>
 <20141029164746.GD21251@lukather>
 <20141029230912.GF29965@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Idd68gPqKLz5+Ci0"
Content-Disposition: inline
In-Reply-To: <20141029230912.GF29965@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Idd68gPqKLz5+Ci0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2014 at 06:09:12PM -0500, Benoit Parrot wrote:
> Maxime Ripard <maxime.ripard@free-electrons.com> wrote on Wed [2014-Oct-2=
9 17:47:46 +0100]:
> > On Wed, Oct 29, 2014 at 11:41:22AM -0500, Benoit Parrot wrote:
> > > Maxime Ripard <maxime.ripard@free-electrons.com> wrote on Wed [2014-O=
ct-29 11:45:59 +0100]:
> > > > Hi,
> > > >=20
> > > > On Tue, Oct 21, 2014 at 03:09:58PM -0500, Benoit Parrot wrote:
> > > > > Based on Boris Brezillion work this is a reworked patch
> > > > > of his initial GPIO hogging mechanism.
> > > > > This patch provides a way to initally configure specific GPIO
> > > > > when the gpio controller is probe.
> > > > >=20
> > > > > The actual DT scanning to collect the GPIO specific data is perfo=
rmed
> > > > > as part of the gpiochip_add().
> > > > >=20
> > > > > The purpose of this is to allows specific GPIOs to be configured
> > > > > without any driver specific code.
> > > > > This particularly usueful because board design are getting
> > > > > increassingly complex and given SoC pins can now have upward
> > > > > of 10 mux values a lot of connections are now dependent on
> > > > > external IO muxes to switch various modes and combination.
> > > > >=20
> > > > > Specific drivers should not necessarily need to be aware of
> > > > > what accounts to a specific board implementation. This board level
> > > > > "description" should be best kept as part of the dts file.
> > > > >=20
> > > > > Signed-off-by: Benoit Parrot <bparrot@ti.com>
> > > >=20
> > > > I've been thinking about this for quite some time, it's good to see
> > > > some progress on that :)
> > > >=20
> > > > However, I have a slightly different use case for it: the Allwinner
> > > > SoCs have a vdd pin coming in for every gpio bank. Nothing out of t=
he
> > > > ordinary so far, except that some of the boards are using a
> > > > GPIO-controlled regulator to feed another bank vdd. That obviously
> > > > causes a chicken-egg issue, since for the gpio-regulator driver to
> > > > probe, it needs to gpio driver, and for the gpio driver to probe, it
> > > > needs the regulator driver.
> > >=20
> > > Unless the gpio controlling the vdd pin is from the same bank your
> > > trying to power up I do not see the issue here.
> >=20
> > Not the same bank, but the same driver.
>=20
> How are you currently working around this issue?

For now, we are not, which is exactly why I'm interested in such a
mechanism :)

What I was thinking about for this case would be to "fake" the fact
that the GPIO is even there. The regulator driver would probe, claim
the GPIO, without actually doing anything more than just storing the
value to set, which would be set in the hardware only when the GPIO
driver probes.

I'm not very happy about it though, because that would mean that
drivers that require more than just a value assignment (for example
set high, wait, set low, for a reset for example) wouldn't even know
that what they expect didn't happen.

Maybe that could work by passing some kind of flag to gpio_request to
trigger that mecanism, I don't know.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Idd68gPqKLz5+Ci0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUnJZAAoJEBx+YmzsjxAgcsoP/3oPbCKHLIzeqjxpZMJk7y/O
E+M/Tq43OOfEYDUMRI3RY6vE1tSh7gYHHYLNdEmqqTQqQO98i6zLriERxSgiFjIj
SU3yjJVKsRi2VSj0MP3TiWg7r1EVl9RJCwIuKOmWrI4bCI8UuTP8WBKOnta02y84
+V32N8M3nQ6cvge4fMzyN1pDSQYsXIX57bEQfSdPHLgzY+uD5IrQ4WAkHep4Us6R
Y38flewF3L873XYQ3o2UAhHGV2P4zAKLa5CY6tgjkDtkjatPs4oim07vCYNHPqkA
qdgANoHmZUH7NrJ1giBu8Z4UHCd7rqNLMwKRGZmMODhTLrUQFnW7ZL+Fb9H955ZO
Z7PqCkBTva7w10m7Mpxu5d1tTjaKBfDyprFfIyR4rkiZLzJV9KtQaWVulBXHTmuL
9FLepwpEO6WBMtt9/WGHJaYjIEJS1gDLTpnC9GIhbFXqBWyA//xJbyujiliumcEx
DYXRKih+DIVyDlnlucf5lQMEnfM1S/IvHPLEUoQ1wjcURgwss5N9L+aAQa2GNubh
tPxcPuIROsRTfP8I3eYsn/RYLsEhp4xodJyNex/4mQFswmBEEs8wfT+kH8ZoUCi/
NdgJQi1RPljGuPzNUzoGZhYf3B34h8oMGmEHKD7XI64hU8dNPjK7h+s7Z3OiSb3E
srklg4Yfb/79iINSi5DY
=oXUw
-----END PGP SIGNATURE-----

--Idd68gPqKLz5+Ci0--
