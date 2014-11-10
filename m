Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaKJTie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:38:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57815 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaKJTic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:38:32 -0500
Date: Mon, 10 Nov 2014 19:37:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141110193704.GL3815@sirena.org.uk>
References: <cover.1415562021.git.moinejf@free.fr>
 <d5d74f6993e9f2392008a27a2938c58d47dc8062.1415562021.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l/31HQTn6peyh0iH"
Content-Disposition: inline
In-Reply-To: <d5d74f6993e9f2392008a27a2938c58d47dc8062.1415562021.git.moinejf@free.fr>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] ASoC: Remove 'const' from the device_node pointers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l/31HQTn6peyh0iH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 09, 2014 at 08:33:45PM +0100, Jean-Francois Moine wrote:

> index 7ba7130..405f967 100644
> --- a/include/sound/soc.h
> +++ b/include/sound/soc.h
> @@ -886,7 +886,7 @@ struct snd_soc_platform_driver {
> =20
>  struct snd_soc_dai_link_component {
>  	const char *name;
> -	const struct device_node *of_node;
> +	struct device_node *of_node;
>  	const char *dai_name;
>  };
> =20

The changelog talked about of_node_put() but I'm not seeing anything in
the code which calls that except snd_soc_of_get_dai_name()?  Everything
else just does comparisons of the pointer AFIACT from a quick scan
through.

--l/31HQTn6peyh0iH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUYRPfAAoJECTWi3JdVIfQCLoH+wVGAQLCw+nWR1YK8qNAE9OX
eRWX8IViBBMfor6/9dm/Tx6vLwlrVy4nyhfabIg50xcvaFcgY4Mx1mGaL1U+UjnR
PSzhD1lXpkdLru6wzVvS1o81RW1Sg8MMCw7brP5GdN/y3q8eULIW3b+iuQvPo+RP
O4eEXxxYpP6zVUlzYMtZjHQXY2natUR4an+LafrfopGvFNsHyPgUfZ6iUJy57Oxi
mp8TX9etJbezm7wGWifCPmwkjiGA4+CnELnNBYqAOjgdJ2nV/Y9+Yz8621FdQKgP
QjK3G3RKJyjxWhxdPiiTTYssUEH7li1VVaqX1VJy6AsMnEEHTPEH8gPC2PxxXlw=
=z5Kq
-----END PGP SIGNATURE-----

--l/31HQTn6peyh0iH--
