Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3IWSTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:19:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57716 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753152Ab3IWSTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:19:19 -0400
Date: Mon, 23 Sep 2013 21:19:17 +0300
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Fan Rong <cinifr@gmail.com>, coosty@163.com, daniel.lezcano@linaro.org,
        linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.co, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/3] Add smp support for Allwinner A20(sunxi 7i).
Message-ID: <20130923181917.GS2779@lukather>
References: <1379768716-11672-1-git-send-email-cinifr@gmail.com>
 <1379768716-11672-2-git-send-email-cinifr@gmail.com>
 <20130921140059.GA2779@lukather>
 <523FB773.4050408@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GFHULmA0mO3kKGOo"
Content-Disposition: inline
In-Reply-To: <523FB773.4050408@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GFHULmA0mO3kKGOo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Sun, Sep 22, 2013 at 08:37:23PM -0700, Guenter Roeck wrote:
> On 09/21/2013 07:00 AM, Maxime Ripard wrote:
>=20
> [ ... ]
>=20
> >>+	/* assert cpu core reset */
> >>+	writel(0, sunxi7i_cc_base + CPUX_RESET_CTL(cpu));
> >>+	/* L1RSTDISABLE hold low */
> >>+	pwr_reg =3D readl(sunxi7i_cc_base + AW_CPUCFG_GENCTL);
> >>+	pwr_reg &=3D ~(1<<cpu);
> >>+	writel(pwr_reg, sunxi7i_cc_base + AW_CPUCFG_GENCTL);
> >>+	/* DBGPWRDUP hold low */
> >>+	pwr_reg =3D readl(sunxi7i_cc_base + AW_CPUCFG_DBGCTL1);
> >>+	pwr_reg &=3D ~(1<<cpu);
> >
> >Use BIT(cpu) here. And you should run scripts/checkpatch.pl on your
> >patches before sending them.
> >
>=20
> For the record:
>=20
> $ scripts/checkpatch.pl --strict allwinner.patch
> total: 0 errors, 0 warnings, 0 checks, 527 lines checked
>=20
> allwinner.patch has no obvious style problems and is ready for submission.
>=20
> This is on top of "v3.12-rc1-336-gd8524ae".
>=20
> checkpatch.pl does not complain as long as the number of spaces before
> and after an operator is the same. There is a patch pending to change
> this with the --strict option, but it will still not complain in 'normal'
> operation.

Hmmm, ok. Somehow, I was convinced that it was triggering a warning.
Thanks for the heads up :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--GFHULmA0mO3kKGOo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQIYkAAoJEBx+YmzsjxAgun0QAKMTAzJdrkU7jBcflkfuAr94
P1oHjts5kL14BXUb5pgVj2lzW+WzGHYS9vBZGfKiBZpdXeuSliy5FKyku1QipRQW
zSJfMVYRiRVUzVsqxnVJtkgwGhq5YFZyNdimPCaF8TboHwvzHFdx3tgyGeu3NbaN
Q8kzg613mK2Ezx1YqUbpdham6UJvMpNIVPr37E0mJVUrWMISJWraqrBWMOOWpWRb
v/lE7luILGAnU/5JTOYRt6kT0BudVGAoYFV8x66YmphNP1eTOiiVtLWrPZSM99+r
51CpMNBXV80YRSYQcwuhVnKd6mCBbpymt4ktBhSNhKpz/Wi2Q/7SX6W0XADbxSAt
h6OzeJS42Td42LrzUdYQY7mTaiT9+8LCKDhoz4XLWOCsRUl5AwN3RTgt68vPFKAz
P7E99tzgSnjE6c1dnTIamZfqK16caSMifYdaMMAZtFga0O1whY28aOsbQhs1LLra
We/+aql3pUc9WUszxUc/f9sJwDrixm4ddorojgFim+tdWug990QUazuW0uHCfuVa
ayFyS241VmckdnehdhxAXHW3paOiwhcQVhafluAlscHUsmbartL8sbcQ5hd/7zVR
aNLLP+fE29dMFAXaHxOBBU7i/wG+KtYb/KZaOfFz7XBmH3HXBWgNez++jTb1CSfJ
2LQhyZYwuo8BxAtKg51T
=W6if
-----END PGP SIGNATURE-----

--GFHULmA0mO3kKGOo--
