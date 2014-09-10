Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaIJPOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:14:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33172 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaIJPOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:14:01 -0400
Date: Wed, 10 Sep 2014 16:13:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Stefan Wahren <info@lategoodbye.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "stefan.wahren@i2se.com" <stefan.wahren@i2se.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20140910151316.GG7960@sirena.org.uk>
References: <1410089869-6611-1-git-send-email-info@lategoodbye.de>
 <1410089869-6611-3-git-send-email-info@lategoodbye.de>
 <20140909182211.GG3896@leverpostej>
 <540F523D.4010904@lategoodbye.de>
 <20140910141853.GA4994@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w2JjAQZceEVGylhD"
Content-Disposition: inline
In-Reply-To: <20140910141853.GA4994@leverpostej>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.132.226.177
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC 2/3] ARM: regulator: add Freescale MXS regulator
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w2JjAQZceEVGylhD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 10, 2014 at 03:18:53PM +0100, Mark Rutland wrote:
> On Tue, Sep 09, 2014 at 08:17:17PM +0100, Stefan Wahren wrote:

Ugh, this looks like it might be a regulator driver but since the
subject line was "ARM: " I deleted it unread - if your changelog looks
different to all the other changelogs in the subsystem it probably needs
changing.

> > >> +       sreg = devm_kzalloc(dev, sizeof(*sreg), GFP_KERNEL);
> > >> +       if (!sreg)
> > >> +               return -ENOMEM;
> > >> +       sreg->initdata = initdata;
> > >> +       sreg->name = of_get_property(np, "regulator-name", NULL);

> > > I'm not keen on using of_get_property here. We have no idea if
> > > regulator-name is even a string (it should be, but we have no
> > > guarantee).

> > Better using of_property_read_string?

> Yes. That will check the value is NUL-terminated, at least.

Or just remove the property entirely...  without having seen the
bindings if we're specifying the name of the device via the device tree
something seems wrong.

--w2JjAQZceEVGylhD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUEGqLAAoJECTWi3JdVIfQYhMH/3Irx/4TIbl+1jnoUIF0bmc/
0MzRdjsd1D8cTFaJsY4euQSaZYi5mXZcA0stJO0GZSinjy5kJfBPJ9vGaccXcYyD
x0pc2Os91wiMIFK7ZmO4AfBR2bF1ZVKwsoPv++bbFgA2ts4UBDbDn60g9Deboris
Xi/ACOtru1pMj6vHv+BGt+jxKR2Th36/zeCjewJuDb8YM6tL5XOyiHYotRGk+MLd
M4kLH1VkYtSEJEnO/FIWEiWXOAHbL1HniYOxe3SFq8dd+dpiyi6FRZ7bHBoA5kZS
qU+YAMxZHawTFZvNbiGh6v5LbIJ8k7n4CJIi6EOi2/y36K8voRcldj9HZoKJH4o=
=rbLU
-----END PGP SIGNATURE-----

--w2JjAQZceEVGylhD--
