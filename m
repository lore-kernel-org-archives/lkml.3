Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbaIIQFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:05:53 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:49455 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131AbaIIQFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:05:51 -0400
Date: Tue, 9 Sep 2014 18:05:30 +0200
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH V3] pwm: lpc32xx - Add a driver for the motor PWM
Message-ID: <20140909180530.635ce6f7@avionic-0020>
In-Reply-To: <2942175.JkZcLDKfiR@wuerfel>
References: <1410277361-26848-1-git-send-email-alban.bedel@avionic-design.de>
	<2942175.JkZcLDKfiR@wuerfel>
Organization: Avionic Design
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/qnSqLzvmEtFs1iliWt5Amnf"; protocol="application/pgp-signature"
X-Provags-ID: V02:K0:zPaHyqXvyhH3p80pAVRyn5U7Uiu4PZ/5Z65Lqj8oTnm
 pgc0mxF0l1cXidSW+XABFO13Q2yiU76ANZKnwcKyKUEqy8mbpt
 YA+PjFBz4X0evJnl/Ijr1IZW8sBDLneSsxuA8ThQQLe6BfTltp
 x3YPjsjXgXO86Js/IZORElPGNnGzap6CFLmxYgbMyoeWX0/1yU
 Yt71rJEQ43TXh9CE5FiRTQwPK0uibe5e04FDJNhITjqq4rvBMt
 VsO01V8uz/RV+Sva/sjUmARcq2Nbpvsqqr9IviZG3C2tMXWudM
 ZSTqQdKI4cn+2EO/BuZ+dau1SpYx+6egeo2XXpDN9BNT0JPKji
 EEqQ1neLW4/rjfzrqrPiEyByxIbo3CEzp/rE8gN4KC7N83/zxv
 d0NYNJKLHftsA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qnSqLzvmEtFs1iliWt5Amnf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 09 Sep 2014 17:47:53 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 09 September 2014 17:42:41 Alban Bedel wrote:
> > +config PWM_LPC32XX_MOTOR
> > +	tristate "LPC32xx Motor PWM support"
> > +	depends on ARCH_LPC32XX
> > +	help
> > +	  Generic PWM framework driver for LPC32xx motor PWM. The LPC32xx SOC
> > +	  has one motor PWM controllers.
> > +
> > +	  To compile this driver as a module, choose M here: the module
> > +	  will be called pwm-lpc32xx-motor.
> > +
>=20
> Can you change the dependency to ARCH_LPC32XX || COMPILE_TEST and
> add explicit dependencies for the subsystems the driver depends
> on (pwm and clk, I guess)? That would give us better build-time
> coverage with allmodconfig.

I'll add COMPILE_TEST, PWM is already there because this is in an if
PWM block. However I'm not sure for the clk, the LPC32xx use its own
implementation of the clk functions, what should I add in this case?

> > +	/* Write to limit register -> period */
> > +	__raw_writel(period, lpc32xx->base + MCLIM_REG_OFFSET(pwm));
> > +
> > +	/* Write to match register -> duty */
> > +	__raw_writel(period - duty, lpc32xx->base + MCMAT_REG_OFFSET(pwm));
>=20
> Please don't use __raw_{writel,readl} in driver, and change that to use
> readl_relaxed()/writel_relaxed().

Will do.

Alban

--Sig_/qnSqLzvmEtFs1iliWt5Amnf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDyVKAAoJEHSUmkuduC28jhIP/Ar3A4SeSSsdhn3fCPxfG102
ZHk5+Vl1L3Z8rQhMZHpGY7O3Vkgfdpnt07iIAWRGt1bLsReo11N43Bz4FD0lefNq
fyVu5O1RZrnlfiA+oe3jSHZqoVHbxC0+S2LcKNRGzVN1YWWpOjWYNbPlsbiLEies
79IGPyXgBrIu4kyU7kWfG1WEiE02Q0JzFrEfKimNAEKUHgTycfTyzvk+lCUYOICi
fYtrYB9Lgyl7vtP15tCkbfREHh0KT28WOcTqutkoj8+UokBlwF3AhARaeazIZFcX
RlQcahci5v3NgkpskufW+iYtd5wRUJWccGGuXVIAGKHaJqn7XgwkYo10T1KbRQc8
oEessTQ5xlite6OAinm2KLjIFYKw9YeRETojuggOpPXyNnps3bB+3AtfmaGqcQu4
oonIVYouflQudwtCA8+DeOc4XchQpX2/kj8Fmc03CmpvBMXI+orX5kZBzQAVTt86
KIxyFv6klNeoIudxfVnadB1eceXwc3EKjr4GUmLcOuuDRm9+njK50OxA14RnjujJ
51MBKdL/65u5AWtuQTyz4PKzvDfYdDkkNl1Jd2vT04XKr07b26cHs115I4LjblJx
pXfLAOtlVT9oMmev12rz4N+NVwNNXCu96TNuilF1Y56kgVuGD9sjYm7qIQ6h+KNu
YreJrV3jMinKjSjHXxsO
=HG99
-----END PGP SIGNATURE-----

--Sig_/qnSqLzvmEtFs1iliWt5Amnf--
