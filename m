Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465Ab3FSJkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:40:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51608 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933993Ab3FSJkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:40:04 -0400
Date: Wed, 19 Jun 2013 10:39:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20130619093938.GT1403@sirena.org.uk>
References: <1371565785-31332-1-git-send-email-mika.westerberg@linux.intel.com>
 <1371565785-31332-2-git-send-email-mika.westerberg@linux.intel.com>
 <20130618180948.GP1403@sirena.org.uk>
 <20130619092508.GJ2718@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DbLwIXqnMNXxdFHq"
Content-Disposition: inline
In-Reply-To: <20130619092508.GJ2718@n2100.arm.linux.org.uk>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi/pxa2xx: use a flag to check if the device is
 runtime suspended
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DbLwIXqnMNXxdFHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2013 at 10:25:08AM +0100, Russell King - ARM Linux wrote:
> On Tue, Jun 18, 2013 at 07:09:48PM +0100, Mark Brown wrote:

> > This sounds like a problem which will affect a lot of devices and hence
> > ought to be handled better by the PM core or at least frameworks in
> > general.  Is it really device specific?

> It's always been something that has been recommended to be dealt with
> by the driver.  If reading the interrupt status you read ~0, then it
> likely is because the device is powered down or removed from the system.

> PCMCIA drivers have done this for years.

I know, some PCI devices too.  It's not just an issue for memory mapped
devices, the same thing happens with devices on other buses - there's a
whole bunch of issues around moving out of the various suspend states
and getting interrupts (things like getting an interrupt controller
waking up and delivering interrupts before the control bus for a device
connected to it has woken up). =20

The driver does need to be the one deciding what to do about being in
suspend but we really ought to be able to do something without having to
interact with the hardware partly just for neatness but more because on
general buses the error handling is too painful.

--DbLwIXqnMNXxdFHq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwXxRAAoJELSic+t+oim9v60P/1aMNkzCEhD2giffDZRdBuyX
xRr+G/JJb0f53BhQy8QQ4CjKS7JzglcAZ+9YRrq4n2jE9ma1a8eYvUDFy7Kjl+u/
uMDWdLHs3tY2zr4w8c5VRb4X2HPd9B6MfK41eVHvWp4LbSGfv4zG5o+nJjXNLIix
Psyk0OzYBNYnBMXSw++0cv7uUvn2kDsyCM23iYs7j9E820UsH5ANvZToyw+R1SFV
NLB0REb4nhf3c6teU0MNmDbr2iOCfHfb3RZnb95iXsyZCvWEW+onwCSo7F2+2koO
KQ37DIzZVoj90pH1LMa6jlv7ins20rVAHJWzFqetLiz36/3hdrFmywLAvoOj8dbT
lZWDsTFriJbM6+rBuS1IieRkU6HW29shaM4spI06u1EgX6qjEorOYtULHX/DUiG8
t+vvVV1sv9kc87XMvs8kDSUE70s2om10VURT3WO1a14QgtZn5JDwnP9/f9044Aaz
Dqygt7s+Dr9O0EvNDzIhEppc1x0lsxq1AZFNwYtu+13c0de/d0HMuX3iVmGmswiR
NNWltpxqOeLZ+2Y+rdTUKVrdOgsapPbwUXWidT7jlGTzqtLnW8g4FtOF8r235QIq
F/eTg3aCGkRka2+tdhNBPZWLR7G25i8++XmY0Mp1w/y42Ol/I57jHIvF37MK/pMj
fq9wohrmS0WJzXXmGhzz
=uFHb
-----END PGP SIGNATURE-----

--DbLwIXqnMNXxdFHq--
