Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab3LRS1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:27:55 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53010 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab3LRS1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:27:54 -0500
Date: Wed, 18 Dec 2013 18:27:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, timur@tabi.org, perex@perex.cz, r64188@freescale.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        linux@arm.linux.org.uk, tiwai@suse.de, grant.likely@linaro.org,
        fabio.estevam@freescale.com, LW@KARO-electronics.de, oskar@scara.com,
        shawn.guo@linaro.org, b42378@freescale.com, b18965@freescale.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org
Message-ID: <20131218182731.GE31886@sirena.org.uk>
References: <1387250684-23406-1-git-send-email-Li.Xiubo@freescale.com>
 <1387250684-23406-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="imjhCm/Pyz7Rq5F2"
Content-Disposition: inline
In-Reply-To: <1387250684-23406-2-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv3 1/7] ALSA: Add SAI SoC Digital Audio Interface driver.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--imjhCm/Pyz7Rq5F2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 11:24:38AM +0800, Xiubo Li wrote:

> This adds Freescale SAI ASoC Audio support.
> This implementation is only compatible with device tree definition.

This is mostly good, there are two small issues below but I've applied it
since they don't really affect the driver as a whole.  Please send
followup patches to fix the issues below.

> +static int fsl_sai_dai_probe(struct snd_soc_dai *cpu_dai)
> +{
> +	struct fsl_sai *sai = dev_get_drvdata(cpu_dai->dev);
> +
> +	cpu_dai->playback_dma_data = &sai->dma_params_tx;
> +	cpu_dai->capture_dma_data = &sai->dma_params_rx;

You should use snd_soc_dai_init_dma_data() for this.

> +static int fsl_sai_dai_remove(struct snd_soc_dai *cpu_dai)
> +{
> +	cpu_dai->playback_dma_data = NULL;
> +	cpu_dai->capture_dma_data = NULL;
> +
> +	snd_soc_dai_set_drvdata(cpu_dai, NULL);
> +
> +	return 0;
> +}

This is all unneeded and this function should be removed entirely.

--imjhCm/Pyz7Rq5F2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsekQAAoJELSic+t+oim9g84P/RSFPoCuxEBr1z4cGdl7J/F3
aB2NYBFswtsNsQF9zAx2FSIottzgmzW+nsPZ3a+0C8/NF4KNpEJRLhutqu5gVlcd
d9WIkLggoyTKDef1w4AFv1FDP2Mhax2CUnMCcQluizxQjRYZ6JNprZg7F5HoLv/U
oNIQ5IrN81c4fBLTinDklI1yhtFz2WjQFdUYuzXOHDBWRTEwZrYKtwahbGHS5jxV
OURlNw3rxU9Xxsk4mhj24LE6wmp3SJVhfNoawPKt6fR4z8PEPRUCpH/9Cqjwxfzz
tMmW30oAGyVLsXQmNX/H4fpUhw6dBxzw91y0qMXoD6oG9Td12Ymt8GtOL7FUl7xi
Ki7JyTBLa2DXw3rrBMSfPB6QRGoKL2m1DaSeh+5RX1R+yYOhHtcgGjh17ja/QPzd
Z33OyFY4wrgLPVzgtiE3cs63wy02l3eJFLKkXJKYmeYkp08U6gB1JZhwIq1Gbqe2
+q2TjMUYXvPE26Bt+0X7GZfFrmqL5ld4RRhTWNDyH++4uE2niUu3PHp85OMfZn8s
yyjca23F/oNuqas6PCr+3vetcyCoI06MElHRwGX3oUPsX63GmdjQzbdfCwxSM6Ux
G4LBY7InBNSb3zTMH69LuiENSu/uwf85dy9B3VT9FmK03dZbS52p/5ByW1vGg24G
VbXZtwZ7Fb4OLks7Zjzj
=Rc6B
-----END PGP SIGNATURE-----

--imjhCm/Pyz7Rq5F2--
