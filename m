Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbaJ2KuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:50:08 -0400
Received: from down.free-electrons.com ([37.187.137.238]:41751 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932637AbaJ2KuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:50:04 -0400
Date: Wed, 29 Oct 2014 11:45:59 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Benoit Parrot <bparrot@ti.com>
Cc: linus.walleij@linaro.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RFC Patch] gpio: add GPIO hogging mechanism
Message-ID: <20141029104559.GC21251@lukather>
References: <1413922198-29373-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MnLPg7ZWsaic7Fhd"
Content-Disposition: inline
In-Reply-To: <1413922198-29373-1-git-send-email-bparrot@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MnLPg7ZWsaic7Fhd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 21, 2014 at 03:09:58PM -0500, Benoit Parrot wrote:
> Based on Boris Brezillion work this is a reworked patch
> of his initial GPIO hogging mechanism.
> This patch provides a way to initally configure specific GPIO
> when the gpio controller is probe.
>=20
> The actual DT scanning to collect the GPIO specific data is performed
> as part of the gpiochip_add().
>=20
> The purpose of this is to allows specific GPIOs to be configured
> without any driver specific code.
> This particularly usueful because board design are getting
> increassingly complex and given SoC pins can now have upward
> of 10 mux values a lot of connections are now dependent on
> external IO muxes to switch various modes and combination.
>=20
> Specific drivers should not necessarily need to be aware of
> what accounts to a specific board implementation. This board level
> "description" should be best kept as part of the dts file.
>=20
> Signed-off-by: Benoit Parrot <bparrot@ti.com>

I've been thinking about this for quite some time, it's good to see
some progress on that :)

However, I have a slightly different use case for it: the Allwinner
SoCs have a vdd pin coming in for every gpio bank. Nothing out of the
ordinary so far, except that some of the boards are using a
GPIO-controlled regulator to feed another bank vdd. That obviously
causes a chicken-egg issue, since for the gpio-regulator driver to
probe, it needs to gpio driver, and for the gpio driver to probe, it
needs the regulator driver.

I was thinking of solving this by enforcing gpio hogs, in order to
have the gpio driver loading, grabing its gpios setting them to the
right value to enable the current to flow in, and then let the
regulator driver probe later on.

I don't think it's possible with your current code, would it be
something worth considering, or would someone have a better solution?

Maxime
--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--MnLPg7ZWsaic7Fhd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUMVnAAoJEBx+YmzsjxAg60oP/RKk8/v1C3Ks5jCxPgGqt+JY
ruYg2Tdxl/MG/m4Nr9wFHqmneE5X3jM6yDtRfEBhcHLiP8kjz/NehcGwQ0NNtzGi
X8FMCfm9wZYdO5okzNCOvCJbpn1vRFOTb16+J5djlOC9N1oy721WwCl0MlIGr2Hi
OUCkAN06I2O12kGt9XUz7CkEaS9Pz51Q/Omvs69fYe0TfRrUgz5RQBFqJWLqqlhG
vX2CwW0z3Cg75/0bQmDAKopfad46ba8q8+zrLiSMCAKs/ARyiaeaJ5mHl9MQn/s4
ZDkDj8p/n4hQA3lSeTOKh60h21DnF9o1S++KFNd3qrMrc+LUrA/CAd74HnhDGeO+
5PvvHY3a1aMD8jDDFiHrZOgJcpVvThBTOQK3ZIkLeHHCQkTk/2VMafa3MhXoPfVH
U+fIfK0PAvFO1JWTk6KCsu7t0DrkdHuohj6h9V1J6CV+NXsSuHSOxO0Wai+PQqHN
3Q64P1BWYodgnUBFinrMPtUBSqWfu3E3wfmwpWYRWCY49rExSMtG1Qwj/dy2/dES
EfBpnU67xZA95LqnQ21++ng78xysLB6Km20MOl/7Y/wdoht9yKrPa5HQSToik2ZF
yOkWwS1YBxCKm8Uf9aHVf7Iyd2s/e8QzEokjO780HJYjprn7WqHzDjmrHMTqQWRa
ABdvGXZjs3TSyDX4CLFS
=3qsa
-----END PGP SIGNATURE-----

--MnLPg7ZWsaic7Fhd--
