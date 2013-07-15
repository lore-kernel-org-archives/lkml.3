Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3GOUI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:08:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58528 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab3GOUI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:08:56 -0400
Date: Mon, 15 Jul 2013 21:08:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Message-ID: <20130715200851.GD11538@sirena.org.uk>
References: <20130715103644.04e57749@armhf>
 <20130715153101.GK11538@sirena.org.uk>
 <20130715203756.68abbf10@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h+CsNYkJBPxpZ+B/"
Content-Disposition: inline
In-Reply-To: <20130715203756.68abbf10@armhf>
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


--h+CsNYkJBPxpZ+B/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 15, 2013 at 08:37:56PM +0200, Jean-Francois Moine wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > I'd really like to see an analysis explaining why this can never happen,
> > the driver explicitly supports running without extclk being provided.
> > Simply asserting that we should never get such a rate isn't really
> > enough detail...

> Russell explained this in the message below dated Wed, 27 Mar 2013
>   (http://www.spinics.net/lists/arm-kernel/msg233819.html)

This is no good, the information needs to be in the commit message.
Right now the change just looks like a bug supported by wishful
thinking, you're not providing enough analysis and inspection of the
code suggests a bug.

> Sebastian is correct in that such a path should _never_ be reached
> because ALSA will reject anything but 44.1, 48 or 96kHz rates if we
> don't have an extclk.

There's no obvious code that handles anything differently with extclk.
Indeed if you think about it for a minute you'll realise there's no way
the driver will ever use an extclk - set_rate() is badly implemented,
look at how other drivers select between clocks.

Fixing the driver so it can make use of an extclk would be more
useful...

--h+CsNYkJBPxpZ+B/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5FbQAAoJELSic+t+oim9YM8P/2iWVdFmrzFFDmPF3q8L45zb
mTbT95onKjYQpte1o9wlQrfd5pc7YVSRuKkm1rlb9/PUaF3Ac8phTGi/gyz1ip4t
QLfjNfdX6azITBPQGb4AUa5mpcYQr3HhsmYjKlrHPcM74qtuAxhPtTeALQzXWO2w
4MhKUVZmyg8DldIOAVRPtREUJ18HuD/G0GYrxgWjorlk9VZtbl//scVatIrVaaOL
v69LRjqh0MdJdad6TjPbBalVmTRthmqN1wlM3Dqx1q5gf0xcY1dtNl/n6daDv7Oq
bSck/BjAuOxTKnvZxHc9aJjyWdIJN3xRCGKTElJ9rI8XDDQ0lMYGqPWmTMe+2olF
h3aa1ngSEdw/L8yu7Z1q4YdU6eU37rYcbUnTNI5+IuD56wDaWVa9J/8oebflW4Si
fE+yAKtjqqvBTckuknSpl11og7G+aPj/kiD7n4BihKA2apicM41bXrTyQWwbQA6U
QSeWE/7GcpCZiWtANixXbX8RNyy+7gNlZ639ZqPFTQbVAuGy9ybGTR5s7atCsx17
0wdcGMIcVfvc6tIINS+HVoCExmBVBDKSkKy8AbXhKfIij3pRQ2S3NmUzsxo+7Mi3
2nE/7sFYgtt2+k4eRpEpDeNhHk0wWLW1ImpOkLw0lTVpFhFf9EcJHku/Crp9XqD6
DIFS/y3dExhRuoqs4enT
=F2Ug
-----END PGP SIGNATURE-----

--h+CsNYkJBPxpZ+B/--
