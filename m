Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbbA0NCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 08:02:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36192 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbbA0NCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:02:02 -0500
Date: Tue, 27 Jan 2015 13:01:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Cc: mark.rutland@arm.com, stefan@agner.ch, shawn.guo@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, B44548@freescale.com,
        Li.Xiubo@freescale.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org
Message-ID: <20150127130117.GU21293@sirena.org.uk>
References: <1422356244-15629-1-git-send-email-bhuvanchandra.dv@toradex.com>
 <1422356244-15629-5-git-send-email-bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/OvG/B6si4M0/khi"
Content-Disposition: inline
In-Reply-To: <1422356244-15629-5-git-send-email-bhuvanchandra.dv@toradex.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/7] spi: spi-fsl-dspi: avoid preparing the clock two
 times
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/OvG/B6si4M0/khi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 27, 2015 at 04:27:21PM +0530, Bhuvanchandra DV wrote:
> regmap_read/regmap_write will expect the peripheral clock
> to be enabled before accessing the registers of the peripheral.
> Since the peripheral clock is enabled separatly, avoid redundant clock
> prepare (with devm_regmap_init_mmio_clk) and use devm_regmap_init_mmio instead.

What's the advantage of this?  The clock API is refcounted so there
should be no issue with this and it seems like it's opening us up to
bugs if there's a path where we interact with the registers without
enabling the clocks.

--/OvG/B6si4M0/khi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUx4wdAAoJECTWi3JdVIfQw8YH/iEK6t+Ejl4tZ5JzfBddbN3a
WBiO72ZhuLGxqXiZjXg1e2D4jmjdeDb+M7tGLENo7gXFu9dlvOmAIcjnDrIVl/Va
r/6nEumdyaSxttAYRc7d39MUAcgocCCbIqYWcG/00Y9OhCkbj+tE5m3RzM4Jc840
ipzujqekVLxZPXZ3KqbxYOk2huQJFGYkwfZ9RpcaBANkdaif+Qa3ZA6CLpPpvTaQ
CkjaKryfsLGFBTdFAjELKRBtK66KeTPKN+2B7/iBBaWUlTfQ32f+9ChYWF0vMENq
iIlXTinFFfbj6B3k4CwIHJKtAunZ3apI8LNK6M81oN/6Oen0yEuupz0AICxi2OQ=
=Oedd
-----END PGP SIGNATURE-----

--/OvG/B6si4M0/khi--
