Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbbAMVyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:54:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55419 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbbAMVyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:54:31 -0500
Date: Tue, 13 Jan 2015 21:54:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Wang, Jiada (ESD)" <Jiada_Wang@mentor.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Frkuska, Joshua" <Joshua_Frkuska@mentor.com>
Message-ID: <20150113215412.GS4160@sirena.org.uk>
References: <857E9EDCA6C0904DB3357321AA9123EB0108B66919@NA-MBX-01.mgc.mentorg.com>
 <s5h1tmyiof7.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="h1wVxq8aeHrvhZJz"
Content-Disposition: inline
In-Reply-To: <s5h1tmyiof7.wl-tiwai@suse.de>
X-Cookie: Keep out of reach of children.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] unload Audio drivers while playback stream is
 active case kernel crash
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h1wVxq8aeHrvhZJz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 13, 2015 at 06:24:44PM +0100, Takashi Iwai wrote:
> Wang, Jiada (ESD) wrote:

> > I am using i.MX6Q sabreSD board, which have imx_wm892 machine driver, wm8962 codec and SSI CPU DAI,

> > I got Kernel crash when unloading audio drivers (playback stream is active)
> > modprobe -r snd_soc_imx_wm8962
> > modprobe -r snd_soc_fsl_ssi
> > modprobe -r snd_soc_wm8962

> The root problem is that you can unload the module while playing.
> The corresponding module refcounts should have been increased during
> used.

> Do we miss [try_]module_get() somewhere in ASoC?

That doesn't help, users can still forcibly unbind the driver at runtime
without loading the module - and there's always the potential for
actually hotpluggable hardware.  The teardown paths should be able to
cope somewhat gracefully.

--h1wVxq8aeHrvhZJz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUtZQDAAoJECTWi3JdVIfQVyEH/jBw/OD99r5/pJZMvDz4EdNF
TX1y+8BXS79WX1p/wjKiIprDjoTxENquiv6/VmdEkFp6sFLbVfret6RF15s1HtZ2
5t0NKwSvHmzgKlSkb+1mALN/ZrUyAeCwRwy1JEOof4MBAk17lhxwMJvtbgpJewzS
0bqmAry3HCKoVtFCKNIcVUQDY9PL9Hp5xwPIM1yaXC8DRcEql0vVsSWLSYPEpUws
kjV4yRs4+rTOdnh9B6PUC/XIbUPOIQXJNBVHTfc1DmSTmZKkHthtI8xCCfltWDAC
jRMntMmD7TY9p4LvPqgVHa3w8btKVAGV7v5vK2wYyZmeno5KTZ0O49b7GurSIrc=
=+jkT
-----END PGP SIGNATURE-----

--h1wVxq8aeHrvhZJz--
