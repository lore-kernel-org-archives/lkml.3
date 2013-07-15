Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab3GOW6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:58:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36346 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab3GOW6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:58:42 -0400
Date: Mon, 15 Jul 2013 23:58:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130715225836.GG11538@sirena.org.uk>
References: <20130715103644.04e57749@armhf>
 <20130715153101.GK11538@sirena.org.uk>
 <20130715203756.68abbf10@armhf>
 <20130715200851.GD11538@sirena.org.uk>
 <20130715213727.GW24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M8g8Xvd1npd+rU3W"
Content-Disposition: inline
In-Reply-To: <20130715213727.GW24642@n2100.arm.linux.org.uk>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: kirkwood-i2s: fix a compilation warning
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M8g8Xvd1npd+rU3W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 15, 2013 at 10:37:27PM +0100, Russell King - ARM Linux wrote:
> On Mon, Jul 15, 2013 at 09:08:51PM +0100, Mark Brown wrote:

> > There's no obvious code that handles anything differently with extclk.
> > Indeed if you think about it for a minute you'll realise there's no way
> > the driver will ever use an extclk - set_rate() is badly implemented,
> > look at how other drivers select between clocks.

Actually looking some more it's not actually a normal set_rate() call
but rather something done transparently inside the driver - given that
the automatic source selection is OK.

> I suggest you go back and re-read the driver because it most certainly
> does use extclk.  What makes you think it won't?

The only thing I can see which is pushing a constraint up the stack is
KIRKWOOD_I2S_RATES in the DAIs which only allows 44.1kHz, 48kHz and
96kHz, the rates for which the internal clock is used.  The driver will
happily request the external clock and hold a reference to it but if
there's code there to tell the upper layers that extra rates are
supported I'm missing it and without that any attempt to use anything
else should be rejected by the stack.

Note that regular ALSA will do some sample rate conversions in software
automatically so if you're not testing with something like "aplay
-Dhw:0,0" that bypasses those then the hardware may not be running at
the same rate as the application.

--M8g8Xvd1npd+rU3W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5H6ZAAoJELSic+t+oim9pvIP/30quvdpwldEsLw7UcuHALw+
ANPbthjejs7RPPdSjj71OkO3kuNafGkic5jB8XEfnOdksT63y225GtvLGcPvxaT/
BQEIarLhK2vt+WuW+AGZ2u7GcJU5AY8mp6pYImPM4K7lT9qttHJ5n8b/f9GYh76x
18UDPPQKQSn6Viz5fwzCQDaKx3IL2e/GSNsRPcqsBTDZogI1e8fMQL6w2BoZTzJD
XKVFFKALN9Vcg0OaLDJ0dbKlxVOcPElfli0wFmLXFzTr+3lXYf8g252Yg+XVJHXS
deRiT9ns/0ddr4Aq6I+qk+UPqaE0JtauGSb3kpBtaUqzBh4TP+Ng4FLsRLQWma4L
PbpvRdAZ6326cqEo7pVhMzoK5BiWa3Hq8Innt9QxdV2qi2GnWkv+niA/bvgkJMMN
41i3sU5duhiDfJ16kgFqVzK4RDG3z1RYsP8vpQmi2ES/60J93vVUvV4yhAVV1Lqj
TCf+/XHnovfR0P++zIuA0/88SNYH/uMbceEBpV1kIp408XUde6Yk4K20Rt7TcKTt
tISXqoqk3QwAIXOlhRu3WnD9JpD6QJ3lm/VcRZkLYOJvR9tKW0dkrxUCq+qHOLmU
HVxK7Jwn0LPMkKJGk/m8PVgx0AzjrBtIFUiKIns8pkl6n3fapj0UlNaA4nNMQJ9s
B8iPJL0oi8P/sfxqVoQO
=nqOc
-----END PGP SIGNATURE-----

--M8g8Xvd1npd+rU3W--
