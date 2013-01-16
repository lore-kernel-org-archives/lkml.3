Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab3APGfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 01:35:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35471 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3APGfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 01:35:46 -0500
Date: Wed, 16 Jan 2013 07:35:33 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 2/4] input: keyboard: tegra: use devm_* for resource
 allocation
Message-ID: <20130116063533.GA22345@pengutronix.de>
References: <1357371910-3164-3-git-send-email-ldewangan@nvidia.com>
 <20130105080658.GA1315@core.coreip.homeip.net>
 <20130106192739.GA11566@avionic-0098.adnet.avionic-design.de>
 <20130106195748.GA28212@core.coreip.homeip.net>
 <20130109070745.GA12782@avionic-0098.adnet.avionic-design.de>
 <20130109091939.GA4369@core.coreip.homeip.net>
 <20130109092352.GA28037@avionic-0098.adnet.avionic-design.de>
 <20130114154959.GA25049@avionic-0098.adnet.avionic-design.de>
 <20130115130623.GC2625@pengutronix.de>
 <20130115154423.GA13871@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20130115154423.GA13871@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> > Then, I added the example code in the documentation using EADDRNOTAVAIL.
> > Yes, I was brave with this one. Yet, EINVAL, EBUSY, ENOENT, did not
> > really cut it and are so heavily used in drivers that they turned into a
> > generic "something is wrong" error. I tried here to use a not overloaded
> > error code in order to be specific again. Since the patches were
> > accepted, I assumed it wasn't seen as a namespace violation. (Then
> > again, it probably would have been if that error code would go out to
> > userspace) Naturally, I didn't have the resources to check all patches
> > for a consistent error code.
>=20
> The problem with the current approach is that people (me included) keep
> telling people to use this or that error code in an attempt to achieve
> some kind of consistency. Also using an error message to distinguish
> between reasons for failure makes it impossible to handle the error
> other than by visual inspection. Granted, there are currently no code
> paths that require this.

Yes, so currently, this is rather a cosmetic change. And for that, it is
quite intrusive. I think something like this is needed somewhen as part
of a bigger overhaul. That's what I called "master plan" last time. That
could be that resource handling gets aligned in general, also taking
e.g. interrupt resources into account. But only changing error code
handling for this function, doesn't seem too useful to me and might even
need another change later, then.

> One problem with the original patch was also that it didn't actually
> convert any existing uses, so there was little chance of anyone noticing

Like with the error codes now, there are so many different ways of
handling resources that I did not want to mass convert all the drivers
without being able to test them. I was hoping for a migration over time
with patches from people who really tested what they did.

> potential problems. More than a year later this function is used by many
> subsystems and a lot of drivers. It just so happened that I observed how
> many people just didn't know what error codes to choose and often just
> grabbing one randomly.

Yes, and concerning resources this needs cleaning on a bigger scale IMO.

> By adding devm_ioremap_resource() and having it return ERR_PTR()-encoded
> error codes we get rid of all these problems and put the responsibility
> for choosing the error code where, in my opinion, it belongs: the
> failing function.

For completeness, it leaves the problem that people might forget to use
ERR_PTR (seen that often in the clk framework). And the change is huge
while I can't see any real benefit right now.

> > When working with this function, there was also the idea to abstract
> > getting the resource away. Which then gave Sascha Hauer and me the
> > question, if drivers really have to do this or if this couldn't be done
> > by the kernel somehow, i.e. giving the drivers already the resources
> > they need, completely prepared.
>=20
> I'm not sure I like that very much. That could possibly lead to a new
> problem where drivers that need to do something special have to jump
> through hoops to achieve something that may otherwise be simple.

I assume that drivers are already doing something special :) So, that
would turn up in the conversion process. I can't promise that it would
really work, it would need some playing around.

> Anyway, if people don't think this is a sensible conversion I should
> waste no more time on it. On the other hand I have the patch series
> ready so I might as well post it for broader review.

Working on patches is hardly a waste. Even if not accepted, you gain
understanding. Please put me on CC, if you post the patches.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlD2SjUACgkQD27XaX1/VRtPPgCfb3MiZpVKu3WeAg/j/kJr7oHC
5NIAn25m9eZdHRVZADPAT2u2LcGT7yo7
=GLjc
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
