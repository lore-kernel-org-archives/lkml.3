Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaJUJgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:36:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39392 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaJUJgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:36:07 -0400
Date: Fri, 17 Oct 2014 16:31:18 +0200
From: Mark Brown <broonie@kernel.org>
To: Kevin Hilman <khilman@kernel.org>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20141017143118.GW1820@sirena.org.uk>
References: <1413424160-21180-1-git-send-email-wenyou.yang@atmel.com>
 <7hk33yhms4.fsf@deeprootsystems.com>
 <20141017135716.GS1820@sirena.org.uk>
 <7hd29qhj3i.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5KENZRfAmuo1v8rU"
Content-Disposition: inline
In-Reply-To: <7hd29qhj3i.fsf@deeprootsystems.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/atmel: add support for runtime PM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5KENZRfAmuo1v8rU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 17, 2014 at 07:22:09AM -0700, Kevin Hilman wrote:
> Mark Brown <broonie@kernel.org> writes:
> > On Fri, Oct 17, 2014 at 06:02:35AM -0700, Kevin Hilman wrote:
> >> Wenyou Yang <wenyou.yang@atmel.com> writes:

> >> > +	if (!pm_runtime_suspended(dev)) {
> >> > +		clk_disable_unprepare(as->clk);
> >> > +		pinctrl_pm_select_sleep_state(dev);
> >> > +	}

> >> a.k.a. pm_runtime_put_sync() since the ->runtime_suspend() callback does
> >> the same thing.

> > Will that do the right thing when runtime PM is disabled in Kconfig?

> Good point.

> Then the way to make this cleaner, and obvious on inspection that system
> suspend/resume are doing the same thing as runtime suspend/resume is to
> have ->suspend call the runtime_suspend function.

> The runtime suspend/resume functions then should be wrapped in CONFIG_PM
> instead of CONFIG_PM_RUNTIME.

That sounds reasonable, yes.  I keep on wishing we didn't have so much
configurability in the PM :/

--5KENZRfAmuo1v8rU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUQSg2AAoJECTWi3JdVIfQgQ8H/3enb5+hhx5DglTBT4P1B1ao
WD0HhPTvdG8DpVZl1TyfBq6Zi+mstvO/o0wsIL52C8ssx8cIVZuCWzYS4/ogRAtx
NAXffYiIriEL0uTgsTOZsAFmmm25bF9eggwu9G0ZXhmNl47l8oRRrs9etGkLsQG/
f85rDgtvkp8M8iBB6s5EeGsn0CcspiJi8DB8xYE2Qb5zp5p/fWXLCASIm9m0O/OY
7XJyNXvgrCO6s8qvQZURZk1g+OxlqeGm4sNvBv/CdEk4QQRUkI4ryNKfNc4R/Fqv
QLRQw0fF5ta62LZp49xtzgUuWBQ20ApgXexBsH+ZkWT80s4uBL81j+P87AOu30Q=
=eO2V
-----END PGP SIGNATURE-----

--5KENZRfAmuo1v8rU--
