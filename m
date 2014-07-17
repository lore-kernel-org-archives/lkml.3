Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbaGQJvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:51:35 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:43550 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbaGQJvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:51:32 -0400
Date: Thu, 17 Jul 2014 11:51:19 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Guenter Roeck <linux@roeck-us.net>,
        Richard Weinberger <richard@nod.at>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, teg@jklm.no,
        Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>, msalter@redhat.com,
        linux-pwm@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-watchdog@vger.kernel.org, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mischa.Jonker@synopsys.com, jic23@kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
Message-ID: <20140717095118.GA17877@ulmo>
References: <201407130545.23004.marex@denx.de>
 <53C53CE1.4090803@gmail.com>
 <53C7269E.4010702@gmail.com>
 <6823014.2plXDE9VA9@wuerfel>
 <53C7977B.9090903@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <53C7977B.9090903@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 05:29:31PM +0800, Chen Gang wrote:
>=20
>=20
> On 07/17/2014 05:20 PM, Arnd Bergmann wrote:
> > On Thursday 17 July 2014 09:27:58 Chen Gang wrote:
> >>                                          gfp_t gfp_mask, unsigned int =
order);
> >>  extern void devm_free_pages(struct device *dev, unsigned long addr);
> >> =20
> >> +#ifdef CONFIG_HAS_IOMEM
> >>  void __iomem *devm_ioremap_resource(struct device *dev, struct resour=
ce *res);
> >> +#elif defined(CONFIG_COMPILE_TEST)
> >> +static inline void __iomem *devm_ioremap_resource(struct device *dev,
> >> +                                               struct resource *res)
> >> +{
> >> +       pr_warn("no hardware io memory, only for COMPILE_TEST\n");
> >> +       return (__force void __iomem *)ERR_PTR(-ENXIO);
> >> +}
> >> +#endif /* CONFIG_HAS_IOMEM || CONFIG_COMPILE_TEST */
> >> =20
> >>  /* allows to add/remove a custom action to devres stack */
> >=20
> > To be honest, I think it's a bad idea to introduce wrappers functions
> > that are only available when CONFIG_COMPILE_TEST is set.
> >=20
> > COMPILE_TEST is a great tool in general, but it has its limits.
> > In particular, the case for !CONFIG_IOMEM is completely obscure
> > and we won't find any bugs by allowing more drivers to be built
> > in those configurations, but attempting to do it would cause
> > endless churn by changing each instance of 'depends on HAS_IOMEM'
> > to 'depends on HAS_IOMEM || COMPILE_TEST'.
> >
>=20
> Architecture members and driver members really have different tastes,
> they are different roles. It really need additional discussion.
>=20
> For me, I only want to change devm_io*map*, not touch so much.
>=20
> Welcome any other members' idea or suggestions.
>=20
> > Note that s390 no has gained support for IOMEM, tile has it most
> > of the time (when PCI is enabled, so you get it in half the
> > test builds already), score should set HAS_IOMEM and doesn't
> > even have public compilers, and uml doesn't even compile in
> > latest mainline. Nothing else ever sets NO_IOMEM.
> >=20
>=20
> In latest gcc and binutils, can compile score cross compiler
> successfully for building kernel (but I am not quite sure whether the
> compiling result are really OK, but I guess so).

I was only able to ever build a partial bare-metal toolchain for score.
There's no uClibc, glibc or newlib support, so it becomes rather useless
as a Linux architecture.

Also when I run the cross-compiler on a score defconfig build, I get a
bunch of these:

	score-unknown-elf-gcc-4.9.0: internal compiler error: Segmentation fault (=
program as)

Thierry

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTx5yVAAoJEN0jrNd/PrOhAwoP/A38aCvw0YvgzyLpu90PaXGM
xmgWzWBO2aIPdq0u5Sg/ASeRVx8+qIqcuRpnPOIN6YuRxfgxvl/ABcpc3sNT+vgi
iSl2ta19ZXZEgxsJWa5pXdXVOzoOd2P238l/k/BcTlxVutAmwBMDtyXB3X63ImFm
FREbROAp3Y6QVBawgD5JC0GvwMqP4dQrDbglBdNAB1nWfBoa7hTQyR7yEDZqS+9N
l3Mxv8keSmv09vtBJ/iqHUqDYJ/alGJQ+Po1VNQbxnrFh1H1MWf33RErQW/IzVtW
XOXHfbWBx3JsY3R1CcUsqN1l9voD7IZN6WKrVwFgn6ZHHNQVjCrhh5p/Z+bdM043
z944TQBRScgC5nlZmr9gIdoV+zKOBfSMR5GiOceORHzPVxs06NYFJtGSVAN+D1YD
hdYkss/Hw3nfLBl5qzcnvTdlXH10xqqGMDJslEv/33ANwktKxnJOG+VA3tbRno8x
UeKVSU5cOjIv50iqX5X9LVuFP9xZYQ2G9H/Ui6t3ujbivajexnKb/B6X/EJ6is01
mnuJsBawtlP3ti0OQHQs343J8Pa0ToykroFWGIhjccKKz5F2f6Ntr0ySvHWY0Wtm
vvpUCJK/4/4LF2L8Co2y8ChbFkAjlNzgQbFpKuhqeDYQdaXS6YTYEiwqCYTX2Q94
BiGyy4F5GI/v6eg3rQaV
=+ic3
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
