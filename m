Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaBJNdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:33:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40018 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbaBJNdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:33:00 -0500
Date: Mon, 10 Feb 2014 13:32:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Anson Huang <b20788@freescale.com>,
        kernel@pengutronix.de
Message-ID: <20140210133254.GE1757@sirena.org.uk>
References: <1391697813-20091-1-git-send-email-p.zabel@pengutronix.de>
 <20140210131557.GB1757@sirena.org.uk>
 <1392038875.6687.17.camel@pizza.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tzjrJU3+iJ6c5SNx"
Content-Disposition: inline
In-Reply-To: <1392038875.6687.17.camel@pizza.hi.pengutronix.de>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: anatop: Add power gating support to
 digital LDOs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tzjrJU3+iJ6c5SNx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 10, 2014 at 02:27:55PM +0100, Philipp Zabel wrote:

> yes, thanks. I'll fix this. What should happen if the
> regulator_set_voltage_sel_regmap fails? Is it ok to still
> set the cache in this case?

Either way is fine but not updating the cache is probably better - if it
was a physical write we'd not actually be sure if the write made it to
hardware (it could also have written nonsense!) so we can't really
guarantee what the state is after a failed operation.

--tzjrJU3+iJ6c5SNx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+NUDAAoJELSic+t+oim9/+QP/0wNdy5wAIUqRQm+BVMtRHyp
MuVHyoegw91kQWFex5OG4ubdRM2Ud5hstmVXfhvrItDV+AvjjA2OnY3WyU/cvC8P
BGcZ3MK1mYf+4SzTSSKOPPZ8I04twTpqdvlhkKS66MjI4WTfhbFyS/T3L8rEduEL
++5HywRCpxZsXNOw/MmWWM97bz9vLUCkLZdHR6l2AcFO9IaQZY5sPuLFN0VIhWJg
QyI6PSxib7MwmABa5e8HhIPifrGK/PkUBxIJ4u6IUzuCl4WM9x0FeQesCdjGePNf
hWkYPOnslw9E8tBG/LzYFKZCFsHG4CkFIdVKpkm4kyaruJXu5DjrRFbB/odcpeMU
WDGKepZsIi4y7CaZ9HYG1O3VhQTE2y6vt3gPaIbLJ78qCOlYE196gN073x/b8jl8
GYTsxEJFzXiDyhuz2lG+xIinZywiqOK/ToPLdFwatQ6zJru8hvYiDTpWVht8XKYS
PWTx+7X9m+hJXPCrpvXTUnrHbm8yN4HkuRpe76fWN4582PLZcXWTpZ+8aNLthkKP
l0hTejLra/THXVzFf6UWZcVTMZ1ZC9zBCQMndQS2FCiy3Vk05QGSlh4XNObjyl7n
A3sloW2GJdYyWJACdZ1qTMi0dSbSxm7Ytx4mBHMf9oBFTcOkH+6fnU3BzOnK8IAO
05XEw5xyeqj6RnCRi24A
=xcTV
-----END PGP SIGNATURE-----

--tzjrJU3+iJ6c5SNx--
