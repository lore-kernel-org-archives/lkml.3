Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbbAPPfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:35:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39591 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbbAPPfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:35:40 -0500
Date: Fri, 16 Jan 2015 15:34:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Message-ID: <20150116153451.GA3856@sirena.org.uk>
References: <1421330978-9694-1-git-send-email-gregory.clement@free-electrons.com>
 <1421330978-9694-5-git-send-email-gregory.clement@free-electrons.com>
 <54B8C933.7020502@redhat.com>
 <54B8D97B.3090908@free-electrons.com>
 <54B8E38A.6020709@redhat.com>
 <20150116123705.GM3043@sirena.org.uk>
 <54B91FB4.5080707@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <54B91FB4.5080707@free-electrons.com>
X-Cookie: I've Been Moved!
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


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 16, 2015 at 03:27:00PM +0100, Gregory CLEMENT wrote:
> On 16/01/2015 13:37, Mark Brown wrote:

> > regulator-always-on is a bit fuzzy for suspend, if the regulator has
> > suspend control it'll kick in - it's really about the Linux refcounting
> > while it's running.  What's more concerning here is that the quick
> > sample of the regulators flagged as always on like the above that I
> > looked at in the patch don't seem to have any enable control in the DT
> > so this will have absolutely no effect.

> Actually the reg_sata[0-4] are controlled by gpio, so there is a mean
> to enable/disable them. For the reg_5v_sata[0-4] and reg_12v_sata[0-4]
> they depend on their respective reg_sata and I just propagated the
> regulator-always-on, this was maybe a mistake.

It certainly makes everything confusing if you have control related
stuff on regulators that are not directly controllable.

> >> It is probably a good idea to use regulator-boot-on and
> >> then test things this way, and if that works use
> >> regulator-boot-on.

> > No, it's unlikely that boot-on makes sense here - it's there for cases
> > where we can't read back the hardware state at power on.  Generally
> > drivers should work regardless of the initial state of the regulator
> > (and modular drivers will actually break if they try to rely on boot-on
> > since we clean up unused regulators at boot).

> As pointed by Hans my concern here was be sure that during boot the disk
> are not power off. In this case which property would be accurate?

None, the core won't do anything with the regulator until the end of
init anyway.

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUuS+aAAoJECTWi3JdVIfQKNgH/iCKWQY2+aKb+dO9noEIqfEE
bbz5hA4zbaLkLmNBkQug7NPlzJa86y5NTSqUp9wJjPhJbdvdeCFubJDCTYfpFsiH
+2xtvzYzkH+yYEcxMZFWs0tRdN02GbYXrAwfVlmI6S/FpNBCXHzSjwzfVQTcHLSA
SQbfMu/SyptuJbWsBQmA7KbKtqm2SRgDrTHDWfOcz50H4SGX1g0ytxUQfUTm3k0a
HAiwoHd356IXVugZ2yJxgUoOQBo35FyucNrM3cHnOPoN8iRjrrv7SjeNgJ6Iq1D4
ldAPiC1hsGvCfd1T+xJzi3ISnuBaQDbqNthUuOsV3DFLEzaG6x8VPnLZ4oYS1MM=
=69LJ
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
