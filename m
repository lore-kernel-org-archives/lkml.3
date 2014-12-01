Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbaLAURB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:17:01 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45406 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaLAURA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:17:00 -0500
Date: Mon, 1 Dec 2014 20:16:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Timur Tabi <timur@tabi.org>, linuxppc-dev@lists.ozlabs.org,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        Jiada Wang <jiada_wang@mentor.com>, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com, nicoleotsuka@gmail.com, tiwai@suse.de,
        Li.Xiubo@freescale.com, Markus Pargmann <mpa@pengutronix.de>
Message-ID: <20141201201637.GQ7712@sirena.org.uk>
References: <1417402251-6596-1-git-send-email-jiada_wang@mentor.com>
 <2547588.Qc4F2IfZke@wuerfel>
 <547CC89F.1030205@tabi.org>
 <3401240.VsRpsiV8WN@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nSDEzYKH9NcCJl81"
Content-Disposition: inline
In-Reply-To: <3401240.VsRpsiV8WN@wuerfel>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: fsl_ssi: free irq before
 irq_dispose_mapping()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nSDEzYKH9NcCJl81
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 01, 2014 at 09:01:43PM +0100, Arnd Bergmann wrote:
> On Monday 01 December 2014 13:59:27 Timur Tabi wrote:
> > On 12/01/2014 01:56 PM, Arnd Bergmann wrote:

> > > All other drivers that call irq_of_parse_and_map and pass that into
> > > devm_request_irq just never unmap, and their interrupts are already
> > > mapped by the platform code, so I think it's not even a leak.

> > Does this mean that fsl_ssi.c should not be calling=20
> > irq_of_parse_and_map?  How else should it get the IRQ?

> platform_get_irq()

Right, and just to emphasize what we were saying earlier the code was
fine when originally written - both mapping inside platform_get_irq()
and devm_ came along quite a while after the driver was originally
written.

--nSDEzYKH9NcCJl81
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfMylAAoJECTWi3JdVIfQLs0H/0mdxVbkYXh6Wwqh996cOx5J
+u+51SvcjYuetWXv9bSJz26C3jkHt21NDe087CqGbZBDtlcLtK8YedTbISyrQp9D
vqzmu5H3hACrQBR2VT7v5jrmFn6jmSXMMUfGCVET5ptNgCTZzhV6Q01R114e2gjn
4kdZ8Db5NdRU6G9raoXUwDIflH1nB7KrFkR5DS9c08fobIxXcsH/eqLZgOVWH1qn
igDUlTrQoUMbUMHIxBhjG6u5lxIyx3wofV2RQhYhHwr6FlTGVWvnXpaERg1ych8u
srXkCh2AR+UPCHz/h5wpVj8KULFTASpyW9GxO3f950bbQ4X64FHR3URIC8FXa5c=
=PUZr
-----END PGP SIGNATURE-----

--nSDEzYKH9NcCJl81--
