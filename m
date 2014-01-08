Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbaAHSAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:00:00 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48835 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaAHR74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:59:56 -0500
Date: Wed, 8 Jan 2014 17:59:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        kuninori.morimoto.gx@renesas.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Message-ID: <20140108175940.GQ31886@sirena.org.uk>
References: <1389164556-2728-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3XlXNak/7C2Q/aUj"
Content-Disposition: inline
In-Reply-To: <1389164556-2728-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] ASoC: simple-card: add simple audio card widgets
 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3XlXNak/7C2Q/aUj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 08, 2014 at 03:02:33PM +0800, Xiubo Li wrote:
> For many audio cards there need to add some off-CODEC widgets, and this
> is hard to be supported by dts only, because maybe some widgets need one
> or more call backs, such as wevent.

The big question here would be why these widgets need to be added - the
default thing is that all inputs and outputs are enabled so it can't be
that and as you say callbacks are going to need to be added.

If this is used then it probably makes sense for the card to set the
fully routed flag since one possible use is to disable unconnected pins
on the CODEC.

> +- simple-sudio-card,widgets		: The name of the audio card off-CODEC widgets.

simple-audio-card.  This also needs more documentation about what is
supposed to be filled in here.

> +void
> +asoc_simple_card_widgets_unregister(struct asoc_simple_card_widgets *comp)

We always use snd_soc.

One interesting thing here is that this is done separately to the card
itself.  Is there any actual dependency on the simple card, could this
be made into a generic library that any machine driver could use?  I can
see other machines being able to make use of this.

--3XlXNak/7C2Q/aUj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzZIJAAoJELSic+t+oim9B0MP/0R6JhO85Yq4UDoigkixJwi6
IvZMzdY3ixWnBsLYPmoCVAkqunlwBzwVbWXiqmXFGpmP8iKAmyEnUx/UjARCzGHz
JdLpwU+VTA/S2FZz0fUdoYnY8sEqc3Pr0jp1b2OoPdwkBTatTY66yAmB/Bfp8/nv
wWHaWB41uDwarEL5VGugyG8Z+oW3zQLCTDrrAUBfwX9MgHWMhdIWDDfXN5Q0XcLL
JNTuKgsdA9e9f0mRIS8gaVWy/kUCBCCptFGZHnVw6cUtEyk02LIMzEwzx12VuFyc
5inoKwaswQvGpp8UOIEAIO8wJ33pdkhCy5+A/wRIToVS2n1Oz4gFeuo9LLIe2840
h+Za8wKdidhhu1YAdiTggw9rPGaQ+Q3xlZFcV0sRz7xnLqRZ5oXWV9JGkR5W6ihZ
sibU+7GtGUcwXT6itNCGO/jeSMqQRzn3XYiUawtB6MBDQr6lkahdeB04XA/RNPs3
f5LwDDUE4TY1Cf01ZHB1iBZfTAT0KplOq9pyMqXNZLv0fsk7hqeNT8U0MHFYt/XM
kSMmghqIFQ/L2fbu9RaDRHemoLlCHWuYNzOwRHPOxNoke8NKvru3qB8skey6oTZZ
eXU5FVL3jM5jm1S74Znf0MUrCnsTmRL220ysi1rsBgJD7knhn8l04npbo3Z4ZUdC
auuGVvwYozw1FfcCtq1f
=WYdF
-----END PGP SIGNATURE-----

--3XlXNak/7C2Q/aUj--
