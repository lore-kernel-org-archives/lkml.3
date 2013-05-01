Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab3EAQNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:13:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45243 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab3EAQNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:13:39 -0400
Date: Wed, 1 May 2013 17:12:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Brown <davidb@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>
Message-ID: <20130501161226.GR26160@sirena.org.uk>
References: <20130429162115.GA6893@kroah.com>
 <201304292154.15920.arnd@arndb.de>
 <CA+55aFzefpRz2Y8oW9q0ArrR=XW0POBhy8NSNJ3DrCh9EowLqg@mail.gmail.com>
 <201304292250.47699.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1GSL5ZULXUIqbbH1"
Content-Disposition: inline
In-Reply-To: <201304292250.47699.arnd@arndb.de>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.78
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1GSL5ZULXUIqbbH1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 29, 2013 at 10:50:47PM +0200, Arnd Bergmann wrote:
> On Monday 29 April 2013, Linus Torvalds wrote:

> >  - I'm not seeing what commonalities this thing can have with anything
> > else. Did anybody look at the code? There's nothing generic there.

> It's a simple bus that has addressable registers. We have a generic
> infrastructure for these things in drivers/base/regmap, currently
> handling I2C, SPI and MMIO based buses, which are often used as
> different methods to address the same device endpoints. I think it
> would be sensible to add another one-off type here and convert the
> user(s) to be based on the regmap interface rather than its own
> set of exported symbols.

No need for a special bus type, the regmap core now has support for
supplying read and write callbacks so drivers for devices that look
nothing like a bytestream can use the cache and other infrastructure.
This is a good idea anyway for a PMIC since the regulator API has a
large set of regmap based helpers for the standard operations so we'd
probably save a bunch of code in the regulator driver too.

--1GSL5ZULXUIqbbH1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRgT7nAAoJELSic+t+oim9zG4QAI7ninXP31SRjrT74QSDdf4g
gQdKHy4VIAmBbdXz2LYF5wY2Hn18qlZDzJzumGZNP6pevW2I5nldQcYGlmBIRuzv
ITRB++vq7c8UNjW1w1Z8oUTk2qutjttFBem/uHSiSfXc8wyYurQLO/kdR4uQ2+uM
/Hqm4SPObPuEsWhd0Bgb1c9AgTYu3vPhh6ahTSpdo7xXuDvMEmac2vkeTlVkZbfF
bhbKckH9SnDDQJ+RFzIWyInFfYGva4g8BT0S1zk0ubyLkOrAL4h2MZJbYGs3UEGj
AFJK1BX5QiHpfkvO5ruM3YqsO1L0GE9A0gL3Qny2tMXoogrEFoJp6gNaRLbhRZRx
/gS9E54atCccpr8H7aM0UOQ6LN7KYp7TXW9yovMnK3QWCdPLIvGYac5PrEDW663s
FaJwvFsu2KiFeXt66xpG9cA68c026zqZEc6R18txWY7dPGNlvQMmfhOK/nwX8Gj8
AX7InY4BWVVeYmdWyA7MOJtxg75H9E1Lg7vE7jhNF0SIhQEqUxFB03XAdc2hnyTa
V/4RQmsUv0etaGulw6QMiamabTGXylBGY+v1eO1pBjVIPZgryU8bDOARj0sC7vkF
v3RCPleZe66wj5cV+sQWPAkpSoeUhDd1NBSFv4Ekc4hghWDTYjPdfEgzhhdn55+I
7QeAY8YS7rxK1UTZG5L8
=VNTC
-----END PGP SIGNATURE-----

--1GSL5ZULXUIqbbH1--
