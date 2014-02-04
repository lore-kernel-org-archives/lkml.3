Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaBDLCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:02:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35102 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaBDLCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:02:23 -0500
Date: Tue, 4 Feb 2014 11:02:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-sunxi@googlegroups.com,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Kevin Hilman <khilman@linaro.org>
Message-ID: <20140204110209.GQ22609@sirena.org.uk>
References: <1391165752-1819-1-git-send-email-maxime.ripard@free-electrons.com>
 <1391165752-1819-4-git-send-email-maxime.ripard@free-electrons.com>
 <20140131124809.GE22609@sirena.org.uk>
 <20140131224704.GI2950@lukather>
 <20140204002110.GP22609@sirena.org.uk>
 <20140204090926.GI25625@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pNTAM9ZU3uJ+Foyt"
Content-Disposition: inline
In-Reply-To: <20140204090926.GI25625@lukather>
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


--pNTAM9ZU3uJ+Foyt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 10:09:26AM +0100, Maxime Ripard wrote:
> On Tue, Feb 04, 2014 at 12:21:10AM +0000, Mark Brown wrote:

> > It isn't awesome, no.  Ideally the runtime PM code would do this but
> > then you couldn't ifdef the operations which as far as I can tell is the
> > main thing people want from disabling it and it gets complicated for
> > devices that genuinely do power up on startup so here we are.

> We discussed it with Kevin on IRC, and he suggested that we move that
> pm_runtime initialization to the SPI core, but I guess that would also
> mean that all drivers shouldn't ifdef the operations, so that the core
> can call the runtime_resume callback directly.

No, that's not going to be robust - it means drivers can't do any power
sequencing of their own.

> However, I don't really get why any driver should be doing so, since
> you still need these functions to at least to the device
> suspend/resume in the probe/remove, and you don't really want to
> duplicate the code.

I don't think it's particularly useful to support disabling runtime PM
in the first place but some drivers do different things when doing
runtime management to those they do on first init - for example there
may be additional steps that only need to be done during first power up.

--pNTAM9ZU3uJ+Foyt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8MitAAoJELSic+t+oim9xgkP/joV3euZEX/ko4Nk5pCOa1ZT
udQL6wL0FvY8Lmzipk6YfDjpP8lQg41nSGhT+9A1RXxM6iG6VTPFAUX8Ld/uTBRt
aM53x68YW7dRZydtW9fuw14zQ0bAGTQDds/3REM5fsAxYfyOy2mi+0OJnEho1DQK
sAtw51OVwz5KU0IQhgRTiuzPWYmoLyT6pJeDbWekkd5Q+ytl87e0jJYJniVCUW0F
/7p5eW/XdVyPdUnT13gh/5PQ/IepbIFQe6XF7OBHXPs9+T53lYKG2HW7mWrK8bp2
56rhxqelfPGXoUvLuVqsBpW5ZiDCIavQPsZ1VDoIhdMi3oPOv+sZy9euLszLadL+
3jCfrgmAUaYthERd2T7Q1oKUcjaOkkiTVGKULW2ejj1KfILdnMRmJdukeqIlmC0I
D/zcnqt02hgTN0BLccDp/vQUp0zdz0f9VNluURDpMirSXr7ZErsc2uK0+mVIqYIj
cCqo5f/+tATXtZAlFeXwR4lAKXdIY6RpAiHSiisAfE3mhb6sfFoKsSNG3zclVq4D
aEsgA19N1goiCbn0PLaCl9KPe6KtMmOyU9XzIXg/AypV9mMAh4syqAzz2R01bOrM
ht5AH80Z6AqOi6LYPMS9dgl7F0TaYlUFxSYNTBUWVf/KlxTCzRSFKy0QbQ7mNUN2
Ymxc+tDS62ugUFI1XQSF
=ExHT
-----END PGP SIGNATURE-----

--pNTAM9ZU3uJ+Foyt--
