Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaJHLWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:22:12 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40383 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaJHLWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:22:08 -0400
Date: Wed, 8 Oct 2014 12:21:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Ray Jui <rjui@broadcom.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        JD Zheng <jdzheng@broadcom.com>, Scott Branden <sbranden@broadcom.com>
Message-ID: <20141008112143.GT4609@sirena.org.uk>
References: <rjui@broadcom.com>
 <1412743127-4523-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LXsBfGm2MIDJcXyT"
Content-Disposition: inline
In-Reply-To: <1412743127-4523-1-git-send-email-rjui@broadcom.com>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: pl022: Fix broken spidev when DMA is enabled
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LXsBfGm2MIDJcXyT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 07, 2014 at 09:38:47PM -0700, Ray Jui wrote:

> The PL022 SPI driver maps the DMA RX buffer before the DMA TX buffer. In
> most cases, the sequence of the mapping does not matter. But in cases
> where TX and RX happen to use the same buffer, e.g., spidev, it causes
> the cached TX data not written to memory, because the same memory has
> been marked invalid when dma_map_sg on the RX buffer is called

This seems like it is a bug in spidev, using the same buffer simultaneously
for both directions isn't something I'd think would be expected to work
reliably unless it was explicitly mapped as bidirectional.

--LXsBfGm2MIDJcXyT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNR5GAAoJECTWi3JdVIfQhUgH/0zt4qPnCGtU0caRZuqNqHFr
BWm3LT2azuJqwdN0ET+Q2Vitd3AdKgLKV8FdKest5CP8xFCXRnCmeRhjDmNm5vrV
UlzSic2DgvT8Eylv2jexXSXlUseG87tQffFRkuxlyZsochTBv9oAU7B+tJ4MjPlH
7WeUbMoIgdpLiNzmPq6NK7FltT8heMv2TCHR2xIcYvY5+C0AT/cQAh0nvB+2YGaw
KX+t8j5wmeal03/PfRP8mhjTg1TE+GYWEHyTTldcxVdt3ogUhino+8GAaeqFeMdW
zgeWTNrfj3d1HF6NQXhC/CZ9ij+Hu8FcyNwX1gZY1XXHMwktQmWAVguZH2wYLHY=
=sGCg
-----END PGP SIGNATURE-----

--LXsBfGm2MIDJcXyT--
