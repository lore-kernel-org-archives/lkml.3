Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3L3MPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:15:46 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50258 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab3L3MPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:15:45 -0500
Date: Mon, 30 Dec 2013 12:15:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: shawn.guo@linaro.org, timur@tabi.org, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        b47053@freescale.com
Message-ID: <20131230121520.GR31886@sirena.org.uk>
References: <1388026642-1464-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="99FKeZQ5IARcBmLz"
Content-Disposition: inline
In-Reply-To: <1388026642-1464-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Fix one bug for hardware limitation.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--99FKeZQ5IARcBmLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 26, 2013 at 10:57:22AM +0800, Xiubo Li wrote:
> This is maybe one bug or a limitation of the hardware that the {T,R}CR2's
> Synchronous Mode bits must be set as late as possible, or the SAI device
> maybe hanged up, and there has not any explaination about this limitation
> in the SAI Data Sheet.

If they really should be set as late as possible then I'd expect them to
be being set in the trigger function, that's what gets called as the
audio actually starts streaming.  This is moving it to the startup
function which is one of the first things that happens during audio
stream setup so presumably makes things worse.

Also...

> @@ -62,6 +62,7 @@ static int fsl_sai_set_dai_sysclk_tr(struct snd_soc_dai=
 *cpu_dai,
>  		reg_cr2 =3D FSL_SAI_RCR2;
> =20
>  	val_cr2 =3D sai_readl(sai, sai->base + reg_cr2);
> +
>  	switch (clk_id) {
>  	case FSL_SAI_CLK_BUS:
>  		val_cr2 &=3D ~FSL_SAI_CR2_MSEL_MASK;
> @@ -82,6 +83,7 @@ static int fsl_sai_set_dai_sysclk_tr(struct snd_soc_dai=
 *cpu_dai,
>  	default:
>  		return -EINVAL;
>  	}
> +
>  	sai_writel(sai, val_cr2, sai->base + reg_cr2);
> =20
>  	return 0;

These appear to be unrelated changes - please send as a separate patch
if they're useful.

--99FKeZQ5IARcBmLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwWPVAAoJELSic+t+oim9Q9kQAJKZnwLZ5pE0ty4KCli4IzUG
S82G1YCQqQSMkEhJkauo16yfnoFLUIFwbvEm+MRwG5TgsUeBaFjKlrlMugh3c6Q+
9T/uIUpXrmsmTXW8mmGPUrKGppdkYxNL5+LOHqYDVi/NiceZ5guJl3ql/aInUZs/
0EI29sF4MwYJLNHuxXf2eoWyqrwhSAc3yg4MRuzKL9CdQU11Ym3V63sgCJa8ouFU
7n9Smpzv08yd9ZWU4PgV41gDElK5pCim1GqMDl1IKEpaO6gJItwkPdEsn0m3DxMN
GF9K98PZXSrcd/YwCqt+BVcs2w8j37VGt+PuYBAmcLYZXHQjkPnsz3k/VkzfA/tk
7ibJ9tihdaZiCz8+7kOv8/kqcPRV4G6/Oht6MDFz0dtpUNo9SQQ7X42PUXyomzCU
+zQAaCyRGaguUi0xfP/JBXp9c8osdBnGoVyZeFhwRfHLr/zqXGq/sm62dRXyP1Au
LVIXIncX09RLRbiCO3IL+zWu/CHpAgUtdqYuiVOw/D+BhSF6np8qgkCwr910ZzPg
I3XohrvOzHbQ3mvfWDcsfMe3KEDzkvXX07Gh2VPH8Uop2Wg3JVY9+f5i3xylRryt
/2enkTFJ8dZmr5qfEMJaI5dq/pkdr/Ut8DdXBDEHieBmQoqSYbMzYA+yp6kG87CI
vJsaQTPlYadXdGTVDFpD
=gZsL
-----END PGP SIGNATURE-----

--99FKeZQ5IARcBmLz--
