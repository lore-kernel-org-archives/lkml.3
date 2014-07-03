Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964882AbaGCPoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:44:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:39609 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231AbaGCPoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:44:32 -0400
Date: Thu, 3 Jul 2014 17:44:26 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Robert Nelson <robertcnelson@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
Message-ID: <20140703154425.GC23309@earth.universe>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
 <20140702160932.GF5541@saruman.home>
 <20140702190944.GA567@drone.musicnaut.iki.fi>
 <CAOCHtYgxMeA+Arfe40XeFDEKuCJ8qo1RqNR0hYBGr_Wp6sRfdA@mail.gmail.com>
 <20140703073411.GX28884@atomide.com>
 <20140703132509.GA5814@saruman.home>
 <CAOCHtYi0JwRO12gHa+KFGH1k7pPk4TL40igwhzRRxutw-tqf6A@mail.gmail.com>
 <20140703140736.GF5814@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
Content-Disposition: inline
In-Reply-To: <20140703140736.GF5814@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 03, 2014 at 09:07:36AM -0500, Felipe Balbi wrote:
> On Thu, Jul 03, 2014 at 08:34:44AM -0500, Robert Nelson wrote:
> > On Thu, Jul 3, 2014 at 8:25 AM, Felipe Balbi <balbi@ti.com> wrote:
> > > On Thu, Jul 03, 2014 at 12:34:11AM -0700, Tony Lindgren wrote:
> > >> * Robert Nelson <robertcnelson@gmail.com> [140702 12:27]:
> > >> > On Wed, Jul 2, 2014 at 2:09 PM, Aaro Koskinen <aaro.koskinen@iki.f=
i> wrote:
> > >> > > Hi,
> > >> > >
> > >> > > On Wed, Jul 02, 2014 at 11:09:32AM -0500, Felipe Balbi wrote:
> > >> > >> > It has been only tested as console UART.
> > >> > >> > The tty name is ttyS based instead of ttyO. How big is the pa=
in here,
> > >> > >> > what could be the easiest way to provide compatibility?
> > >> > >>
> > >> > >> have been considering that myself for months. You could pass an=
 optional
> > >> > >> argument to serial8250_register_8250_port() but that only solve=
s part of
> > >> > >> the problem :-(
> > >>
> > >> Some kind of compability layer sure would be nice.
> > >>
> > >> > > When ttyS -> ttyO change was done on OMAP, compatibility was not=
 an issue.
> > >> > > Why should we care about it now?
> > >> >
> > >> > It would be a good opportunity to force everyone to update their b=
ootloader. ;)
> > >> >
> > >> > Besides the BeagleBoard forum is quiet now, no one is complaining
> > >> > about that old (ttyS -> ttyO) transition anymore..
> > >>
> > >> How about a Kconfig option to provide ttyO by default? The not even
> > >> do that if kernel has cmdline option nottyomap.
> > >
> > > what about single zImage ? I don't want to use ttyO on my
> > > Allwinner/Exynos/Snapdragon/whatever SoC just because OMAP is in the
> > > same image ;-)
> >=20
> > What if we just kept it simple, leave the ttyO driver enabled and add
> > a warning (pr_info) that it's deprecated.  It's not like it's broken,
> > it just won't get later features or devices support added.
>=20
> Fine by me, I'd switch to 8250 as soon as it's merged though :-) would
> be nice to get an example DTS change just so I can start testing on the
> boards I have around.

DT is supposed to contain information about the hardware, so it
should stay the same? I think there is no non-hackish way to decide
at runtime which driver should be loaded.

One possible solution is:
 * Keep both drivers for a couple of kernel releases
 * Add the deprecation warning to the older one
 * Add a conflict between both drivers in Kconfig

Thus its decided at build-time, which driver should be used. This
would keep existing .config files working for a couple of releases.

-- Sebastian

--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTtXpZAAoJENju1/PIO/qappYP/R9wu/GOonPfQo6uZ7gohmIW
opHVKIl8XNOPMQ6PGjV849jl8INwcnSFSfIf9ToseGDR3mlarPSORmNb80NddTBL
WDjHjiajxQHfOn3gvFt/g4T/MWL7TvaubcdjGrrPYHqFbmSf8+Du4jil/74Le4Wc
D3gK37AivYXv6E81dAlLRmxbusKkLvGJ8oa+t0vV+tM5ScdZyUzoZ512oYLqcC/J
B8hypu3Ug12nA7qREpVAysdMf0tQmAn06+cwUQkQfWjMgLXwE3U9bu3kJC5BpgZe
4iEyLYj6291PhDasQJp6akml5aKfZcaqmuhjqu2/fv9guYzb4Mc9Vl4hFJZONoBR
KcyESrGFqDFxULTTbDhrpW6SlYSg1lAAD0wCrWHld6Lsnz7DNqjIc6TDlmkN+Pqg
X/ZvcsHXC6MyG1VcXSruGoveafqPhODMVr4Lx4HSAh2LCUDaN/U7pHDuMlo1wBpQ
sFhO/sWR4mcfk4WNnxaMhSmrU8ShsF6SMCAYhcCgXM8kg/g8FuD9qQ5rg/Hs9A0l
kmT4bJZ8Etqx4hfLxq6LIvmeN1ZLILBdQ7VkqkoenpwIkAOSxDo0vAIAHu8kC65S
I9fbZWn7c0R8UDuvbJlInSnPq4lckE2t+Nr7wHFh6K2/31lmqAIr6evNn9+GWfQC
7kKld0rXUe2YVhZwhCBV
=cZXg
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--
