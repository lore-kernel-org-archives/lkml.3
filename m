Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbaJ2KPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:15:33 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54916 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405AbaJ2KP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:15:29 -0400
Date: Wed, 29 Oct 2014 10:14:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Message-ID: <20141029101420.GT18557@sirena.org.uk>
References: <1414572037-11306-1-git-send-email-pantelis.antoniou@konsulko.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CLy2MrvMHpW9mjhY"
Content-Disposition: inline
In-Reply-To: <1414572037-11306-1-git-send-email-pantelis.antoniou@konsulko.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] of: spi: Export single device registration method and
 accessors (v2)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CLy2MrvMHpW9mjhY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2014 at 10:40:37AM +0200, Pantelis Antoniou wrote:
> Dynamically inserting spi device nodes requires the use of a single
> device registration method. Rework and export it.
>=20
> Methods to lookup a device/master using a device node are added
> as well, of_find_spi_master_by_node() & of_find_spi_device_by_node().

Why do we need to do this - I would expect that adding nodes would
trigger parsing in the same way we normally do it.  Where is the user
and how does it know that it's handling a SPI node?

This feels like there is an abstraction problem somewhere, whatever code
is supposed to use this is going to need to be taught about each
individual bus which is going to be tedious, I would expect that we'd
have something like the bus being able to provide a callback which will
get invoked whenever a new node appears on the parent node for the bus.

> Changes since v1:
> * Brown paper bug with parameter on of_register_spi_device().

Don't include noise like this in the changelog, put it after --- like
SubmittingPatches says.  Please also try to keep your CC list sane,
CCing random people just means that you're increasing the volume of mail
they have to process.  I'm surprised kernel.org accepts so many CCs.

I have to say I don't recall ever seeing v1...

--CLy2MrvMHpW9mjhY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUL37AAoJECTWi3JdVIfQGIYH/A5QRxNF6Y702k1x9f+6i2FM
3NW97Fh3F8FFzJ4ZkhzIvbJeDifru0aUFzucOku9JHnW5MZhU9bE2IfuOwinsipM
qvu+fo9yn7MVVk2Xvyq05gkz8Ckq8MuPdXGj94nYtsFPVYhWnAr/egVXqRdb2bem
pMc/YHfC74P3sv2QaoQF0AhA+tGvh3ZCocZPaKz7piqsrrLkotRG2tHDBDbztVvo
1t3yMJY4wztURF7DVCWjOw50/CEfwUEDyCER+FKgPTgn2T8DuD7Vn1XLRwDt72Sa
cua2SG4KOGNtzo//2MinVGYdEnzKOK/FoBsMzaidOWK/CXil3wR0R21F3l/yiBQ=
=D7UE
-----END PGP SIGNATURE-----

--CLy2MrvMHpW9mjhY--
