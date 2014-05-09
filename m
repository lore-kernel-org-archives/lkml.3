Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbaEIOys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:54:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39344 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928AbaEIOyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:54:45 -0400
Date: Fri, 9 May 2014 15:54:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        sjg@chromium.org, grundler@chromium.org, linux-kernel@vger.kernel.org,
        wsa@the-dreams.de, cpgs@samsung.com
Message-ID: <20140509145425.GP12304@sirena.org.uk>
References: <1398350916-885-1-git-send-email-ch.naveen@samsung.com>
 <20140424162558.GB12304@sirena.org.uk>
 <CAHfPSqB5+mLiC07jbEpeUgW63pZVk700SkYGxToO7GRAsFm_nQ@mail.gmail.com>
 <20140509135153.GM12304@sirena.org.uk>
 <CAHfPSqDSTyQXPT-NCZ2hE01qpdmaR54tbWCUYC_zSDGFp58+7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G/DxHU2WzS4MrbHf"
Content-Disposition: inline
In-Reply-To: <CAHfPSqDSTyQXPT-NCZ2hE01qpdmaR54tbWCUYC_zSDGFp58+7g@mail.gmail.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] i2c: exynos5: Initialise Samsung High Speed I2C
 controller early
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G/DxHU2WzS4MrbHf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 09, 2014 at 08:12:47PM +0530, Naveen Krishna Ch wrote:
> On 9 May 2014 19:21, Mark Brown <broonie@kernel.org> wrote:
> > On Fri, May 09, 2014 at 05:50:00PM +0530, Naveen Krishna Ch wrote:

> >> DRM related drivers like DP, FIMD, HDMI, Mixer wants to be probed ASAP
> >> during the boot.
> >> The real problem comes when, one of these drivers do a regulator_get().

> >> If the physical supply  is not enabled/hookedup the regulator_get() call
> >> assumes that physical supply is present and returns a
> >> "dummy_regulator" (But, not an error).

> >> Because of which, Display and several other devices fails to work.

> > These drivers are buggy, if they geniunely expect and handle a missing
> > supply then they should be using regulator_get_optional() to request the
> > regulator and even if they don't the use of subsys_initcall() is not
> > going to fix anything here - if a dummy regulator is going to be
> > returned the time things are probed won't make a difference.

...

> If all the I2C, SPI, DMA, I2C_TUNNEL, DRM based LCD are all mod_probes()
> DRM drivers are probing a head of the PMIC probe. Which is causing the
> display drivers to get "dummy_regulators" instead of the real supplies.

No, it really won't - I have no idea what you are doing but it's not
mainline.  If you are getting dummy regulators then you don't have a
supply present at all and probe ordering isn't going to make a blind
bit of difference.

Please provide a specific technical description of the problem you are
seeing in mainline.

--G/DxHU2WzS4MrbHf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTbOweAAoJELSic+t+oim9qmEQAIBgTYCj60m9MycyLdqiu1x+
jZERq9chAR4ARa1ga781Hz2p9J+vbRFw7wJQkpn38DjMY3s3dK5T6BQ8g3zEydn6
C21FAOQFiomQJqs2wPQgUxoYFQQuwbhLci80GIsCkbU4gFRGHpKraEyXqPtq45cf
V4Mb8FWkAQZ7xF5LsdtqWDhzdiHon1XKc5CT3WIt+Vnny21O6OQDc0i6FDpC6M6K
4fKLDJ3ZPiDATR6IBjtns/erw2FrWvivNTyzwCKMPGnu5UGZ+2jNngcOZJybtDhJ
zr5phiJfeFC01jMUo7SWs44YB55bx3SF8r81agvq6gagDPifL6jKoconxLJRLhLq
IUuOv43fqfWhjLRQBmpERdO/YDXYY0wTdhRbpwY32qxSX+UWRxJPGJFEhqLfEkp0
v1j5xvyQmZHQ0076ppVtFI/8JBZjM58xah41gWKnDXlUWgE/Vvl6KaU2yh4x8h1T
jqNYuEgERl3mH5vCPa+SAMyLOS4GzYeRTX2KsJWMhi+rhopkvLN5JrakybgZD38C
iHolRU5hpn3MGBVYPeAWwTJvrwznEHfw4XUIvLTbB3h8XR95Vw8PIgxp4nVULXg3
OtTf5/IDeCuThuAygDxeR+RMMnRz5RMcxnc3DE+uFPdEE6UkJRhc+jH0wtCPXN9C
CHVao7NHXm9e9bCK++MA
=2eJK
-----END PGP SIGNATURE-----

--G/DxHU2WzS4MrbHf--
