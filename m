Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbbAQNOp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 08:14:45 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44055 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbbAQNOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 08:14:42 -0500
Date: Sat, 17 Jan 2015 13:14:05 +0000
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
Message-ID: <20150117131404.GA6414@sirena.org.uk>
References: <1421330978-9694-1-git-send-email-gregory.clement@free-electrons.com>
 <1421330978-9694-5-git-send-email-gregory.clement@free-electrons.com>
 <54B8C933.7020502@redhat.com>
 <54B8D97B.3090908@free-electrons.com>
 <54B8E38A.6020709@redhat.com>
 <20150116123705.GM3043@sirena.org.uk>
 <54B9629C.9090800@redhat.com>
 <20150116202516.GL3856@sirena.org.uk>
 <54BA21F9.5050408@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <54BA21F9.5050408@redhat.com>
X-Cookie: You should go home.
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


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 17, 2015 at 09:48:57AM +0100, Hans de Goede wrote:

> and leave these regulators on, rather then turn them of $random time,
> because as I've advocated before (see the simplefb thread) there is
> no simple magic moment when it is right to turn things off, so doing
> it when userspace starts is more or less as good as any moment, and if
> it turns out that that is not a good moment, then maybe we need to
> re-think the turning off in general.

Following your argument to the logical conclusion means we can never
turn any regualtor off - we always have the risk that there's another
shared user which is going to get a power bounce if we power down.  More
directly we'll also get people complaining that we're burning power
pointlessly on their systems for devices they've not even got drivers
enabled for.  This powering down is something there's been user demand
for.

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUumAcAAoJECTWi3JdVIfQlH0IAIaIzrngaQ6SB0xsjq9eZMgi
sqS7M9Oi9AveSVZraYdpQ4AgmkgddW+Mqkn3eiojRw75prISheVi09T7veN5C0+t
nq4MhUM8spaInxnT7Ns4GQP7wHwzhWohR6++b24V8olea2Mp+iUQ0C3e7cgxiJLQ
vCQvE8CjYH6o6I57XLx2NsvheHh3CsOK6wdfJnb9f8e7kgK6E1vi9ICOvWsTBaMs
BMzJojO0OgM3GqU9A6XIwbW8OvLUDMStN0lCRgRjXWgD19dZIuEqR4zfCzRXiIz+
CjLOYUZ5deaxrLjS5c4epyO37eBgfSwZfpAMLZpE3h9ANKG0ealiW6aIN71MtSY=
=3ctk
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
