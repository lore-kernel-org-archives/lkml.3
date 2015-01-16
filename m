Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbbAPMhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:37:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39012 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbbAPMhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:37:39 -0500
Date: Fri, 16 Jan 2015 12:37:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Message-ID: <20150116123705.GM3043@sirena.org.uk>
References: <1421330978-9694-1-git-send-email-gregory.clement@free-electrons.com>
 <1421330978-9694-5-git-send-email-gregory.clement@free-electrons.com>
 <54B8C933.7020502@redhat.com>
 <54B8D97B.3090908@free-electrons.com>
 <54B8E38A.6020709@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="glNuw4S6NeIZr5j7"
Content-Disposition: inline
In-Reply-To: <54B8E38A.6020709@redhat.com>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 4/4] ARM: mvebu: Armada 385 GP: Add regulators to the
 SATA port
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--glNuw4S6NeIZr5j7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 16, 2015 at 11:10:18AM +0100, Hans de Goede wrote:
> On 16-01-15 10:27, Gregory CLEMENT wrote:

> >>>+	reg_sata0: pwr-sata0 {
> >>>+		compatible = "regulator-fixed";
> >>>+		regulator-name = "pwr_en_sata0";
> >>>+		enable-active-high;
> >>>+		regulator-always-on;

> >>done, but we're not using a power on delay anyways.

> >But if regulator-always-on prevent to switch it off in
> >suspend then yes using regulator-boot-on is better.

> AFAIK regulator-always-on means exactly that and thus likely
> is not what you want. As for using regulator-off-in-suspend
> that is not necessary as the suspend method for the acpi
> driver will already turn it off.

regulator-always-on is a bit fuzzy for suspend, if the regulator has
suspend control it'll kick in - it's really about the Linux refcounting
while it's running.  What's more concerning here is that the quick
sample of the regulators flagged as always on like the above that I
looked at in the patch don't seem to have any enable control in the DT
so this will have absolutely no effect.

> It is probably a good idea to use regulator-boot-on and
> then test things this way, and if that works use
> regulator-boot-on.

No, it's unlikely that boot-on makes sense here - it's there for cases
where we can't read back the hardware state at power on.  Generally
drivers should work regardless of the initial state of the regulator
(and modular drivers will actually break if they try to rely on boot-on
since we clean up unused regulators at boot).

--glNuw4S6NeIZr5j7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUuQXwAAoJECTWi3JdVIfQu5gH/AhCywjrNL2vXzWBMUdPpaYI
/8gj9ulaew6Tp42IFGTwy0oegIL0KgiIHE9VuAXlVSzXOviHgZUeRTpwh7fU4mpD
KMMzq0T4tyzobOZbzEYIGFiyX6E/lpRO3TmH80vo7aDYi37126KY8AB0JYyFIGNi
oNdnaQPmoIlZRAdMeQBz6rpISsRM66JHYiuJKtmVxbJgCx69CxtLqBCpSmyv7dRR
ur4J0NfL4USfLSzs47j514u/Mz8MKy4xXQGAE/Af5fUE/3grFke1PjsYq/zSmXl4
YFXYA18ZvqUgKyyHXpba3W/HByC22LmKNbKg0ghTWH1sUthtcGMusNh/oJWajhA=
=dxAq
-----END PGP SIGNATURE-----

--glNuw4S6NeIZr5j7--
