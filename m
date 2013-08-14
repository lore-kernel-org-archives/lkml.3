Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab3HNX7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:59:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50670 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3HNX7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:59:49 -0400
Date: Thu, 15 Aug 2013 00:59:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130814235929.GT2401@sirena.org.uk>
References: <20130814184643.GL2401@sirena.org.uk>
 <Pine.LNX.4.44L0.1308141514440.1701-100000@iolanthe.rowland.org>
 <A2CA0424C0A6F04399FB9E1CD98E030458DE9E22@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/CHBEyLWSSL2QXIQ"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458DE9E22@US01WEMBX2.internal.synopsys.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/CHBEyLWSSL2QXIQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2013 at 08:16:56PM +0000, Paul Zimmerman wrote:

> Mark's original complaint about USB was this:
>=20
> > the device).  The hub needs to be "plugged" into the SoC after the SoC
> > USB controller has started with some GPIOs so we need to tell the system
> > that the hub exists and needs to be synchronised with the USB controlle=
r.

> This sounds to me like the normal discovery mechanism for USB isn't getti=
ng
> kicked off because no Connect Status Change is being triggered on the root
> port when the hub is brought online using the GPIOs. Maybe the port has
> been runtime suspended because no device was attached originally?

> So maybe the only thing needed for USB is a way to tell the parent port to
> frob its port control bits to try to determine if a device is now present.
> (set Wake on Connect Enable? Do a Port Reset? Cycle the Port Power bit if
> possible?)

No, that's not required in this case - the case is the opposite one to
the one you describe.  Host starting first then hub works fine, if the
host does go into a low power mode it seems to notice the hub appearing
just fine.  Hub then host fails for some reason which I don't know.

--/CHBEyLWSSL2QXIQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDBneAAoJELSic+t+oim9rasP/3tP6EPWBOv8CENfJ2Q4Co/O
kAmnoODKiwsn6Ha+ifucsHp43f1PomVqjYhW6BDqO3yJApsXqbtQY1kQqjkEAQRm
YDARUby0AbMQNRK8HnwnXWiDeJV3+1Ze6sI8/aqWnLtUfThjSswqxEQRVy1LgwXN
6SB1HiQLDDvPvVRIXs84bbvG18KR3VaOmPS+ViqDePKE51jXHFXU5CjlEWzPziGB
qhG6YWRpIIfxBpYm3mM5Z9Ze9aKo3oKzgP27gVMtRwVTE1Yr0UdbXO7OgO0xNkBk
btWZfHOSE9i1gQ55maJxUilaRoUOgal2p2LylY2SGdZUx3vVh5ySRNJUPRn/Z5gU
tghpYe3FejH+ZbYurUsv7teCnsHHWBs2Wme8kFK5QCtM2SORrr0HIgup7w2PvV4L
kiZlXkJE/HapIrYZs0wAOYO0FE9hXE8RSnChOUMZa+anQcLH/OI3uvagZZjJ0VAh
upqJpGf6ydwFdABpSDjqdihsDQsfns+IDQO6feHidPPCI7hSyxdAOa4HYQv7UQtV
w45L6DdudUKW1aXQbu4iiNYL2muCuDwF3dE66Sm4a+ds3QSK6qobLxDPeVQeGZ4L
5AZbejAvIRGK9r16w1fqBB4PGZes4QlGJKjOAbqR/UlxXkwt42IOujRM7zyMF7E1
VSCItsT1BKBAc/I6hCY7
=jJ3E
-----END PGP SIGNATURE-----

--/CHBEyLWSSL2QXIQ--
