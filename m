Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab3GVKJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:09:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55367 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab3GVKJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:09:19 -0400
Date: Mon, 22 Jul 2013 11:08:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130722100856.GQ9858@sirena.org.uk>
References: <1374485092-13211-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SKuKPt3hQSBflurX"
Content-Disposition: inline
In-Reply-To: <1374485092-13211-1-git-send-email-p.zabel@pengutronix.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: irq: Acknowledge also interrupts that are masked
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SKuKPt3hQSBflurX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 22, 2013 at 11:24:52AM +0200, Philipp Zabel wrote:
> In case the hardware interrupt mask register does not prevent the chip level
> irq from being asserted by the corresponding interrupt status bit, stray
> masked interrupts should to be acknowledged, too.

> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> I have seen GPI interrupts trigger on DA9063 trigger after being masked during
> initialization, and once the status bits are set, the interrupt handler routine
> never clears them, which keeps the chip irq line asserted forever.

This can't be the standard behaviour since it breaks expectations as to
what happens for masked interrupts.  Though based on your description of
the problem it sounds like a quirk to ack interrupts immediately after
masking them might do the trick instead of the full on always ack
behaviour.

--SKuKPt3hQSBflurX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7QS1AAoJELSic+t+oim9HWAQAILjJfljC1Q9ChcV3M5mYVG1
um4VAXoP93HRXtcy8FNqYBGMjgWjnR86NuV6UyA8n215wk/qnmp6rrNGB0QNwes2
6ZkVMckB/0QT8EWxKLx+hJirWpSQJWltGZ0FHteIf5JblXCztjV6itHsQ1tw8I4E
Eizm5WCojpgeonMbVQrLlMGGz5AGFS2+/4qScpPcPOOpdiCsIHSJRUE7Dm+QQDtW
hbYCXiVUY0TKyIbrAvEw2sjTlY2r6DZNvEjgL7s0+AuHKbJccguz8UPSi73n+vTh
ooatVhr8RHVdLcjSIFMCLhn9+XUqG97oINymedHsAEQVnSmpH8obs47hBlnYcXRp
KyNskt1ukCw1VQmQ1nBMhapPSbA2rEESlb23C5CWGYmBRorsqCfI00ihmUdNbDcp
mchqE0GGoECuf3xbOC4ajOIX2EV8DdXCffOJGy05eMaYq7kOdf5vMfy1IJcaXQu1
YScM/JhGfFgNpWTEw2ViFH21tiLG1qTf6gggAHP4ri0TAL0Mvz7VKYkspwyCbIge
ZaIFAefA4sZ+Qutpvi4aJLasfXEa8rVnZX/Dj6/31j9mCZFS9IZWMGKK68Z9aGmI
tznCs1Te9HqgnzSlMVFT2cR69ZEp52ymYrRAx4+sVbPWA1UFPPZzOLYKSb80BUx1
dHCXYzETQT1akor+6zRi
=GFmR
-----END PGP SIGNATURE-----

--SKuKPt3hQSBflurX--
