Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbaCRP3C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:29:02 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:59925 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459AbaCRP3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:29:00 -0400
Date: Tue, 18 Mar 2014 16:28:56 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Chew Kean Ho <kean.ho.chew@intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pwm: add support for Intel Low Power Subsystem PWM
Message-ID: <20140318152855.GA7237@mithrandir>
References: <1393599057-26451-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <1393599057-26451-1-git-send-email-chiau.ee.chew@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2014 at 10:50:57PM +0800, Chew Chiau Ee wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
>=20
> Add support for Intel Low Power I/O subsystem PWM controllers found on
> Intel BayTrail SoC.
>=20
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Chew, Kean Ho <kean.ho.chew@intel.com>
> Signed-off-by: Chang, Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> ---
>  drivers/pwm/Kconfig    |   10 +++
>  drivers/pwm/Makefile   |    1 +
>  drivers/pwm/pwm-lpss.c |  179 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 190 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/pwm/pwm-lpss.c

Sorry for taking so long to get back to you on this. Things have been
somewhat crazy lately.

This generally looks very good, but I found two issues that escaped last
time. See below.

> diff --git a/drivers/pwm/pwm-lpss.c b/drivers/pwm/pwm-lpss.c
[...]
> +static int pwm_lpss_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +			   int duty_ns, int period_ns)
> +{
> +	struct pwm_lpss_chip *lpwm =3D to_lpwm(chip);
> +	u8 on_time_div;
> +	unsigned long c =3D clk_get_rate(lpwm->clk);
> +	unsigned long long base_unit, freq =3D NSECS_PER_SEC;
> +	u32 ctrl;
> +
> +	do_div(freq, period_ns);
> +
> +	/* The equation is: base_unit =3D ((freq / c) * 65536) + correction */
> +	base_unit =3D freq * 65536;
> +	do_div(base_unit, c);

clk_get_rate() can return 0, so perhaps it would be safer to check for
the validity of c before dividing by it. This will probably never
happen for your driver or platform, but people may look at your driver
for inspiration at some point, so it should still be handling this
correctly.

> +MODULE_DESCRIPTION("PWM driver for Intel LPSS");
> +MODULE_AUTHOR("Mika Westerberg <mika.westerberg@linux.intel.com>");
> +MODULE_LICENSE("GPLv2");

I think this needs to be "GPL v2".

Thierry

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKGY3AAoJEN0jrNd/PrOhlwsP/Rw3YvlmjSz+Qb0iWflprVjz
XpB0RBf/zaDkuroyE6iTSaEd447iuWaSSE+mCBfRod3JjeZCPdCrQRB2kqRHpYQD
Ms0FRqborxwO61B5fPcd6+Xw8NjR3vPKh+NQ5KMl1S/bEPxHeW1SPxBHLwOIr84z
xMTkDmhjtRVwyc/q7Hran0QF8PBj63eHdT0WDnR0/JQ2rNMY7vR5Di/PEtan8Lcy
J4Lnv/BQ0vcmclgtbrXQTMuB2Lm8Yl6GwaDJd+d/yuiS0HoigRJz1orik7mt9HdK
csTGhNkc3niIXocCCdHuvSMhypAtFt5qazul/yKCowbVwmAU3Z/wN2yEZ+sC7oJP
KKGuwc0O/NgE0o5btIlv4CxTXbm2jrCBlL2lE5184YVz+Cu4CGTTaKEGc3AJ2zCQ
7K6u8qP8p4qRvx9aI7GbQqSp9sILONoLydzivHM2uFzMDNyGje3dsCngd2oNudE+
1n4Q/mjZZL3LGE70qGGfg4IPuBrnvQHpX8EAMz92aF6TNzI7IC84kcFKASoKh5xv
C2sUVVXeEzoxV8lIlKUq8w76yAGWBLuJm7Th8KOLZKvbMllwncNksuoTVd47BiBd
5+/nbRhuYTykBSbB52Dl9Ba5GQ/vGOCgbkprRuP78J7ZscJ8ewsqY8z1+Vib0SIo
Y/7us46pPhtAzWiA5MGt
=rWC0
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
