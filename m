Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaAWSir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:38:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58667 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaAWSip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:38:45 -0500
Date: Thu, 23 Jan 2014 18:38:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, shawn.guo@linaro.org,
        kuninori.morimoto.gx@renesas.com, moinejf@free.fr,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140123183829.GB11727@sirena.org.uk>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
 <1390453370-29194-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
In-Reply-To: <1390453370-29194-2-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/8] ASoC: fsl: Add VF610 soc audio card Kconfig
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 01:02:43PM +0800, Xiubo Li wrote:

> +menuconfig SND_VF610_SOC
> +       tristate "SoC Audio for Freescale VF610 CPUs"
> +       select DMA_ENGINE
> +       help
> +         Say Y or M if you want to add support for codecs attached to
> +         the VF610 CPUs.
> +
> +         This will enable Freeacale SAI and SGTL5000 codec, and an extra
> +         TWR-AUDIO-SGTL sub-board is needed for SGTL5000.

This bit is OK but...

> +config SND_SOC_VF610_SGTL5000
> +       tristate "SoC Audio support for VF610 boards with SGTL5000"
> +       depends on OF && I2C
> +       select SND_SOC_FSL_SAI
> +       select SND_SOC_SGTL5000
> +       select SND_SIMPLE_CARD

...for simple card since the whole idea is to support any CODEC with the
same driver we should probably just make sure that all the individual
drivers can be enabled in Kconfig, that way we don't have to have
specific Kconfig entries for boards and loose some of the benefit of the
generic card.  I sent a patch earlier exposing the OF supporting CODEC
drivers, one for at least some of the Freescale CPU drivers was sent to
the list recently too but there were some review comments.

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4WGiAAoJELSic+t+oim9QAUP/RFv5AYDForSR5l3Wd+80uD4
L4j8HjDnd1kXUXmLCHoU4kg+pXJU8jXNn4qQMOUsAh+lTklr5cVy/N4Wcxck6Nwt
OLfyW9LDzDDuFyl4Y/Zn0fLZ1ZaYtCGMiCRLzNC1eVm659sl+vz/JTP0q4WWQmRq
xeEJmtJMLww47jqfgR51MdCW960ybgd3Wt38BsapWx6PEb7Pq2A99goH5cB2Xjik
5RtZpZa2KQA4qSg9AJOO/MEC2OIEJKrelNnm3CX3xpGRsOf8uttLxGMmJHGg1666
p0Hut24Ng51JwnEmmGWE6psjkf0tMhKg6dPLQw/VYAQgFhbWLvsclwO6ZofLbwr1
P5mFGdeIwSL7AFPEau7PyXylKHclWng9BrPBjeUQE539ZqSglS3QabHz981fsjK0
OG6EbQuujmQ3t2ds7fnOztt0Wh+m4GPYMjp3duhThseMK29pwcZMqaxlik9qxNao
+B0sealsirm/eZilCaT9JexGfyfw3icoeR+sSAdREFnI1NbhPwdu9Pjp2b2EJT1K
Wya+7mvYCRGmcztYWRLn5ThLzgrnqJbUfBlKGrQZcQpz7Vyzdk1TUtciuCunIJTM
6WA810W3MarJdGwWPOr9KNbrlQTyjj7BQJPfjaO7hJgGG57qYCTtF2+KXDSD67lf
94uYK2ihYioJDSe6u98X
=uZlJ
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
