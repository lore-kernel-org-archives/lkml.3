Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaDXNAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:00:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37830 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753141AbaDXNAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:00:05 -0400
Date: Thu, 24 Apr 2014 14:57:04 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: wim@iguana.be, dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/5] ARM: sunxi: Select restart drivers
Message-ID: <20140424125704.GX24905@lukather>
References: <1398265476-29373-1-git-send-email-maxime.ripard@free-electrons.com>
 <1398265476-29373-4-git-send-email-maxime.ripard@free-electrons.com>
 <5061177.3hiLYCoYmE@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LvnU4bbuCGLV8PtK"
Content-Disposition: inline
In-Reply-To: <5061177.3hiLYCoYmE@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LvnU4bbuCGLV8PtK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2014 at 06:00:03PM +0200, Arnd Bergmann wrote:
> On Wednesday 23 April 2014 17:04:34 Maxime Ripard wrote:
> > Make sure we have the restart hooks in the kernel by selecting them in =
Kconfig.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  arch/arm/mach-sunxi/Kconfig | 4 ++++
> >  1 file changed, 4 insertions(+)
> >=20
> > diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
> > index b57d7d53b9d3..5fe80cc9b524 100644
> > --- a/arch/arm/mach-sunxi/Kconfig
> > +++ b/arch/arm/mach-sunxi/Kconfig
> > @@ -9,6 +9,10 @@ config ARCH_SUNXI
> >         select HAVE_ARM_ARCH_TIMER
> >         select PINCTRL
> >         select PINCTRL_SUNXI
> > +       select POWER_RESET
> > +       select POWER_RESET_SUN6I
> > +       select POWER_SUPPLY
> >         select RESET_CONTROLLER
> >         select SUN4I_TIMER
> >         select SUN5I_HSTIMER
> > +       select SUNXI_WATCHDOG
>=20
> I think you can't select SUNXI_WATCHDOG without also selecting WATCHDOG
> first. I would prefer not to do that however, and leave it up to the
> defconfig to enable it, loading the reset/watchdog driver as a module
> seems entirely reasonable in a multiplatform distro kernel.

Ok. Let's drop this patch, and I'll send some patches for the
defconfig.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--LvnU4bbuCGLV8PtK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTWQogAAoJEBx+YmzsjxAgOQsQALyESDTjHwTd6yVHo8WXFI8m
JVs9OVYZBgZgy5HoGxddLxU/daq/bfS5hBXhCbTNkFKfGBI5lgb2sSLAye5IxOeh
Hswg3GMKMiF5UPM/YFZj4rqdBDmjwdBMIzVRhoxdi+Jbi7c8AsRxNdaXMnU8agzx
5+zqfOCB2WeRl39KxZe5CaHHZDblfTgBhJv0EBNf42uwZFvC4TmcQxhD/G081QmG
R/PSyvthftZSOrnLY+3RfUj262mVhko6YUM08ekWUIkgYwuK/tToCS1wx9ET7csS
SpKDiitMA2POWgIcUsAEYWSjAaDkb6EuS7XGapyjv2+9QD6CrGrQE5nyqwnQDWsD
IEC9N2tRnlAteeAadRZs1m8gKA4dI/D+ytlgVZidThodNOgYemijmTpJ/2xOj0yn
XaOHzEvskqr74hw+XCsZ1lzIEKM8RUzFUJc9oWjY/yuSb6odSJYDwDdbZlASo/ea
qLKh8XweXZNTJtMT5F9FY2yKxEsG8ygFhT9zpKuvyjaHbQgof+x5EJbY4gjAAo4V
W+zJZn1IJ0dcMqQTyCACe6F9hwuYXab7JREtQh7Zze6w0me4qJJk6pMlFmO3xzyl
Xueu2Sl5GqCRcOBrqDdbzhcf3diDgPcCaVjxx3/JIbbIEivjulJwfVCH+qt53IPy
pu0mZ4om2M7B+R/oSRoa
=LkKg
-----END PGP SIGNATURE-----

--LvnU4bbuCGLV8PtK--
