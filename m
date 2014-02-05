Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaBESS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:18:29 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36395 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaBESS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:18:27 -0500
Date: Wed, 5 Feb 2014 18:18:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20140205181817.GG32298@sirena.org.uk>
References: <1391493268-3242-1-git-send-email-bjorn.andersson@sonymobile.com>
 <20140204110531.GR22609@sirena.org.uk>
 <CAJAp7OjCnJ=P9Gi20=D9gybREiSaqd1CaQ0K=9fGbCzU1gTFLw@mail.gmail.com>
 <20140204181831.GP22609@sirena.org.uk>
 <CAJAp7Ohn3ch2nK_S8j9ieRBzNeyt6OJmumEhRXXykB9RgMJsQg@mail.gmail.com>
 <20140204200018.GZ22609@sirena.org.uk>
 <CAJAp7OjB-cJbLpdWo0RFJZefCKcCiKc8KgrjkBobJnddv4MSWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8S1fMsFYqgBC+BN/"
Content-Disposition: inline
In-Reply-To: <CAJAp7OjB-cJbLpdWo0RFJZefCKcCiKc8KgrjkBobJnddv4MSWA@mail.gmail.com>
X-Cookie: Take it easy, we're in a hurry.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Make regulator object reflect
 configured voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8S1fMsFYqgBC+BN/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 05, 2014 at 10:00:15AM -0800, Bjorn Andersson wrote:
> On Tue, Feb 4, 2014 at 12:00 PM, Mark Brown <broonie@kernel.org> wrote:

> > So we should be changing the code to allow a set_voltage() that sets the
> > voltage to the existing voltage regardless of constraints allowing a
> > change then - that's what the underlying issue is.  Your change wouldn't
> > cover the case where the hardware defualt is being used for example.

> Makes sense, but the only thing we could check for would be if min_uV
> == max_uV == current-voltage. That would work out fine for this use
> case, but do you think it would be good enough?

It should be fine to check for min_uV <= current-voltage <= max_uV
instead if CHANGE_VOLTAGE isn't available, so long as the existing
setting is in the range it's fine.

> The best thing I've come up with then is to add the following check in
> regulator_set_voltage().

> if (min_uV == max_uV && _regulator_get_voltage(rdev) == min_uV)
>     goto out;

> Would this be acceptable? It's achieving the same thing as my patch,
> is more robust and covers the case of setting the voltage to the hw
> default value.

That sort of thing yes, just short circuit out the main logic in this
case.

--8S1fMsFYqgBC+BN/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8oBmAAoJELSic+t+oim95VEP/RuLY4SSxHRs3qZJOmBPXaeA
k0q8XRkmVV4Iq27mCCrvq3/Qrl5fD9KWpEcmBN+86o5fLkkSk4Kt4y91gE0UDFrz
RPyoEWh00AZiRVvvwN18lFoG4UY1/ZKWImSr91X/KNKsOFt8YsTXp1AroVkDAogS
nHXEyGH760oV5d5wnqW+qDCfzX2CEFLLIhysx9aCYiZLX3TH5OYw4PYwRnQuaoV2
p3iEl7joNvV2t3mMRMds6gX90BByskh/yAS1YTUB5nqseu1kOGQWT41hpHlH+mVG
pAqZkd3BShNe97UkA56xtjpBpF2gTevLgWfv6Q4fmgRhyA+rkLRRHHkQm+u87glq
ebxjFutLj6sehVSIme1C6Aspxb7zFeJB+2MqVOeup+g8U9skD2L7qjCBXNVMb5xQ
+516TbsAK/ZH3f6xJtS7Qu+qFcend7edMa7I+ROr9+N72sdOQayYYxKy25jAhWkJ
newSq2Gog1jq5ROtis7Vw0aIm2xMjTtRnGIsLJtofRp5xJxd62gh1yJ/d6LWBUrr
VrTtp0YX4iooWckgMmZkeCWDdQl3bm9gaYHqbEiGBZ8bb4BqlY51J7qrpaqJtyS9
RzsEO+3vVLB37Yt7mZqQGSDL4iYxW4Ct+B1dk9mefNtdXs5tPjcl6RBKes/lkKL/
EFudpLklPD+ulQpzlT2s
=NzqC
-----END PGP SIGNATURE-----

--8S1fMsFYqgBC+BN/--
