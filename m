Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaHVWGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 18:06:21 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44163 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaHVWGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 18:06:20 -0400
Date: Sat, 23 Aug 2014 00:06:16 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the pwm tree
Message-ID: <20140822220610.GB24037@mithrandir>
References: <20140823070737.371f09fb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <20140823070737.371f09fb@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 23, 2014 at 07:07:37AM +1000, Stephen Rothwell wrote:
> Hi Thierry,
>=20
> After merging the pwm tree, today's linux-next build (powerpc allyesconfi=
g)
> failed like this:
>=20
> drivers/pwm/pwm-lpss.c: In function 'pwm_lpss_config':
> drivers/pwm/pwm-lpss.c:81:2: error: implicit declaration of function 'rea=
dl' [-Werror=3Dimplicit-function-declaration]
>   ctrl =3D readl(lpwm->regs + PWM);
>   ^
> drivers/pwm/pwm-lpss.c:87:2: error: implicit declaration of function 'wri=
tel' [-Werror=3Dimplicit-function-declaration]
>   writel(ctrl, lpwm->regs + PWM);
>   ^
>=20
> Caused by commit 28160b18787b ("pwm: lpss: Properly split driver to
> parts").
>=20
> I have reverted that commit for today (and 06c7b5394e21 ("pwm: lpss:
> pci: Move to use pcim_enable_device()") which depends on it).

Ugh, that's unfortunate. I have a set of scripts I use to build-test
before pushing, but I don't usually do full allyesconfig builds. It
seems like pwm-lpss.c might only be missing a linux/io.h include. It
will likely be Monday before I find the time to properly test and fix
this, do you want me to remove the commits from the pwm/for-next branch
so you don't have to revert it again?

Thierry

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJT977SAAoJEN0jrNd/PrOhDJIQAIWMVkJoOUC5/ioDSjtcec9j
g5HbEZfsUN/or/Fra3cE8TJ74may8GgvptJ4orE9pZKpnucIZ1s+7n0nir2YUkvu
UzHCgBkQyzrybIJixViPonfDyIapiXCft11dwJAEBDaMrloHRQmeqbZGw+W8NqTg
EhrJqePbhOqfEdLAMCQx+mxfBQgDodPxews9dSOfyPju1a2VN7wvSadZp/4WUcgW
inpe0/I4XpNv0vNjlsOmioU6fcf0dPbRCvgI4LHzb0rcyqIdhOVD9OBlFMD5G1Fp
0vPJNghD/Ei5z7HQlifOjVsNbKXktPkuUkpdwYTAKuzkHDsdo/T/jF0SjLdvs8qP
/8DiQVutRCZIpSdjR32mORWUWMPeulXfOyAD9b1nX7aWrVm9V7zKWBDbOj+adi16
vKS2KJ3IGKm4W+GjO9LN0utFpQHC89dvt06Nit2lnjvrJcOhQtrQijc/2QR30mVF
IULcyxkWbx5BW3rwgYwoZcatDucr+Y/8NawDVkaQc3RpDxdGPQZVgc6AmdfCe+BC
lvYwTT0H6BOMmVy8iGTdR+yH8g7QrpRNd5TbsKEp1/KeDChNf0chQIk/IYHLv66S
WwnBIRNfYubV1/11uI6CXO2aq13aS+tBAOj8vO5L76ZNd5QfnmIX1s9H1VnWE8Y5
AseFv7kqDLd/1GT0Xy6t
=eYKE
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
