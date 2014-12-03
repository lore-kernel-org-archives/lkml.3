Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaLCUDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:03:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47449 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaLCUDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:03:49 -0500
Date: Wed, 3 Dec 2014 20:03:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Jianqun Xu <jay.xu@rock-chips.com>, Liam Girdwood <lgirdwood@gmail.com>,
        perex@perex.cz, tiwai@suse.de,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-rockchip@lists.infradead.org
Message-ID: <20141203200307.GM7712@sirena.org.uk>
References: <1417531766-29669-1-git-send-email-jay.xu@rock-chips.com>
 <1417591118-18695-1-git-send-email-jay.xu@rock-chips.com>
 <1417591118-18695-3-git-send-email-jay.xu@rock-chips.com>
 <20141203192024.GL7712@sirena.org.uk>
 <CAPz6YkXRmRzYpW7xuDsq69A9H-Qm2-j6t-a+B1w9+OLOPf_YnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gz7Dl29304g/DuvU"
Content-Disposition: inline
In-Reply-To: <CAPz6YkXRmRzYpW7xuDsq69A9H-Qm2-j6t-a+B1w9+OLOPf_YnA@mail.gmail.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] ASoC: rockchip: i2s: add support for grabbing
 output clock to codec
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gz7Dl29304g/DuvU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 03, 2014 at 11:38:13AM -0800, Sonny Rao wrote:
> On Wed, Dec 3, 2014 at 11:20 AM, Mark Brown <broonie@kernel.org> wrote:

> > I would expect that the clock for the CODEC should be managed by the
> > CODEC if at all possible - that seems more logical than having the CPU
> > I2S controller request and manage it if it's a separate clock.  Why add
> > this to the CPU side driver?

> This output clock has a mux and can either be a fixed 12Mhz output or
> can be derived from the same fractional divider which drives the i2s
> block.   I thought it was simpler to keep them all the same, but need
> to put ownership in the i2s in anticipation of the i2s driver setting
> it's own clock rate.

> If you think this is an implementation detail and this output clock
> should just be owned by the codec driver, even though I'm guessing it
> will just have to be the same as i2s, then I think we can drop this
> and make sure simple card (or whatever other codec driver) claims this
> clock.

simple-card obviously isn't a CODEC driver...  For generality I think
the clock does need to be exposed to the CODEC driver, otherwise this
will work differently to how other systems are working and we can't
substitute in a different clock on the CODEC side so easily if it
doesn't happen to use the output from the I2S block.

--gz7Dl29304g/DuvU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUf2x6AAoJECTWi3JdVIfQor4H/R8QlkqfCU1Ht8Ka0ICFucYS
I79180Ndm9Ulbi7VE7FusGljeVINcXw1GWWw34nkG5zjGVoFlVY3flV7ZNbfOlyM
5LQHM8j11BUqQB7WQ1AGtBJ3XTB3yO74MXMva4zCufePubbG72HNgn1CdkvgMXT5
Ty5JrgwWMBxeLZ77xrt4zVZMlGSNPgk/fKGiGxE8qb82kHMZYeodDRXnU/GR4LHC
UPGDFvzILh7eZXGUKtmG33+YRay44JLW3gfLZd27iDoPmxoVCNzvS7CIn1yUls0I
cQbklM9JMBlt/bjzWs8g9aOFeqZ8IKzwGzMlqTrWcgwEpW2PXpBhmHxFlj9hUnw=
=Bt5J
-----END PGP SIGNATURE-----

--gz7Dl29304g/DuvU--
