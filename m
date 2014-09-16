Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbaIPSc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:32:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45581 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbaIPSc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:32:56 -0400
Date: Tue, 16 Sep 2014 11:32:31 -0700
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: Shengjiu Wang <shengjiu.wang@freescale.com>, shawn.guo@freescale.com,
        timur@tabi.org, Li.Xiubo@freescale.com, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Message-ID: <20140916183231.GW7960@sirena.org.uk>
References: <1410867994-32138-1-git-send-email-shengjiu.wang@freescale.com>
 <20140916180028.GA6784@Asurada>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WqTjpp3GQTmREKEt"
Content-Disposition: inline
In-Reply-To: <20140916180028.GA6784@Asurada>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_spdif: don't change the root clock rate of
 spdif in driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WqTjpp3GQTmREKEt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 16, 2014 at 11:19:28AM -0700, Nicolin Chen wrote:

> So I think, if it's a shared clock, we should not define it as a
> rate-changeable one in the SoC level, as we might still have some
> SoCs provide a dedicated clock to S/PDIF so as to get the maximum
> range of clock support for users.

> @Shawn
> Sorry to involve you in this topic. I'm not so sure if we can do
> this in the clock driver so that the clock rate would be fixed
> even if the driver is trying to change it. If we can, I think we
> may use a better solution here instead.

I tend to agree here.  My first thought here is that we should have
support in the clock API for constraining clocks in the clock API so we
can still set the clock where there's a possibility to do that.  Not
trivail to implement though.

--WqTjpp3GQTmREKEt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGII+AAoJECTWi3JdVIfQIvQH/j2M+9wF9bsoaA5a9C0ez09n
XNDSYe0ckk6/FufDwY0Jhan6FjtTSNIq159kQtqjL3GnuXJww0ZOabmHGDRWBedY
CZ5D4NDvoBnN0KBxzO3UqOvRFBFBlfFz8kKG6H+Usl899qBI3cvXBxol/wWK1vAx
giDr48DV6V/g6WEuFA7ESndZzXbGYjzLxrUCdHMwliAK2AAMtr23kE1PJofVkBoh
Iki9hDPuIKpcr6YBHFNWngyMuzo7lO3CCXraABZ1lXvLSZuE71ltjPcfwSf/RHc6
SRqmYtmYoDrCqyAJACCjeBb6y6oTY1xEPkUIIfeM2hyv0/yET5hWKQzqVTkvBK4=
=eDxO
-----END PGP SIGNATURE-----

--WqTjpp3GQTmREKEt--
