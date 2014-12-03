Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaLCR3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:29:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47281 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaLCR3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:29:52 -0500
Date: Wed, 3 Dec 2014 17:29:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Liviu Dudau <Liviu.Dudau@arm.com>
Message-ID: <20141203172928.GD7712@sirena.org.uk>
References: <547F3CA5.2010500@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zQ8NwhwM3vlijoHM"
Content-Disposition: inline
In-Reply-To: <547F3CA5.2010500@arm.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] ASoC: dwc: Iterate over all channels
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zQ8NwhwM3vlijoHM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 03, 2014 at 04:39:01PM +0000, Andrew Jackson wrote:

> +	/* Iterate over set of channels - independently controlled.
> +	 */
> +	do {
> +		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
> +			i2s_write_reg(dev->i2s_base, TCR(ch_reg),
> +				      xfer_resolution);
> +			i2s_write_reg(dev->i2s_base, TFCR(ch_reg), 0x02);
> +			irq = i2s_read_reg(dev->i2s_base, IMR(ch_reg));
> +			i2s_write_reg(dev->i2s_base, IMR(ch_reg), irq & ~0x30);
> +			i2s_write_reg(dev->i2s_base, TER(ch_reg), 1);
> +		} else {
> +			i2s_write_reg(dev->i2s_base, RCR(ch_reg),
> +				      xfer_resolution);
> +			i2s_write_reg(dev->i2s_base, RFCR(ch_reg), 0x07);
> +			irq = i2s_read_reg(dev->i2s_base, IMR(ch_reg));
> +			i2s_write_reg(dev->i2s_base, IMR(ch_reg), irq & ~0x03);
> +			i2s_write_reg(dev->i2s_base, RER(ch_reg), 1);
> +		}
> +	} while (ch_reg-- > 0);

The normal way to write an iteration would be with a for loop - why are
we not doing that?

Also I see that you've not sent these as a single thread - please use
--thread.

--zQ8NwhwM3vlijoHM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUf0h4AAoJECTWi3JdVIfQKLoH/jI01C2bJv35idBSukiQiqZY
DYsbEZn5V8adHt6SH77H6LjKuHVah0T7AkZgCgKvRDGGXHOQvND2mmpRBfAAozI1
194oO+CZ/pcsDkw58J98pcjG3MJz3BUeGilePxfIaQ4OdgDSVO1ToREUpMki6SNJ
Z0qRpBmLofP71cAQmPKi7qNOs0twVWxn49bs1oDy44tuLwb2/4erzYRc96xMnT8g
ocCGgDlcSFoU3+ZZmKXMwjO5TZFV4g2XzCJCttk5C9oof9ktI/qvALLfKeRaCYO7
PrODbwGdPgV3yVflm8yj2pjt4hEGw+h89mYF9zsdED99HjC/rucm/0Ix3LEPHwM=
=uwx3
-----END PGP SIGNATURE-----

--zQ8NwhwM3vlijoHM--
