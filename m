Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3KIS6P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 13:58:15 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52756 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab3KIS6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 13:58:14 -0500
Date: Sat, 9 Nov 2013 18:57:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Levente Kurusa <levex@linux.com>
Cc: Caizhiyong <caizhiyong@hisilicon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>
Message-ID: <20131109185741.GW2493@sirena.org.uk>
References: <C3050A4DBA34F345975765E43127F10F1C08B39E@szxeml512-mbs.china.huawei.com>
 <20131109151626.GT2493@sirena.org.uk>
 <527E55EF.5080504@linux.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qCb2VTfFGdRLn6RH"
Content-Disposition: inline
In-Reply-To: <527E55EF.5080504@linux.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 81.152.125.166
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Fix compile warning with value uninitialized
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qCb2VTfFGdRLn6RH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 09, 2013 at 04:34:07PM +0100, Levente Kurusa wrote:
> 2013-11-09 16:16 keltez=E9ssel, Mark Brown =EDrta:

> >> -	int i, ret;
> >> +	int i;
> >> +	int ret =3D 0;
> >>  	bool bypass;

> Wouldn't the following be better?

> int i, ret =3D 0;

> I think it is more readable.

No, that's not the kernel coding style.

> > This sort of fix isn't ideal, it just silences the warning but if the
> > compiler has spotted a genuine oversight in the function it won't
> > address it.  It's better to include some analysis of why this is a good
> > fix.

> The only condition when 'ret' is not set is when the num_regs parameter i=
s zero
> and krealloc doesn't fail. If the above two conditions apply, then
> the code would return an uninitialized value. However, calling this funct=
ion with
> num_regs =3D=3D 0, would be a waste as it essentially does nothing.

OK, so that should be in the changelog - or there should be an error
check for num_regs =3D=3D 0 which might be more helpful.

> Also, I think code which throws warnings is worse than code
> which doesn't.

Right, but code that is behaves incorrectly is worse still.  We need to
be careful that when changing the code to remove warnings we make sure
that we fix any real problems the compiler was warning us about.

--qCb2VTfFGdRLn6RH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSfoWiAAoJELSic+t+oim9LDkP/RTDO5Xt4ThW7P0UIXzAB8OQ
NbZvpqKrgScGl6E0FtoCdPuBczCdWkujh7YQQePHpReO2Ohoe6aX0xjU1/h4LzDt
c9q4ri1oN6m1eVpv5k/xQUFCEdOGGcx8f4yDkX1TmPAVDH4RME0zQfZmz1Ywa+Hh
+LKhuGO0bP5mMBvSY8J0sPm28mYYwyeNcjnz+7HtLCtH5QfRrMMmaOsnhI9yBruW
F7Qpza1KgOEwPohorYTy2wfCsLMvak7fvpxECA9wTK+Am8wJmEyadudqiGfZlt8o
E/alicHNpM0u850jT1ftiaxp4Kv4e2GzOKlZkYyjN3OaF5N0IpXMFZSnWOHF+nZl
FnPN+OYCXXYE7L/1VODmt5rBoyN6w/V88y5qKRBFxYn3zXl+V07sPRCoFEN3AH4h
YPwx5msx4+cLy8rP7d8e/qy9parigcpLcdYdMe17kXGqbbdjnHeayq+uZa+wPoc0
QZgrDIfgXER15MlZp1U21dykgOW2/eAriEza8YdgdqM+F6gqjGQdy8w8h+wqTjPm
Oq/BA/AM6FV3f7Oozno5uy5/jvbxr7nDMoVzg00C6+0034vK7bqDUVi85jdMnlo+
0HpqYXt/++UacbHQah5EGjsv2mjduDPWA62RI1pLyVdvDxYTTGTegBZPThEK3vZ+
FdH3uYPSbSgULBYrB5YZ
=Knns
-----END PGP SIGNATURE-----

--qCb2VTfFGdRLn6RH--
