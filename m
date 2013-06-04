Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab3FDRcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:32:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39744 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3FDRck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:32:40 -0400
Date: Tue, 4 Jun 2013 18:32:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@petalogix.com>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <20130604173210.GL31367@sirena.org.uk>
References: <041d7ca272ef9499fab630294e3395110b3e31ac.1370354549.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iamKNtDj9HjMhSdE"
Content-Disposition: inline
In-Reply-To: <041d7ca272ef9499fab630294e3395110b3e31ac.1370354549.git.michal.simek@xilinx.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] spi: spi-xilinx: Remove ISR race condition
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iamKNtDj9HjMhSdE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 04, 2013 at 04:02:34PM +0200, Michal Simek wrote:

> The ISR currently consumes the rx buffer data and re-enables transmission
> from within interrupt context. This is bad because if the interrupt
> occurs again before the ISR exits, the new interrupt will be erroneously
> cleared by the still completing ISR.

> Simplified the ISR by just setting the completion variable and exiting with
> no action. Then just looped the transmit functionality in
> xilinx_spi_txrx_bufs().

Applied but this is a bit sad, having to defer the refill to process
context means that we're adding extra latency which takes us further
away from being able to saturate the bus.  There ought to be a way to
avoid the issue though I can't think of a non-racy one - I guess level
triggered interrupts aren't an option?

--iamKNtDj9HjMhSdE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRriSXAAoJELSic+t+oim9F3wP/28L64weYCa2/3UiFLAjVCWf
VsAaJ7zqL2+RabYPgD2MVCj+GbBNvn0YS/X+AlRCI8Fkzg+j1BkzSK3TdNq/myxu
Jptpp/BZMPlMZ/0hPjzkz+/AAcfvqYAIYgKM0V+Sj0YboRpd+9IaN6QueHVkIXXT
ulrqBecSY2G0LAnMIdsVBZ2bPmEbF6Sbsq4eY6YHGfwAgI3nyCLGzDj6vXdsEls+
eRV6uetyiHvWnmX7z6k9+jLPa5Z/V0PGxevSgfg5xgGKxlmg4AYUf5m603VWwYlr
8+fsPRv85Bx9nDlsBPUYCsxWj8xS+nTpz+Ew7Lk0UJlAknrfUm+LK5Rhb92EUD7d
UR8/Z6f1s/WVfdNntd9bvGyTYIwf555SSRuV25b3mXKCFH5b7Z1dLFWE836jkYwT
O17NXCuJ0FYSCK7NEVMDsy7rrjTBOQIkkf5Fm5pPWvQFOMmDxn3b11vmgAUApqGF
STR9Lw+GEvr3n1W5sVoXB0k5jv10nFi1BzQu19WTQvFjZ2OhIfrAAtzi6sOkekJF
VXwh82UGtk4qJIbiXsaQ2PG0WpA1dxcX6FHpymajqaobeMaTXeeg4wwbjOIQmPeP
HTzxdtTnmRFDKH7V1uToStMvwf/NWECTHLvUbR//wcvVtjia+AHAiuYPvXmWMQhj
bVHph1/+ox4zLuzD8eat
=OdZr
-----END PGP SIGNATURE-----

--iamKNtDj9HjMhSdE--
