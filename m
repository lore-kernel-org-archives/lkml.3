Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab3KAS01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:26:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42080 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3KAS0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:26:25 -0400
Date: Fri, 1 Nov 2013 11:25:14 -0700
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, timur@tabi.org, lgirdwood@gmail.com,
        r64188@freescale.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, linux@arm.linux.org.uk, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, fabio.estevam@freescale.com,
        LW@KARO-electronics.de, oskar@scara.com, shawn.guo@linaro.org,
        b42378@freescale.com, b18965@freescale.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Message-ID: <20131101182514.GE2493@sirena.org.uk>
References: <1383289495-24523-1-git-send-email-Li.Xiubo@freescale.com>
 <1383289495-24523-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hjFmXiTvfEJBEd4m"
Content-Disposition: inline
In-Reply-To: <1383289495-24523-2-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 66.78.236.243
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 1/8] ALSA: Add SAI SoC Digital Audio Interface driver.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hjFmXiTvfEJBEd4m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 01, 2013 at 03:04:48PM +0800, Xiubo Li wrote:

> +static int fsl_sai_set_dai_clkdiv(struct snd_soc_dai *cpu_dai,
> +		int div_id, int div)
> +{
> +	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
> +	u32 tcr2, rcr2;
> +
> +	if (div_id == FSL_SAI_TX_DIV) {
> +		tcr2 = readl(sai->base + FSL_SAI_TCR2);
> +		tcr2 &= ~FSL_SAI_CR2_DIV_MASK;
> +		tcr2 |= FSL_SAI_CR2_DIV(div);
> +		writel(tcr2, sai->base + FSL_SAI_TCR2);

What is this divider and why does the user have to set it manually?

> +	} else
> +		return -EINVAL;
> +

Coding style?

> +static int fsl_sai_dai_probe(struct snd_soc_dai *dai)
> +{
> +	int ret;
> +	struct fsl_sai *sai = dev_get_drvdata(dai->dev);
> +
> +	ret = clk_prepare_enable(sai->clk);
> +	if (ret)
> +		return ret;

It'd be nicer to only enable the clock while the device is in active
use.

> +	ret = snd_dmaengine_pcm_register(&pdev->dev, NULL,
> +			SND_DMAENGINE_PCM_FLAG_NO_RESIDUE);
> +	if (ret)
> +		return ret;

We should have a devm_ version of this.

--hjFmXiTvfEJBEd4m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSc/IHAAoJELSic+t+oim9rBkP/A0JFjGit6Y3Zo+3J28ul2QB
PvJCI/B5f6vmMxp5NWemjLgvSf+X7Vazu/v80gBZuVFM3nei+N9ReysV0eTahsj1
bCRpEPRkeNEl2w3S0135kF3yDUJfehrZaGRQwt8yNUh/VZA28SSA4qlMt0q5XdDd
Dxg9aHXBqnQ1C2jVRvkqV9aN30qxJC0FsW6amVu8hd7YYBDZV4shswE27E2UevLa
9soL8GPTjlLdntQMkaRjkuUHKhxCYfAlIB4JSL11YOKl8ZyXtNt3wcSaZZy5Rtfw
+lq5ZRLQkepfxOu9ImR98Bds+HbUAxoXQlDdBpBuSGs4icbHRISYTU4DEONN55px
C0Y7r815ruXcjq0Hn8zLVGytgna8mb0KiwaTCvYQ7X2Mw8dp6zgMgYqNVpNPt9LF
WA03+IGRe6+WWHeCYSYRY4fh9DFh1wQ+are8qY0tJTCoNaoVW1am3D2+0gJKECZg
Gytfdn8UIV8RYLEuD+F1pMGu8ik9iFoCVmGFBeYDClJTGmSDAolqJr70YBs9t6S5
CWAZvH+yZLodn6Doid6LydZLZE4A5hxZUAOW/c8m3Z75Z+nD8sbNeVPLgnQ58wai
WSZdyFjrNh9XUbFAySSmlJ3aYA7T8fIKIHCtcPZAX5hYGpagpWG9sgVHkAKO16+v
eGM2IulA5cJGsLmk7YAh
=Sj0u
-----END PGP SIGNATURE-----

--hjFmXiTvfEJBEd4m--
