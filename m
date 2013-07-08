Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab3GHL0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:26:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35065 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3GHL0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:26:30 -0400
Date: Mon, 8 Jul 2013 12:26:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kiran.padwal" <kiran.padwal@kpitcummins.com>
Message-ID: <20130708112613.GQ27646@sirena.org.uk>
References: <1373024862.3233.63.camel@matrix>
 <20130705114456.GV27646@sirena.org.uk>
 <1373031306.3233.131.camel@matrix>
 <20130705133752.GX27646@sirena.org.uk>
 <1373270091.11222.12.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UCOOPUdJKgxUwY8X"
Content-Disposition: inline
In-Reply-To: <1373270091.11222.12.camel@matrix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: da9055: Update driver name to
 fix breakage due to pmic driver with same name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UCOOPUdJKgxUwY8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 08, 2013 at 01:24:51PM +0530, Ashish Chavan wrote:
> On Fri, 2013-07-05 at 14:37 +0100, Mark Brown wrote:

> > Your testing seems like it's not very good then - you do undersand that
> > the problem that this is supposed to be fixing is that this is a multi
> > function device?  Please look at how other MFDs in the kernel work.

> I feel that some info is missing from your view. DA9055 is CODEC + PMIC
> but with two different I2C addresses. Actually it is a case of two
> different chips enclosed in a single die. There is NO interconnection
> between CODEC and PMIC inside DA9055. To me, this seems enough reason to
> make two drivers independent from each other and not let one part know
> about the existence of other. Actually in near future, there may be
> three variants of this chip,

This is very similar to things like the TI palmas chips - they have
multiple functions on different I2C addresses.  The chip still gets
instantiated a single time and then the subdevices are instantiated
like a MFD by the core device.

> In my opinion, keeping the drivers independent will also help in
> re-using existing drivers "as it is" for any of the above combination.

It shouldn't make a huge difference here.

--UCOOPUdJKgxUwY8X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2qHOAAoJELSic+t+oim9UugP/iETFOmrj+cKsQgonFmB3r0j
yhmBGhIZEglRrCnuq4596hNYNyfgx6Jwp7j/HMFc/eEvTdBTL+Nw/0IjRQH20gDE
oZXteTpklKr/o+q9LIreuLYChsku6YIePVRbtco59Ya5Ie+B5Nj5lq3nAsWmqmlS
W+g/5s5uewyCikLcQeHzInDhttBFr/MPq7ARctU5lWEApS7sAgxSQypUz+/Tni9w
FVxN4f2fd5LAnGhivDFiq2PvRvrAwFDc34LlQbNtQNUuteOsfZIJ247WD2cBr4Uy
QwpVf5SqRsJlOKYVuFSRnAuek4smHDJzl/yZN+Rf+5teKdTz43MGh+Q9MFMXWAx0
60U9ZL92LrcE2JjewXpJ2CmYVvx/F5TvTgIuz9ZQ58VZ9pmqnWGOqXEZ65nPPtx4
MVJoYFV/47S/GP4WSsIT930bRj3+KA4qn4D2KuPyCDk8EYZGOPmw56jTQway9/1q
+Adki9xQBsI1HfiL4qBTnS1phg7KM0gHT40XausoPwA45kZIBz8ACP4LRxReFMxn
8+3i+6c8MU9b6tjmCtOIvmi9W/NxWeM/uFvWH78FK5UYjvAPRqbJCQmEuj5YdxUi
0BFIvqIZ3UZ/IYirwRVI7IVdn3EGcK7QqPma1l9UWNQz9tZjrkVCNhzZ9VZZT2pC
pMGVVSPQ3WaAoVP+P2HV
=S4fV
-----END PGP SIGNATURE-----

--UCOOPUdJKgxUwY8X--
