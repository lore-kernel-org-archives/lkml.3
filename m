Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab3GOX3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:29:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39746 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab3GOX3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:29:41 -0400
Date: Tue, 16 Jul 2013 00:29:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130715232921.GH11538@sirena.org.uk>
References: <20130715103644.04e57749@armhf>
 <20130715153101.GK11538@sirena.org.uk>
 <20130715203756.68abbf10@armhf>
 <20130715200851.GD11538@sirena.org.uk>
 <20130715213727.GW24642@n2100.arm.linux.org.uk>
 <20130715225836.GG11538@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zVyz+SkbhTrRQGHt"
Content-Disposition: inline
In-Reply-To: <20130715225836.GG11538@sirena.org.uk>
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


--zVyz+SkbhTrRQGHt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 15, 2013 at 11:58:36PM +0100, Mark Brown wrote:
> On Mon, Jul 15, 2013 at 10:37:27PM +0100, Russell King - ARM Linux wrote:

> > I suggest you go back and re-read the driver because it most certainly
> > does use extclk.  What makes you think it won't?

> The only thing I can see which is pushing a constraint up the stack is
> KIRKWOOD_I2S_RATES in the DAIs which only allows 44.1kHz, 48kHz and
> 96kHz, the rates for which the internal clock is used.  The driver will

Ugh, I just saw the dai_extclk stuff.  That's probably also problematic
the other way - it'll break if someone decides to put a non-programmable
clock on there, or something that can't generate arbatrary frequencies
like a crystal plus divider.  It's also not clear to me why the driver
ever uses the internal clocks if something external has been provided.

This does mean the change is safe, though - but it needs to be called
out in both the code and the changelog how this is happening.

--zVyz+SkbhTrRQGHt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5IXOAAoJELSic+t+oim98woP/iX+zHMbR4Tm/9Ip8AjuGkwc
UEiKzpnWhknyhQtWk9ZSnxULCmPQ27kPyTCamFXDWqjkcsL1dxs1BGt2/JjSJHRq
zukmSls6vZBN59cH9xS9jGJciJhebcbXuKahRAwcixyaTWl4dM+DTRAELZPtUC6Z
Y175bqz8kPgSHfwUa3ry4uTTDesBbJFaWT5A79Bz7xZ2viqGFg8TbqDX2GnxlZcT
d7y0/BCQQIjI1JoYzWPn7/MU0+I+j07KCtcdAec8aS57i13F/aze/AgqOUb6/apO
yc/TColsMI22F3lf0yss8N1dXhdFTHZP0M6EFj8Vi1mBuyZuv6kfto+9vtWHvsCX
fb9ePk0Nb0ZDucEb8MbWFE1WnT9BQ+S1AcqIvBDlJIIBYZdOcTZNhyvGfkpteO7F
FjybmhxXpGXU472AuPDjXXQEAmccB9rns5Z3ON7+ism/xYr6D6/09IPl+dEnGX6Y
P0YYq6BO64GrorDB7fR7kGyQ2cVdxR1Q2Yg8lpkFC5O3rosy+EgTcIXIwQQ72TPr
FuH2P4RBWM3jinBQTHcOF18ooLYDG5CGtilLS6baq+ZdKJ6RIaPwOB+/FmNzCI/z
jDyBhBHzwvZKyyejCtEGXH3qe6LaVxyePbd60EiFvS1RWK0hx9mO3pYSPwp8bbpj
qBpTK+4Peb3gl2ZXjGqV
=vATy
-----END PGP SIGNATURE-----

--zVyz+SkbhTrRQGHt--
