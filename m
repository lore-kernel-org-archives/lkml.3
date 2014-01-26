Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaAZVXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 16:23:12 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59754 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAZVXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 16:23:11 -0500
Date: Sun, 26 Jan 2014 21:22:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <linux@roeck-us.net>, LM Sensors <lm-sensors@lm-sensors.org>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Wei Ni <wni@nvidia.com>
Message-ID: <20140126212256.GK11727@sirena.org.uk>
References: <52E561D0.4040308@roeck-us.net>
 <20140126211357.6fa68909@endymion.delvare>
 <52E573B6.9040903@roeck-us.net>
 <20140126214936.7736f530@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n0t7pLec3q0yZKtb"
Content-Disposition: inline
In-Reply-To: <20140126214936.7736f530@endymion.delvare>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: lm90 driver no longer working on PCs in 3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n0t7pLec3q0yZKtb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 26, 2014 at 09:49:36PM +0100, Jean Delvare wrote:
> On Sun, 26 Jan 2014 12:44:38 -0800, Guenter Roeck wrote:

> > Maybe there is some configuration option, or maybe something needs to be
> > configured from user space. I found neither.

> Neither would be acceptable to my eyes anyway. Things worked out of the
> box before, they should keep working out of the box.

They only worked with a debug option turned on and generated warnings
every time they were used...  that kernel config would've been actively
broken for devices that wanted to do anything at all interesting with
the regulators and would've been prone to issues with init ordering and
races in any cases where there are actually regulators.

> > Another possible fix would be to have the regulator core return -ENODEV
> > instead of -EPROBE_DEFER on non-dt systems. No idea if this would be acceptable
> > or even feasible.

> Well, either the regulator subsystem gets fixed (or provides a suitable
> API for drivers like lm90 and we update the lm90 driver to use it), or
> I'll just revert the problematic commit for now. This is a severe
> regression, we just can't leave things that way.

It's not an issue in the driver, it's an issue in the combination of the
platform and the kernel config.  If the regulator API is going to be
turned on for the platform then either the platform needs to configure
the supplies or it needs to tell the regulator core that it's safe to
start using dummy regulators.

What is this platform and why does it have the regulator API enabled in
the first place?

--n0t7pLec3q0yZKtb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5XytAAoJELSic+t+oim9ZmcP/RdSXSDlvR8IkaUhL30PJ7VF
AbqP9acCptJWRVWLfRwHnjTv67jns+GA47PV7M3LkaEd7039rLVfmLF6llcrQbWa
hkH3R0JfQQBCCZOLQz+rG4ZAK+ME52khSCTo0N/kS8S9jY5KA+a0MqUrk/lU1dsg
9UTJ/iWcg2NVcHjuR+mA1zAWQrCccs++R+cYSH0skf5ft1uU76D+w8BP/5Vceg2e
P5j98Yte5ktaSzoXCGSu6mfiy8pVDL2zKW3McUOzlPQM3T3q5ugndGLyy9lz4Cml
S3+J/pF+rReryyFXQR2/V1HClD0DzM25DQAb/ZUI41L3GCvkQAxnR4cIQGFNsGGG
9vOKWzl4A9WLIgiWUNlyQUMj2UNzUnRvZtx93GmEvJQMgndKtqVfybd7heUNtoNS
ElrTgskd8ICVynqnDG7KkGr9K6mWWPnunM3h5JAO4ZCxwg4aDoMFuy7F7rTY0Upx
ZCq/Om7U4TI3EycvGrpG/zimuLk6TjzRZp8UY8oJixT52ftlp/1wjNH00Frykf4w
QVtGag52+hsEuuW/GViBQe066BEN2Yn9axu0UPpTcW/mTSeZTTxwIK7FsZKm4ogM
ibqTAGjv0vC2fLyCI0jfG+elsjJRWMe8EkBZzu2kX6K3GkPJVAJGfZt7YrjbjslV
ZaA+w+l5OMKwILMLyr5d
=EM7h
-----END PGP SIGNATURE-----

--n0t7pLec3q0yZKtb--
