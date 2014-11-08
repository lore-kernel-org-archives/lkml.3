Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbaKHJ22 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 04:28:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51341 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbaKHJ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 04:28:27 -0500
Date: Sat, 8 Nov 2014 09:27:56 +0000
From: Mark Brown <broonie@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        GTA04 owners <gta04-owner@goldelico.com>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141108092756.GD2722@sirena.org.uk>
References: <20141108002637.6561.19002.stgit@notabene.brown>
 <20141108003803.6561.52497.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tNQTSEo8WG/FKZ8E"
Content-Disposition: inline
In-Reply-To: <20141108003803.6561.52497.stgit@notabene.brown>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.249
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] ASoC: twl4030: enable routing audio to 'voice'
 interface.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tNQTSEo8WG/FKZ8E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 08, 2014 at 11:38:03AM +1100, NeilBrown wrote:

> -		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
> -				 TWL4030_VIF_TRI_EN,
> -				 TWL4030_REG_VOICE_IF);
> +		/* These pins only relevant when voice_fmt set */
> +		snd_soc_dapm_disable_pin(&codec->dapm, "VOICEIN");
> +		snd_soc_dapm_disable_pin(&codec->dapm, "VOICEOUT");

Given your previous patch are these trying to control a digital link by
any chance?  If they are they should be removed, and in any case this
sort of thing looks like a machine driver issue.

--tNQTSEo8WG/FKZ8E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXeIbAAoJECTWi3JdVIfQIOkH/3ug7ukrOkoPOX1v91P+ARp0
MCoF3gHSuC30ByYg+6bAGGnh7KDtVj212d8w7MTe/6koanVIuff4wf8yP8HMzEtP
8DYXaUYP6N1vDU62OyjZ97QY0Pn763SxuCZtClklRab6/90E2edF9W6lfkSMOlkD
5KwQuWyaoiNQdPR1OTqMibwSAAdbCNqb8oM1c0hEQx/sODNahJBQYkLotcDzJBGq
QxTNLREQxErucpoQykQJ1VByktUMrb2KYtGKJE31+tLXnTNaQOAmAWCmvrlTLYA3
QRQov3ehLaFAWhlHLyqx2O3xY6qKjZ1fZS+oYVCB8HJ/JC2fvK9LCcgGzvKmvLg=
=q6+A
-----END PGP SIGNATURE-----

--tNQTSEo8WG/FKZ8E--
