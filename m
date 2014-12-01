Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbaLATYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:24:48 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45346 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbaLATYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:24:46 -0500
Date: Mon, 1 Dec 2014 19:24:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Markus Pargmann <mpa@pengutronix.de>, Jiada Wang <jiada_wang@mentor.com>,
        alsa-devel@alsa-project.org, lgirdwood@gmail.com, tiwai@suse.de,
        Li.Xiubo@freescale.com, timur@tabi.org, nicoleotsuka@gmail.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Message-ID: <20141201192422.GL7712@sirena.org.uk>
References: <1417402251-6596-1-git-send-email-jiada_wang@mentor.com>
 <20141201065046.GB27289@pengutronix.de>
 <547C9C34.9080602@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YsbR7IM8mFrcghHU"
Content-Disposition: inline
In-Reply-To: <547C9C34.9080602@metafoo.de>
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


--YsbR7IM8mFrcghHU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 01, 2014 at 05:49:56PM +0100, Lars-Peter Clausen wrote:
> On 12/01/2014 07:50 AM, Markus Pargmann wrote:

> >devm_request_irq() is used by other drivers too, this should not be a
> >problem. Looking at the code it seems that irq_dispose_mapping may not
> >be necessary with devm_request_irq(). So I think it would be better to
> >remove irq_dispose_mapping() instead.

> The driver creates the mapping by calling irq_of_parse_and_map(), so it also
> has to dispose the mapping. But the easy way out is to simply use
> platform_get_irq() instead of irq_of_parse_map(). In this case the mapping
> is not managed by the device but by the of core, so the device has not to
> dispose the mapping.

It also has the advantage of not being DT specific so providing some
chance that future firmware interfaces can be supported without driver
modification.

--YsbR7IM8mFrcghHU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfMBmAAoJECTWi3JdVIfQQQIH/iCp85C3j3tZK021HeqxyEwY
1QWrbS+5j6rW3D+UcSC/BYqRF+ClS/1ZOeFgH5b6hP4Jp1ng00iYKOaCkv3EdqRh
DULbFmlBPkEnV8Zrq4yZ64Lmjdfg1JcSZ+iwsqkIU4RuI67BmFLKlcOtapojKSby
SCCjRe1LJBGlb1IgO/5Rnv1Clesu5OBblyL0xMDAp54QWVD2fGtVwhxk3KjC3G0o
oqbhdZ77Y0P97IH8RYBj4xZU5AN32KgE65PvQTYRvwmcknG09gMoELs45XLzcP0w
5fqwPGZvRLGxqkBbHxITRPVYqTD7QmmB1mn7HsamDycHOwMFjdFHmwCcVb0gyn8=
=hd9f
-----END PGP SIGNATURE-----

--YsbR7IM8mFrcghHU--
