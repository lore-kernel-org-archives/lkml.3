Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934397AbaJ2QuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:50:14 -0400
Received: from down.free-electrons.com ([37.187.137.238]:44256 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934103AbaJ2QuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:50:12 -0400
Date: Wed, 29 Oct 2014 17:47:46 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Benoit Parrot <bparrot@ti.com>
Cc: linus.walleij@linaro.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RFC Patch] gpio: add GPIO hogging mechanism
Message-ID: <20141029164746.GD21251@lukather>
References: <1413922198-29373-1-git-send-email-bparrot@ti.com>
 <20141029104559.GC21251@lukather>
 <20141029164122.GC29965@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LKTjZJSUETSlgu2t"
Content-Disposition: inline
In-Reply-To: <20141029164122.GC29965@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LKTjZJSUETSlgu2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2014 at 11:41:22AM -0500, Benoit Parrot wrote:
> Maxime Ripard <maxime.ripard@free-electrons.com> wrote on Wed [2014-Oct-2=
9 11:45:59 +0100]:
> > Hi,
> >=20
> > On Tue, Oct 21, 2014 at 03:09:58PM -0500, Benoit Parrot wrote:
> > > Based on Boris Brezillion work this is a reworked patch
> > > of his initial GPIO hogging mechanism.
> > > This patch provides a way to initally configure specific GPIO
> > > when the gpio controller is probe.
> > >=20
> > > The actual DT scanning to collect the GPIO specific data is performed
> > > as part of the gpiochip_add().
> > >=20
> > > The purpose of this is to allows specific GPIOs to be configured
> > > without any driver specific code.
> > > This particularly usueful because board design are getting
> > > increassingly complex and given SoC pins can now have upward
> > > of 10 mux values a lot of connections are now dependent on
> > > external IO muxes to switch various modes and combination.
> > >=20
> > > Specific drivers should not necessarily need to be aware of
> > > what accounts to a specific board implementation. This board level
> > > "description" should be best kept as part of the dts file.
> > >=20
> > > Signed-off-by: Benoit Parrot <bparrot@ti.com>
> >=20
> > I've been thinking about this for quite some time, it's good to see
> > some progress on that :)
> >=20
> > However, I have a slightly different use case for it: the Allwinner
> > SoCs have a vdd pin coming in for every gpio bank. Nothing out of the
> > ordinary so far, except that some of the boards are using a
> > GPIO-controlled regulator to feed another bank vdd. That obviously
> > causes a chicken-egg issue, since for the gpio-regulator driver to
> > probe, it needs to gpio driver, and for the gpio driver to probe, it
> > needs the regulator driver.
>=20
> Unless the gpio controlling the vdd pin is from the same bank your
> trying to power up I do not see the issue here.

Not the same bank, but the same driver.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--LKTjZJSUETSlgu2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUURoxAAoJEBx+YmzsjxAgqsAP/j+l9aJHibpVC5p6l+pp/tqb
S7LR52t4XpuSXq9UmOqpcF2q+mVGdfnVK4AatHK44Zk3T7NQht1H5MuZKL3cfESn
UZ2VnBZcHefv9LxEO7UCXfiLNjFLXq1OGEU5a/QGX5kTnVh1JuOD2CsGOS3Q2WDj
qQSrIwkd2OAz8BhcCD7jTfgAj/72Xn9NeTql2HPyhReHU7jCGWDHwh2QO7XAjR5W
IJ3yFwTCosefw3sROUr7D9fi801WRiboTfDKE9gYvIVycFu06lG+4gInEpTktr0G
Qxfq3TtiBB8DYxJ5FwjxfBjT/gKuUD00DukxEDq67WAn0nRV+CjBxFdYQS2U89SC
stTEcR+skwx4sH+3/88Mq8CrjqhoWUWLWwHAcH0vwweV+OWDnIjXa9sMaQvIodHO
vKLe9sCwIWH3rrcvz1VCWh8lK7mZrltQPlVRdcKwof/C93+FGmp+KmGQVzRRDEyc
/0U7DYFR1gsgvHqNkuZm6Zb7aM+C244S9BTocL5lb2P/pGMe6CmRTXt4XZysq5Kc
K4npeXTaFLvW8baVtKCxrhjChm2Lxl9o7E48XINyY7avdsLY9AjWweCn7glDAR9u
OplUnJmieq3PmzH+tAV1ambrNgUqnNMrM42jzSv4c4ffB6+01cr1zcTBmhx0jN4F
JuoRWp1EVrNnamxmPKpG
=SIbd
-----END PGP SIGNATURE-----

--LKTjZJSUETSlgu2t--
