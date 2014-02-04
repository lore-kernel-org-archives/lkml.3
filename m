Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaBDSGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:06:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35374 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaBDSGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:06:42 -0500
Date: Tue, 4 Feb 2014 18:06:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Message-ID: <20140204180625.GM22609@sirena.org.uk>
References: <cover.1391274627.git.moinejf@free.fr>
 <1b15025671d9099863a3091346536e45891e4a26.1391274628.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EJCnrJiDxBM3d8Vu"
Content-Disposition: inline
In-Reply-To: <1b15025671d9099863a3091346536e45891e4a26.1391274628.git.moinejf@free.fr>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 4/5] ASoC: tda998x: adjust the audio hw parameters
 from EDID
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EJCnrJiDxBM3d8Vu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 27, 2014 at 09:48:54AM +0100, Jean-Francois Moine wrote:

> +		/* change the snd_soc_pcm_stream values of the driver */
> +		stream->rates = rate_mask;
> +		stream->channels_max = max_channels;
> +		stream->formats = formats;

> +	/* copy the DAI driver to a writable area */
> +	dai_drv = devm_kzalloc(&pdev->dev, sizeof(tda998x_dai), GFP_KERNEL);
> +	if (!dai_drv)
> +		return -ENOMEM;
> +	memcpy(dai_drv, tda998x_dai, sizeof(tda998x_dai));
> +

The code should be doing this by setting constraints based on the
current setup rather than by editing the data structure - the expecation
is very much that the data won't change so this prevents surprises with
future work on the core.

--EJCnrJiDxBM3d8Vu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8SweAAoJELSic+t+oim9kLgP/2YWNETHFss7iQze9oPo+UMv
85VolGPTj7pipx3EgSf9S8y/2Cb/JnkiAw5dwVMhXsgJFoFVWFUA1Ryw3FsAfYh6
M3QsLTIQ89WuQmv3rkVPzbKNFaGFC2v1+A1yTvNQyT7Eq/5DZXEDsZIFIgzADw1n
4Z5EX8uZpNMyRXSAEvV1SQvvEWJnLgQVnCLOoLdX7B9zGZGgE2xLdAyWPBg3bFVD
0XoSVpfN9AFONY8MZ7ed/1RUaEGR2/kKjo6+GGgHm2oQFQpl3EX95zQwvoPlJu6p
gJ2BjDIAkt2wXYAHxmHf7ENFmyDkzR0UnP0hcIrpTf99VAfyJYd+Lr9F7u7Tnof+
fKbnhohO+wvyKgwg/le11pjJ2Tolp69nFtocLiCuq+yka3Ej0bkoZ4X8EQzOlcsh
g/FpCVhpT4AzwjG4U/Bt+jXLXnlzPwzrrA1+ZZVZVHLwbKfOUHKchvHrDNGPdRp8
M6hwgEPsVpLhPpmsY4YT29HzxrNEXaT/rGpbY6Ae9uxkXMb+mriGtduldTfJUQ43
6WdUh/LavruQfh27QjH/ivXOrscuv4mqcs7++jgfHD7p2TWR/8YpxrMFpXZupqOx
XiRBP5CDK1h9kPTMMmuKOoUPbWsFAhggbYq2/qUMJv5h70ta63XQVi8pyxMXDyoo
89cbDjJn3nQ7VnqoKgam
=3BW0
-----END PGP SIGNATURE-----

--EJCnrJiDxBM3d8Vu--
