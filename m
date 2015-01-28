Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbbA1U4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:56:19 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54067 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbbA1U4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:56:14 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH] ASoC: rx51: do not fail if could not get jack detection gpio
Date: Wed, 28 Jan 2015 15:09:17 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
References: <1422305507-10533-1-git-send-email-pali.rohar@gmail.com> <54C79597.40105@ti.com> <201501271511.08933@pali>
In-Reply-To: <201501271511.08933@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1989159.qfoVUJsl4f";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501281509.17333@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1989159.qfoVUJsl4f
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

> > > It is quite important to keep qemu working, really.
> > > Debugging early boot on hardware is very hard, for
> > > example.
> >=20
> > I understand, but looking at the history of the driver, if
> > it fails now with the jack-detection GPIO, it should have
> > been failing in the past as well. What triggered this
> > sudden qemu does not like jack-detection GPIO? Before the
> > devm_gpiod_get() conversion the driver should have failed in
> > snd_soc_jack_add_gpios() phase.
>=20
> With 3.12 kernel rx51-audio driver loads without any problem.
> So there is some regression. Here is dmesg log from 3.12
> kernel:
>=20
> [    1.123779] rx51-audio rx51-audio:  tlv320aic3x-hifi <->
> omap- mcbsp.2 mapping ok
> [    1.130737] tlv320aic3x-codec 2-0019: ASoC: mux b Right
> Line1L Mux has no paths
> [    1.131347] tlv320aic3x-codec 2-0019: ASoC: mux b Left
> Line1R Mux has no paths
> [    1.133697] tlv320aic3x-codec 2-0018: ASoC: mux Right
> Line1L Mux has no paths
> [    1.134307] tlv320aic3x-codec 2-0018: ASoC: mux Left Line1R
> Mux has no paths
> [    1.137451] input: RX-51 AV Jack as /devices/platform/rx51-
> audio/sound/card0/input2
>=20
> I will try to investigate where is problem...
>=20

Ok, problem found and solved. Please drop my patch and sorry for=20
a noise.

As is visible in above lines AV Jack is working fine on non DT=20
kernel (3.12) and fails on DT kernel.

Reason is because I have another non-mainline driver which is=20
using GPIOs and in non DT kernel is initialized *after* audio.=20
And in DT kernel is initialized *before* audio.

Once I changed my non-mainline driver to not request av jack=20
gpio, rx51-audio driver loads fine in qemu.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1989159.qfoVUJsl4f
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTI7Y0ACgkQi/DJPQPkQ1K5WACfcXmeUks3GiUTeE/3+sb31nrQ
3nEAn3P9MzMyEo/b82MHnM5kGlrMjn0W
=kDoz
-----END PGP SIGNATURE-----

--nextPart1989159.qfoVUJsl4f--
