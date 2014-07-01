Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbaGAM2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:28:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42645 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaGAM2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:28:01 -0400
Date: Tue, 1 Jul 2014 13:27:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org
Message-ID: <20140701122717.GN23300@sirena.org.uk>
References: <1404215726-2480-1-git-send-email-broonie@kernel.org>
 <20140701120622.GJ32514@n2100.arm.linux.org.uk>
 <20140701121142.GM23300@sirena.org.uk>
 <CAAVeFuJqRW0ih8Mg9MFwLf=wQ7eVK5+pm8deW0vTUdozJ16FfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bUPNgY5xlcsGsZNb"
Content-Disposition: inline
In-Reply-To: <CAAVeFuJqRW0ih8Mg9MFwLf=wQ7eVK5+pm8deW0vTUdozJ16FfQ@mail.gmail.com>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Still free GPIOs using gpio_free()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bUPNgY5xlcsGsZNb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 01, 2014 at 09:24:22PM +0900, Alexandre Courbot wrote:
> On Tue, Jul 1, 2014 at 9:11 PM, Mark Brown <broonie@kernel.org> wrote:

> > Huh, good point (though it still seems a bit neater to match up the
> > request and release functions I guess).  Linus?

> Yeah it's a nice habit to free the GPIOs using the same interface as
> the one used to obtain them. Although if we are to allow the regulator
> framework to request GPIO through both the integer and descriptor
> interfaces, we certainly don't want to track that information forever.

> On top of that we want to limit the use of gpio_to_desc() and
> desc_to_gpio() in drivers as much as possible, so I'd say I prefer to
> see gpiod_free() used no matter where the GPIO came from.

Right, but Linus said we didn't need this conversion to descriptors so
I'm a bit confused as to what the issue he was raising was.

--bUPNgY5xlcsGsZNb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTsqkiAAoJELSic+t+oim9TyIQAILjEZGnkVvCLT94pu42c9cp
zbPuyD8egYwqGqiYPIVOIN+6Ei56rjvjN5xhcqPVrlnXxEGuRUjv/wZWmJzXzUhw
+wErssCyGovS5zPct7c6VO6EO6yJXntP8eYRTQjhr05w/eg1yM8UUPlvNAEA1XGh
TvgnV9BLBD5rk4V5txQNaGc4El+wOoUsrTRRXp1eNr5IdQnKi8o7nQU1Q+evb5Pv
8NcO/NSEr8Zw3vbFsv9HBRrPFjr4PJTBIFOYIpQ7KcDArI/eLUz+bTPbjmR+g3nb
Nq8adeAV4AVQoqp1VW/n9/QVvPVWizEaFAhrlGiIKtprfa/WVPR68qghpkwASuND
En+dO63GyvXtPrGPHZUxqtfBpPg9O944Vi6rBIm+keLLA4QpA2+HRAg30KsKsLGV
PtNbYdwwQpQiylhzn88hv0VqaKFXxWe3BRQ3tULBAOOcucJwBZU+ittpB0yj2ry/
6hCwXHIxYIhs7GJrVpNll3TqBe1/G67J/Ry4K43TjuT3IVSrfztGEmNE70p/6h7E
Gdfmicn1jtCNlTLO7B8HfjMlsMrm+uGs9GQmRzuK3wQzZ5qwXOL6h2r2XhL/PN37
ti8VkVGZpSfoxLPYnC7e18doFUjX2t1DKwWaQdIb/+j+sV809KhY3bWn/54uVGNR
GT8FecU3jZewAZtrlwAj
=wYzU
-----END PGP SIGNATURE-----

--bUPNgY5xlcsGsZNb--
