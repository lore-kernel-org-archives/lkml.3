Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3KASlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:41:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43799 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3KASlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:41:02 -0400
Date: Fri, 1 Nov 2013 11:40:08 -0700
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
Message-ID: <20131101184008.GF2493@sirena.org.uk>
References: <1383289495-24523-1-git-send-email-Li.Xiubo@freescale.com>
 <1383289495-24523-7-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1+kiJ7gFzGEgD6MU"
Content-Disposition: inline
In-Reply-To: <1383289495-24523-7-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 66.78.236.243
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 6/8] ASoC: fsl: add SGTL5000 based audio machine driver.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1+kiJ7gFzGEgD6MU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 01, 2013 at 03:04:53PM +0800, Xiubo Li wrote:

> Conflicts:
> 	sound/soc/fsl/Makefile

Ahem.

> +	/* TODO: The SAI driver should figure this out for us */
> +	switch (channels) {
> +	case 2:
> +		snd_soc_dai_set_tdm_slot(cpu_dai, 0xfffffffc, 0xfffffffc, 2, 0);
> +		break;
> +	case 1:
> +		snd_soc_dai_set_tdm_slot(cpu_dai, 0xfffffffe, 0xfffffffe, 1, 0);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}

Yes, it should - this code should probably just be copied straight into
the SAI driver.  If we need to support other configurations we can do
that later.

> +static int fsl_sgtl5000_remove(struct platform_device *pdev)
> +{
> +	snd_soc_unregister_card(&fsl_sgt1500_card);
> +
> +	return 0;
> +}

You're using snd_soc_unregister_card() so you don't need to do this.

--1+kiJ7gFzGEgD6MU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSc/WFAAoJELSic+t+oim9Ro4P/3xf1v287JoZR9nyoMd0771B
F1Bk7L3WgUf6Uh5CqBQP+50g1Utl3RgKxDsNKLraQcFx551slcVooB+UY2itoaVa
aPIruEjPjezEwCufZiq4zysesLER7BxeBZNGpXU8qwALxyf/WfRQWo8pJCd4798t
ANucUXbO2ekgHkCmdb2+f3v6Alm1s/ZiSoyDYKKcM9BJWSc3QZL3/3lxKaqeBTC/
FS5F13y6QBjpPNQv/Js9TvvZvbO3BeBBGvrhl9mCWxI5r2xg7Ei8m+tHPsDveJBM
Jrk/VnZ++x1/gbIx1+b8mfiClRc5gi8eZx2F+bDUqyEFfM0yXxHCtJwgYA2AuUzr
gTwnSAUXnwUgbx+D9/Go8AReABYfZTUd9W+ojqgaZauhjegWf7qA2c1uXtuv0Uul
s4VsUei18tbpLd1d1aiq3keCKjPExczv825fAQswyOYYK5B+1LCQBWRg0tpgkV2E
DRyooyJPEqUvtzHjccIDZhyFpi80q28fLO0BwVdhN3biiKC0LEnRssPOzmw/DaHM
Tcyxz51G240vXTf7yzoj+JL+wCybt73GjVke7MmNGKe4qpc1vOeo6q/8bY7eSprm
EJ2PPtzz+3QQNSjPCVKh6i6DpfVDvfe467w8nQdQDRppMYgOZ2ZbQDiew0XdxMgn
warO8G6CTyjEs5cC3h+0
=Px4Z
-----END PGP SIGNATURE-----

--1+kiJ7gFzGEgD6MU--
