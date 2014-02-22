Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaBVCyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 21:54:38 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48765 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaBVCyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 21:54:37 -0500
Date: Sat, 22 Feb 2014 11:52:04 +0900
From: Mark Brown <broonie@kernel.org>
To: Nenghua Cao <nhcao@marvell.com>
Cc: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140222025204.GM25940@sirena.org.uk>
References: <1392969970-28037-1-git-send-email-nhcao@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AQYPrgrEUc/1pSX1"
Content-Disposition: inline
In-Reply-To: <1392969970-28037-1-git-send-email-nhcao@marvell.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.103.222
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] asoc: soc-core: fix coccinelle warnings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AQYPrgrEUc/1pSX1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2014 at 04:06:10PM +0800, Nenghua Cao wrote:

> --- a/sound/soc/soc-core.c
> +++ b/sound/soc/soc-core.c
> @@ -2413,7 +2413,7 @@ struct snd_kcontrol *snd_soc_cnew(const struct snd_=
kcontrol_new *_template,
>  	struct snd_kcontrol *kcontrol;
>  	char *name =3D NULL;
> =20
> -	memcpy(&template, _template, sizeof(template));
> +	memcpy(&template, _template, sizeof(struct snd_kcontrol_new));
>  	template.index =3D 0;
> =20
>  	if (!long_name)

This looks like a regression - it's better form to use the object name
rather than the type of the object since this prevents errors if the
type changes.  What coccinelle was suggesting here was to replace with a
simple assingment statement rather than change the argument within the
memcpy(), I think this stops the warning showing because of that issue
since it makes it harder for coccinelle to figure out that this is a
memcpy() of the whole object.

--AQYPrgrEUc/1pSX1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCBDRAAoJELSic+t+oim9ZxcP/2ngnBblu2vvFRBLIIq1qlEU
ubUcx2eepnxgOpaXoP58AoM+gMAHFYtjn2vFTRbq1gOhDpa+Xchy6UkieMUaEtxG
QNWkXaXZtwA1FwOHgBCzxJtetFwK2m5ilUWMLejcaeh6tDKke/luAAyrkcXecF7K
+4ENIKAyR5v51MeoHX4RpL73IOGh3bRtqn6QaVwY1YRYUtt+h3EomejCdv1A8WXH
dRm6U554kFy07cvw8n+B3aKNO1nZC7jL6gEItSDby7AzhlegOucuuR6XcEpzvyzP
aeQAJOgo/S2PQ1MEj0a+y32XHSHSjfHL6ZFjZsBe3/roU3WpVzy6TA5O9uaoC2Hz
yfWoasZ5+1EYd+SwxS9J2FODwKhh5MA62oe8jjzrFTyb5+zXWp4uta7ad9j65gfO
YS9ioxeMwEXKcbmmPbjy7pM5fluW+ZTc0RqS+c0XzcBLSX82VRooYhVPdfC06JHD
kdtIUw142X8hvdtyx1WOUcdeEcsJxKiG36pHoP2TFC59u9WVl+jEjGcs826Ujw46
Fse7TiDRIJ+Uc9Mh/auuOVnoUCg5xaeOxrQXm66oQM6bgwe9QvxZcey7YgBPfY9h
NS1qh70Wfz3DjzgMWOVZvyiOJhOb3bfMub5vbnLuc15UT+wUJY3wfo+qDYkAgnDY
ynou11g37VlLfC6lzeLx
=neWi
-----END PGP SIGNATURE-----

--AQYPrgrEUc/1pSX1--
