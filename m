Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaIFORD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 10:17:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53515 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaIFOQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 10:16:59 -0400
Date: Sat, 6 Sep 2014 15:16:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20140906141634.GF2601@sirena.org.uk>
References: <1409561813-24753-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bGR76rFJjkSxVeRa"
Content-Disposition: inline
In-Reply-To: <1409561813-24753-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.127
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4] ASOC: dapm: add code to configure dai link parameters
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bGR76rFJjkSxVeRa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 01, 2014 at 09:56:53AM +0100, Nikesh Oswal wrote:
> dai-link params for codec-codec links were fixed. The fixed
> link between codec and another chip which may be another codec,
> baseband, bluetooth codec etc may require run time configuaration
> changes. This change provides an optional alsa control to select
> one of the params from a list of params.

As I'm fairly sure I've told you several times now please use subject
lines matching the style for the subsystem - if your commit logs look
different to all the other commit logs that's probably not a good sign.
In this specific case "ASOC" and "ASoC" are not the same thing.

> +	for (count = 0 ; count < num_params; count++) {
> +		w_param_text[count] = kmemdup((void *)(config->stream_name),
> +			strlen(config->stream_name) + 1, GFP_KERNEL);
> +		if (!w_param_text[count]) {
> +			ret = -ENOMEM;
> +			goto  outfree_w_param;
> +		}
> +		config++;
> +	}

This will happily create values with a completely empty name if the user
didn't specify one.  This doesn't seem great - it's going to be an easy
mistake to make and fail to notice.  I'd at least expect a warning here.

> +	w_param_enum[0].items = num_params;
> +	w_param_enum[0].texts = (const char * const *) w_param_text;

Why the casts?  This tends to be a sign that something is wrong.

--bGR76rFJjkSxVeRa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUCxdBAAoJECTWi3JdVIfQXfUH/3RACVvoMg5Va5HKVHsbUUC5
xRXfPf/guW3Ie2ML5D92oTgk3FyFR6ozWP58nQfn+bl2ZBoowg8RJGzzFpYqjaWP
1NfEVdHpwhlbVS9ipNEOYRaejweLt9yJBiXdjc1JK8byeShRtnT1BXgYc1p4Nw0x
GGu184Cx47/Wm9Lc6iwLlCRkWK5B3zeYK8dSAl9ea432xfNn4cbqu3JppYbvzuxq
RQ37GkuafiOMURoWWBcyGZAH6KHuuqcUiJAlJbmF/jaTvx4awcTEZeiz+1vY9/um
5Hi58V2jE6g0nQoNA+oNlyUglepywG++FSC3zNvwWWATUe5uPkJhHax0AEcf8eQ=
=B1th
-----END PGP SIGNATURE-----

--bGR76rFJjkSxVeRa--
