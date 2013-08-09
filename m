Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968159Ab3HIQjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:39:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60318 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968090Ab3HIQjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:39:51 -0400
Date: Fri, 9 Aug 2013 17:39:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Felipe F. Tonello" <eu@felipetonello.com>, alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz>, linux-kernel@vger.kernel.org
Message-ID: <20130809163947.GK6427@sirena.org.uk>
References: <1375430365-13232-2-git-send-email-eu@felipetonello.com>
 <1376029315-3217-1-git-send-email-eu@felipetonello.com>
 <s5h38qj2cqj.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uCT+dex/jsWOzqWN"
Content-Disposition: inline
In-Reply-To: <s5h38qj2cqj.wl%tiwai@suse.de>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/2] ALSA: Added jack detection KControl support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uCT+dex/jsWOzqWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 09, 2013 at 03:52:04PM +0200, Takashi Iwai wrote:

> Above all, the multiple indices don't work anyway with the snd_jack
> stuff in the current form.  The index was introduced only for kjack,
> and for HD-audio, snd_jack is provided just for a compatibility
> reason, thus it doesn't matter much even if the multiple indices don't
> work with it.=20

> That being said, before going further, we need to consider how to
> handle the input jack stuff with multiple indices.

What's the big problem with indexes and input (hopefully also extcon...)
reporting?

> > -	snprintf(jack->name, sizeof(jack->name), "%s %s",
> > +	snprintf(jack->name, sizeof(jack->name), "%s %s Jack",
> >  		 card->shortname, jack->id);

> This breaks the compatibility with the existing code.
> You must not change the name of the existing input jack element.
> Some drivers create "Headphone" and some do "Headphone Jack", yes.
> It's bad, but too late to change.

We can probably do something cheap like just check if there's a "Jack"
already in the name?

--uCT+dex/jsWOzqWN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBRtQAAoJELSic+t+oim92csP/1/rAohIUaj4FQEE21UNF+0Z
ybPhiFETggXUWadf/szk2eOSzDywEZzoO4xSIgJ2cLw9sW/vHA5G894Rj8LoOdpq
DEAFV2Rz34yR6IUDRuTyCH7P2PMOQV/RJHelNGSztQmNbof+Ig1AR3jDf9MRH12C
m9OrAmUIXOn2k7z252uYAA03V4Tr5V7X5W9r+QKpENqga3vZjAzaWjEezTm9awGW
1rk+SszkxketSpfqYXN6IIn0Rp5yK5uCWo966m3p24SjWIj08rr4IEcslJ2n3CFl
yyWqVqDYr7D5/wqeS3/vgCGUrgbN3ps5Yx6cmPzHYP2DTB6SPZHxMEWDhbbdfFh9
ZpIsiMmtSx3F/CLX4vxa6apITW52/rdlpTVqCdhIhAeGX9XFpPnDvCqT4oOPHa6f
PJDT0rga8aXqF7t/OrjX9Sa0IZDlUy/thRe6Evsgyz//hCMnTr3p9fYaatJxsOgi
AS3eJb/QK4EJOOR66+s1yTwx7j85KxDzVgS7cQEETvQyqlaa6T0tYiK+/a+kXNtK
pSjp35zAm3JXFsryh1GQ3e8WJtOUMNywA4DggvBD8J1P6ZfBsGdLxLR4nJwPjaP7
NeZVayKwZHdmFWiOHbK1I/U36wSvcnoe0I9cm4MsiZTG4vZPXL+3Bz6O/LqtjSUj
9D72qtot2ywUHqi7hUjI
=HvW9
-----END PGP SIGNATURE-----

--uCT+dex/jsWOzqWN--
