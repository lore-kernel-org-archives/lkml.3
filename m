Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab3ETNBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:01:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40279 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab3ETNBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:01:48 -0400
Date: Mon, 20 May 2013 08:01:13 -0500
From: Mark Brown <broonie@kernel.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Ralph Birt <ralph.birt@maximintegrated.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130520130113.GU1627@sirena.org.uk>
References: <1369029487-32702-1-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3T2jnoiI0lx9XXvh"
Content-Disposition: inline
In-Reply-To: <1369029487-32702-1-git-send-email-abrestic@chromium.org>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 50.94.60.128
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: max98090: request IRQF_ONESHOT interrupt
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3T2jnoiI0lx9XXvh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 19, 2013 at 10:58:07PM -0700, Andrew Bresticker wrote:
> request_threaded_irq() rejects calls which both do not specify a handler
> (indicating that the primary IRQ handler should be used) and do not set
> IRQF_ONESHOT because the combination is unsafe with level-triggered
> interrupts.  It is safe in this case, though, since max98090 IRQs are

Applied, thanks.  If request_threaded_irq() is rejecting these that's
not ideal - some threaded interrupts can only be generated from within
threaded context and therefore can't have primary handlers.  Unless it
only rejects in the case where the parent IRQ is a hard IRQ of course.

--3T2jnoiI0lx9XXvh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRmh6QAAoJELSic+t+oim9ByQP/AqYwU0DYgY5mFbW67cShBZm
UDtV5Pas3aSAnKoeSxaEy2RenCDOBgXlJ70E9MW2eo+CmdIaiI+l9KPbTpqpjjoD
NqArcv7HYFdiYUbTNaPQt+shTV83EG4OnhsGXobZLKTkH0fk3jZLLbJKLs/RgJa3
ENJ2r45vGg6bnPYqz0/K/O/gKyuebqzHshh1svuF/JMwqbFjC8Zy9XjnDZWU8293
NIUFX0Lsc3R9qmWIf0XB27avFYgNl1egedxSTqYs3aoF96dH+FmBq0u28a3PELxl
1f0Pz46p4feeMl3QtyTj27KGjkMiZ1DPOcDShI+OXVzfFRe5ucJ6s5lK71+IYc+b
pt3AdqTzMU2Zv1z3QJVQFjSb/RmFke2GBrIG3h4CF1HK4Yb0GkndBkDRcoRdtHXh
13jCOsug9sR1I33GP7eHO0EkcQb1ms1FO4FeM7KTxDjMMY84gFLje1lDuv5KpPCi
s9O6tRz5Qh0gBdJrxD2QuYqoU6TxfZYp2t7aqAwxUHD/dRQOifjjn0JriMubZiFc
AjWjkgK9Z1WF9KbH/e58Kj0l2j4pUqvhjPyKVOOP7QUcL+pqL3HBbm0y0EAInSde
4nCAHkid2MhDKB/oez+m1cYJ1w0KmCj2+/G+juxSh36QX9QFj7ozYsNpsXsNXyPb
+KbADZQE/liOMrlYbbHI
=iKp3
-----END PGP SIGNATURE-----

--3T2jnoiI0lx9XXvh--
