Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab3LCJoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:44:30 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:57111 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3LCJoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:44:25 -0500
Date: Tue, 3 Dec 2013 10:43:27 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, galak@codeaurora.org,
        plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 1/2] PWM: atmel-pwm: add PWM controller driver
Message-ID: <20131203094326.GB21178@ulmo.nvidia.com>
References: <1384766002-2852-1-git-send-email-voice.shen@atmel.com>
 <20131202105957.GD18060@ulmo.nvidia.com>
 <529D4B58.9020700@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <529D4B58.9020700@atmel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 03, 2013 at 11:09:12AM +0800, Bo Shen wrote:
> On 12/02/2013 06:59 PM, Thierry Reding wrote:
> >On Mon, Nov 18, 2013 at 05:13:21PM +0800, Bo Shen wrote:
[...]
> >>diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
[...]
> >>+	/* Calculate the period cycles */
> >>+	while (div > PWM_MAX_PRD) {
> >>+		div =3D clk_rate / (1 << pres);
> >>+		div =3D div * period_ns;
> >>+		/* 1/Hz =3D 100000000 ns */
> >
> >I don't think that comment is needed.
>=20
> This is asked to be added.
> And, I think keep it and it won't hurt, what do you think?

I think it's obvious that you're converting from nanoseconds because of
the _ns prefix in period_ns. But if somebody requested this and everyone
else thinks it's useful, I'm okay with keeping it.

> >>+	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
> >>+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV2_CDTYUPD, dty);
> >>+	} else {
> >>+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV2_CDTY, dty);
> >>+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV2_CPRD, prd);
> >>+	}
> >>+}
> >
> >Neither version 1 nor version 2 seem to be able to change the period
> >while the channel is enabled. Perhaps that should be checked for in
> >atmel_pwm_config() and an error (-EBUSY) returned?
>=20
> The period is configured in dt in device tree, or platform data in non
> device tree. Nowhere will update period. So, not code to update period.
> Am I right? If not, please figure out.

The .config() operation allows the period to be specified. Just because
nobody currently changes it at runtime doesn't mean it can't be done.

It is also possible that whoever wrote the device tree or platform data
didn't know that the period must be the same for all PWM channels and
therefore might use different values. If you check for this, at least
they'll notice. If you don't check for it, then they may end up having
the period reconfigured behind their backs, which may cause parts of
their setup to behave unexpectedly.

Thierry

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnae+AAoJEN0jrNd/PrOho7IP/2whf2IHpnd3Nxd6hged3lwK
SICUjd5TWTjwn53GdCMs/iNMvxZSbY0r9Sk4ktpWLj/Hw4qmsTxBU50/1Ck9qZcG
COnb53cvorOcfCXROeP9kqnv+EYV+CVxVBjakNh8/+uxSvVfB3ViXz8c/T/yjmca
n2J7RI+SAIMJYopybB1v4FJkWta9wAFD3G2qMgrHMGqHqkq7TU8z/tqA+caibSKU
hlHurfWwabXxmAvtwY9HYbONXtkB4fHF9uRzk5V2tnKqs7VTVCk6YmygnBrwq+sP
tNxE4Q+2XdYw7ZI3aWmqTEfoyXMTevmZVkubF5Tu24FVjrGKitR0cmmFQ24zvzY7
mKQMhJB50U7bz09xWR981Bh3BjpBt4gVKcNrMZXBNohubRsU4TohNOZoxH3ItnZo
0ytMyT/sxf8EzoSn41ioVVwDS3nmivTIwNSOGSmvIB2+EDDe0UsTSCievZ32JqjD
wLwBDSz/1qLaOc0M+nCrRqRIRQEn0rQefuDgIedsHD03X9gKZBl2P97YgRgmSMg0
QSkguL+l75Id56P4becruR2M6NFvnmIX1rqw+nqOXCf8vetXsHVAXJMuFsoAPr0t
2ZPni0azzNV3hcvIvwalCkm9w16PDQ7FY7A9dxhHyyCRzS9m6+Vtd5dyFbfrZjpB
34sDxuvB6rseaCmKjj9c
=xdI+
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
