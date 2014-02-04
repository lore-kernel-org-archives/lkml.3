Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaBDAV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 19:21:29 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34846 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaBDAV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 19:21:27 -0500
Date: Tue, 4 Feb 2014 00:21:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-sunxi@googlegroups.com,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Message-ID: <20140204002110.GP22609@sirena.org.uk>
References: <1391165752-1819-1-git-send-email-maxime.ripard@free-electrons.com>
 <1391165752-1819-4-git-send-email-maxime.ripard@free-electrons.com>
 <20140131124809.GE22609@sirena.org.uk>
 <20140131224704.GI2950@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4xvrXxpSOutbQOB9"
Content-Disposition: inline
In-Reply-To: <20140131224704.GI2950@lukather>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 3/5] spi: sunxi: Add Allwinner A31 SPI controller
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4xvrXxpSOutbQOB9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 31, 2014 at 11:47:04PM +0100, Maxime Ripard wrote:
> On Fri, Jan 31, 2014 at 12:48:09PM +0000, Mark Brown wrote:
> > On Fri, Jan 31, 2014 at 11:55:50AM +0100, Maxime Ripard wrote:

> > > +	pm_runtime_enable(&pdev->dev);
> > > +	if (!pm_runtime_enabled(&pdev->dev)) {
> > > +		ret = sun6i_spi_runtime_resume(&pdev->dev);
> > > +		if (ret) {
> > > +			dev_err(&pdev->dev, "Couldn't resume the device\n");
> > > +			return ret;
> > > +		}
> > > +	}

> > No, as discussed don't do this - notice how other drivers aren't written
> > this way either.  Like I said leave the device powered on startup and
> > then let it be idled by runtime PM.

> Well, some SPI drivers are actually written like that (all the tegra

It's not been done consistently, no - that should be fixed.

> SPI drivers for example). It's not an excuse, but waking up the device
> only to put it back in suspend right away seems kind of

It isn't awesome, no.  Ideally the runtime PM code would do this but
then you couldn't ifdef the operations which as far as I can tell is the
main thing people want from disabling it and it gets complicated for
devices that genuinely do power up on startup so here we are.

> inefficient. Plus, the pm_runtime_idle callback you suggested are
> actually calling runtime_idle, while we want to call runtime_suspend.

Yeah, I didn't actually check if I was looking at the right call there.

--4xvrXxpSOutbQOB9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8DJyAAoJELSic+t+oim9sG0P/2nOyF7gVt73C5f6UGLn9sUC
rUbhIwsFP8Id9mnbIXQ0DaF1aPw3wuwlIt1JB393+syeO6z3MlozdTySZTp3DdYw
U1AJ82s7dKC6rGgK2IF2gi/QV0P8zqf0MiUWQlGbJ1Bv37LOX2X0Et2Je7uXgyph
jRndtefN/VGYKCB82xs68Cp8q/UDzCJdoqT4RyslliBo4O3OY4LhlZkQfn4KQhfY
Nll8TVuXs7+MR4MoCIfwqmYrvjYMJ1etqHZYotSSf5QSmMhBQ6lLDtmKa3rGaKGS
VnCyYmY0DZsWoNF8UX/etfDyaJKHMd6twR7OVf/uORRlnS94fdFR2MRZ8Y1Y7rXQ
zimm3sb4p5hCwmtZeIFKZJYgEnxqNTuNiBpXBGIHHYrYQrmLhSUU2WqnkzQOzBFD
89eQWWCBKMukBPsqwTrQa0TWsppiq+tYtRHX/TA7x1rzxyEgp3k8ZIpj2ptGeDpK
rCZ/cvnqxa6OHv69knY1NSGwtIlmUID7Uu6AAvAHzAoMtNkTlaBxjInQFRkbFF9R
5MuRxoDJj9jDh0AHw/MAFAJtfUCMU8iu3LrAN6VrT2blTJ6YC/TRUx/lazTFcyTN
QB/UL23bBP6N1l05yCf3/1bI8SW9GNmKfPdiI6i6tbTxD3RbyU/55wGQX4C9MM/y
4xMLaTZIbUPcOdpsjPQK
=CUIv
-----END PGP SIGNATURE-----

--4xvrXxpSOutbQOB9--
