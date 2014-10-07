Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaJGL6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:58:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38463 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaJGL6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:58:50 -0400
Date: Tue, 7 Oct 2014 12:58:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Message-ID: <20141007115817.GX4609@sirena.org.uk>
References: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
 <1412626635-7404-3-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gX5Hm7FaHdN5aeGl"
Content-Disposition: inline
In-Reply-To: <1412626635-7404-3-git-send-email-mpa@pengutronix.de>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/5] regulator: Set ena_gpio_valid in regulator drivers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gX5Hm7FaHdN5aeGl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 06, 2014 at 10:17:12PM +0200, Markus Pargmann wrote:
> This patch sets the new field ena_gpio_valid for all drivers which set a
> valid ena_gpio.

>  	config.ena_gpio = arizona->pdata.ldoena;
> +	config.ena_gpio_valid = true;

This patch just unconditionally sets the flag in all drivers which will
break any system which relies on the existing behaviour that we ignore
GPIO 0.  We can definitely set this flag in any DT only system if we get
the GPIO from DT but otherwise doing this defeats the point of having
the flag in the first place.

--gX5Hm7FaHdN5aeGl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUM9VYAAoJECTWi3JdVIfQtwQIAITfiaPH6vX7PBF6R/6RBzzL
oV6dGfz2FlEQE2TSQBVYOsd4rRdyNGyaSdFrA//RuOQR4SSjK2mbH2bt7b8fQrry
8Z09UNWAXkVEqTIRczvtIi7bdYpA3+ImMwWaKuBKyDu+xMCH/9Sz4L6s0bAUG1rq
D2Ef0XREQWCqn1Jp2APnJvnKTeX+amHJ9R0XPfMG2UmHc10vOs5UdsfMxKPgf+Pe
D82MX3MBj5YEq2GpMuK5xt/q6sev37wLXzf9Dwtn4VSl7V+W1c8pD4RE470Vuoj+
qTrDvYg8vuIkxs3bWGl7rpcpN9syRBmk4pcgvCiJtI3Nb6Di9773uFG9R0+YL2o=
=mPto
-----END PGP SIGNATURE-----

--gX5Hm7FaHdN5aeGl--
