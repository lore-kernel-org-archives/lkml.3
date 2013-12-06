Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab3LFOnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:43:23 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51850 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3LFOnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:43:22 -0500
Date: Fri, 6 Dec 2013 14:42:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <b42378@freescale.com>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org, tiwai@suse.de,
        perex@perex.cz, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org, rob@landley.net,
        ijc+devicetree@hellion.org.uk, swarren@wwwdotorg.org,
        mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com
Message-ID: <20131206144256.GI29268@sirena.org.uk>
References: <cover.1386322845.git.b42378@freescale.com>
 <82d3285b7efe1f98dbc3d9c0a423b2e5e454481f.1386322845.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0EphSjNCSB1asamE"
Content-Disposition: inline
In-Reply-To: <82d3285b7efe1f98dbc3d9c0a423b2e5e454481f.1386322845.git.b42378@freescale.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] ASoC: fsl: imx-wm8962: Add headphone and microphone
 jack plugin/out detection
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0EphSjNCSB1asamE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2013 at 05:48:23PM +0800, Nicolin Chen wrote:

> Therefore, this patch mainly adds jack event detection feature and switchs I/O
> routes accordingly. Meanwhile, for those monaural input cases, we also turn on
> the ADC monomix features of WM8962 if needed.

No, the kernel shouldn't be doing any route switching or other
configuration - that should be done by userspace.  This is a policy
decision, there are situations where for example audio should go to both
headphones and speaker when headphones are connected in order to make
sure notifications are audible even if headpones have been removed.

> +	if (hp_status != priv->hp_active_low) {
> +		snprintf(buf, 32, "STATE=%d", 2);
> +		snd_soc_dapm_disable_pin(&priv->codec->dapm, "Ext Spk");
> +		ret = imx_hp_jack_gpio.report;
> +	} else {
> +		snprintf(buf, 32, "STATE=%d", 0);
> +		snd_soc_dapm_enable_pin(&priv->codec->dapm, "Ext Spk");
> +		ret = 0;
> +	}
> +
> +	envp[0] = "NAME=headphone";
> +	envp[1] = buf;
> +	envp[2] = NULL;
> +	kobject_uevent_env(&pdev->dev.kobj, KOBJ_CHANGE, envp);

What's this uevent trying to do and why is it open coded in the driver?

--0EphSjNCSB1asamE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSoeJtAAoJELSic+t+oim9PrcP/jmzlN6zrUrkhIfryYC1RZuo
+w3T4BDY6eZRs0y0qC7QUC9K+Bcx4sX7g8ssIJzMUoEOF1RzlOs46/ttmgZHvuyw
L0w1qolcgJyf4TLrJQiTs7X1pI/ZMCUzogDNIlGIGhAVGn2JZ5X9pWsvXyzYBhNx
Lfh+PnVgTfW93KRlBwyQZkg5ewscrDQ2GPAXMnilPmUttIJT9CDBO3PTtzOGKwjK
Fuam3KQnkNaNtJP1pIL99iWhWZVdd3uU5nmS17/Cy9Wd6jE/efpt6AYDozeyLF8H
gNxodgNkA776vgSODFl3CcHgV+4CuNkp82LpXo6RzI2hf1RaDqCNkxup6f9W179O
ACfi6Bw5wYo3oRVjvNF5fZVpOCtaBBXoUZ46dabh2YRuyfAIlG2XE0jxQoaX4M2A
nULjE/YoYTipMrfHGxvpETS4K4WJ8FhFCeKxsRn3mGQijsEmMr53Ysn/I9LPxRiE
se71+SlFlyYdPKcqYT1cqFLJ5ii1U1EzKfo2JRMHyltLc8C6DiQNBSFK/DrbvQKV
EhP9PPUXOoq79vpmyuxV1Jnv+/eXz/5QMVkaxUJSCFhF3exDFeej6BBlKvw0KC1g
jIbY/mljSjbFYqaaxfT5Ww9q6gf3ByZrcdfjnoCzpwbHkLeRFmG8gTZbK8iNsjXI
0n1c0gKpk5eHMJL+2tbZ
=IEpg
-----END PGP SIGNATURE-----

--0EphSjNCSB1asamE--
