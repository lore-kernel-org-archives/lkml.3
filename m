Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaL2Qab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 11:30:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54406 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaL2Qaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 11:30:30 -0500
Date: Mon, 29 Dec 2014 16:30:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141229163004.GY17800@sirena.org.uk>
References: <cover.1416918909.git.moinejf@free.fr>
 <e6673d036e848dd3d3eb19617f3a1a2c6c5c2d5d.1416918909.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hcIbdsWGSbvvNW1J"
Content-Disposition: inline
In-Reply-To: <e6673d036e848dd3d3eb19617f3a1a2c6c5c2d5d.1416918909.git.moinejf@free.fr>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 3/4] ASoC: simple-card: add multi-CODECs in DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hcIbdsWGSbvvNW1J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2014 at 01:30:14PM +0100, Jean-Francois Moine wrote:

> This patch allows many CODECs per link to be defined in the device tree.

It's also quite big and fiddly and hard to read, the changes that are
being made aren't blindingly obvious and there's quite a few of them.
As I've said before it's really importat that changes are clear and easy
to read, if the code is complex or surprising then the changelog needs
to be that bit more detailed to make thigs clear.  Things like talking
about why the code is being moved out and how it is being transformed
would be really helpful with this one, it's not enough to know the
overall goal of the patch, I also need to know how the patch is intended
to achieve that.

I think this is mostly OK but a couple of things...

> -Example 2 - many DAI links:
> +Example 2 - many DAI links and multi-CODECs:

I'd be much happier with a new example here rather than modifying the
old one.

> @@ -365,8 +359,18 @@ static int asoc_simple_card_dai_link_of(struct devic=
e_node *node,
>  	 */
>  	if (!cpu_args)
>  		dai_link->cpu_dai_name =3D NULL;
> +	goto out;
> =20
>  dai_link_of_err:

This goto out thing here is messy, it's not our normal coding style and
is error prone - better to just duplicate a small amount of cleanup.

> +	for (i =3D 0, component =3D dai_link->codecs;
> +	     i < dai_link->num_codecs;
> +	     i++, component++) {
> +		if (!component->of_node)
> +			break;

What's this break doing here, why might we be missing a node and why
should we skip all remaining components rather than just this one as a
result - a continue would be less surprising.

--hcIbdsWGSbvvNW1J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoYGLAAoJECTWi3JdVIfQ8hIH/RyQZE5swo/NYMfEg/wfoAfP
szgMsI68C1+d/GoaVkkF7ncM4AUmQtwZK7cfZUFuIDLZ6KWevAbupIZTSUdCpoda
MQh5VrOQreISrcjt5cVDNdbkFCSALOR7u/aWmC/IIJ76pmMXktinGByYklWplxor
GzrJZBH7vAEo94gG2w2LZrKuD16HaVhYOnmzoj5CsmheY9ZhlVUJyoysI/uO57BM
GVx85aUVyVs3af9HzBHDTv+uFKdJV5cgRa045jjsfUH91Ax1SGVYE/WUuD5rXw7r
JGr743XzB8kZbAH3S3lFADtbT6nqw9d+UY1PdTXXQj/NRL/7hbIpKgbFtmW3JTE=
=kpZo
-----END PGP SIGNATURE-----

--hcIbdsWGSbvvNW1J--
