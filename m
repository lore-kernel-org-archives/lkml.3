Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbbARNlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 08:41:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48955 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbbARNlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 08:41:49 -0500
Date: Sun, 18 Jan 2015 13:41:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Paul Osmialowski <p.osmialowsk@samsung.com>,
        Wolfram Sang <wsa@the-dreams.de>, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Michael Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-ID: <20150118134124.GC2809@sirena.org.uk>
References: <1421419194-1849-1-git-send-email-p.osmialowsk@samsung.com>
 <CA+Ln22GrsCj0291dVccFPzPW8pmxyc8JHtPo5ijsAdDXw6RC1Q@mail.gmail.com>
 <54BB9100.7000506@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9Ek0hoCL9XbhcSqy"
Content-Disposition: inline
In-Reply-To: <54BB9100.7000506@samsung.com>
X-Cookie: MERYL STREEP is my obstetrician!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 1/3] i2c: Enhancement of i2c API to address circular lock
 dependency problem
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9Ek0hoCL9XbhcSqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 18, 2015 at 11:54:56AM +0100, Krzysztof Kozlowski wrote:
> W dniu 18.01.2015 o 07:30, Tomasz Figa pisze:

> >So, the question is, do we actually have hardware that _really_
> >requires _actual_ preparation or all the clk_prepare_enable()s in I2C
> >drivers (at least in i2c-s3c2410) are just to simplify the code?

> I completely forgot that you already thought about this deadlock in 2014. I
> think we can try the no-prepare way for i2c-s3c2410. However this would be
> only workaround for specific chip. Other buses (like SPI) would require
> similar changes.

Right, and it's every single driver which would need an update too which
is a bit icky and sad.  On the other hand a more detailed fix is going
to involve trying to make the clock API locking more fine grained which
isn't fun.

> I wondered why this was not observed (at least not observed by me with
> lockdep) on Gear 2 (Rinato) board. This is quite similar case: the S2MPS14
> PMIC provides regulators and 32kHz clocks. I think it is exactly the same
> pattern as for max77686... but somehow lockdep never reported that deadlock
> there.

Mostly the clocks on PMICs never get changed at runtime which helps a
lot here.

--9Ek0hoCL9XbhcSqy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUu7gDAAoJECTWi3JdVIfQPmMH/3afYEY4WeiR+Sf1FQumwTFo
ed0ITCeLzT0D1WSSg75AL1WMOdkwRILhNkFWN9KKwOI2gAbWFJhF4Eg8fsyHGjuu
u17mnrg8okxJjbWRP7fykFhXMhjNy5etUghTwVxgUYsM6UW982F91HrHFUgv9Fkd
BgfnfBE9Md4nbIhD8b1K5BECpD61dteSjzWAGd7BXQ4UpJhdDhpUEnccykjvy5jC
s9AJQEQIU7ttsiNF+mBUktT4TjXqiJFj7j3lI1MIFwK4NMqHGCeZooRlmo441hEO
zKJszwMdFNjKVR87rUMSn4m9IwySIWQEhLbBL859X+rLl2XBQfECf72ednVpB+U=
=Hh0i
-----END PGP SIGNATURE-----

--9Ek0hoCL9XbhcSqy--
