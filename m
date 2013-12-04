Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3LDKEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:04:44 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:45511 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3LDKEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:04:41 -0500
Date: Wed, 4 Dec 2013 11:03:41 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, galak@codeaurora.org,
        plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 1/2] PWM: atmel-pwm: add PWM controller driver
Message-ID: <20131204100340.GU19943@ulmo.nvidia.com>
References: <1384766002-2852-1-git-send-email-voice.shen@atmel.com>
 <20131202105957.GD18060@ulmo.nvidia.com>
 <529D4B58.9020700@atmel.com>
 <20131203094326.GB21178@ulmo.nvidia.com>
 <529E9AA2.8020400@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0iexB5Bk8cF8G6DP"
Content-Disposition: inline
In-Reply-To: <529E9AA2.8020400@atmel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0iexB5Bk8cF8G6DP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 04, 2013 at 10:59:46AM +0800, Bo Shen wrote:
> Hi Thierry,
>=20
> On 12/03/2013 05:43 PM, Thierry Reding wrote:
> >On Tue, Dec 03, 2013 at 11:09:12AM +0800, Bo Shen wrote:
> >>On 12/02/2013 06:59 PM, Thierry Reding wrote:
> >>>On Mon, Nov 18, 2013 at 05:13:21PM +0800, Bo Shen wrote:
> >[...]
> >>>>diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
> >[...]
> >>>>+	/* Calculate the period cycles */
> >>>>+	while (div > PWM_MAX_PRD) {
> >>>>+		div =3D clk_rate / (1 << pres);
> >>>>+		div =3D div * period_ns;
> >>>>+		/* 1/Hz =3D 100000000 ns */
> >>>
> >>>I don't think that comment is needed.
> >>
> >>This is asked to be added.
> >>And, I think keep it and it won't hurt, what do you think?
> >
> >I think it's obvious that you're converting from nanoseconds because of
> >the _ns prefix in period_ns. But if somebody requested this and everyone
> >else thinks it's useful, I'm okay with keeping it.
> >
> >>>>+	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
> >>>>+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV2_CDTYUPD, dty);
> >>>>+	} else {
> >>>>+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV2_CDTY, dty);
> >>>>+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV2_CPRD, prd);
> >>>>+	}
> >>>>+}
> >>>
> >>>Neither version 1 nor version 2 seem to be able to change the period
> >>>while the channel is enabled. Perhaps that should be checked for in
> >>>atmel_pwm_config() and an error (-EBUSY) returned?
> >>
> >>The period is configured in dt in device tree, or platform data in non
> >>device tree. Nowhere will update period. So, not code to update period.
> >>Am I right? If not, please figure out.
> >
> >The .config() operation allows the period to be specified. Just because
> >nobody currently changes it at runtime doesn't mean it can't be done.
> >
> >It is also possible that whoever wrote the device tree or platform data
> >didn't know that the period must be the same for all PWM channels and
> >therefore might use different values. If you check for this, at least
> >they'll notice. If you don't check for it, then they may end up having
> >the period reconfigured behind their backs, which may cause parts of
> >their setup to behave unexpectedly.
>=20
> Thanks for this information.
> I will add code for changing period.

Just to clarify: I wouldn't want this code to allow changing the period
but rather reject incompatible changes to the period with an error code.

Thierry

--0iexB5Bk8cF8G6DP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnv38AAoJEN0jrNd/PrOhF7sP/02iWAWIm/auArTmizan5yKW
HS4coBo0meadRD/8xQ7UGuSboas5x8iuJmyiRkBgdFwbtCkatFxuVSS21FLi/ooe
MmLIguPxLrGnxwLzeazTqARx7VObxb3LxxX7RtTZyQ87PBn1Fdpu6YAVEN3r0DGV
F9zP8zxQVbXLmD1Uyw0bPznNxrYtdg6i3LTaZYL8WrF1Oqy/Rcx/5966UDPjQEKe
ZVHg0xrpimO6f86fNulJJAXN76BdEJQc72lIuwceyoJVK9bz3S7A1QsxqgCsUg6Y
RHFj1rYS7eacaTy+aYhLTO840Uhiyf8Oog3p+q/P4HSZxESME2v34r8tIIZiovoM
QCyTCxwMY8EYZsmSmuZHyOkoUtRwa5SC72FSbnjkdynUVC0RKhA8epFuXMK2Q78S
FiYolDcVZR6uPzkLy1cZ25qZDaukWwgctaLe4/txrzyMyCHg2RP6+o1Rpfp8apd0
/ULedn3CfDeNjvaY9qQ/73mf2yZyBZrNiUymvwOFrV9BFkvEVAQQZdXFOEWP+8Nq
W8b+S3EcdyFXRBUiXWuhgNHxQIJx1MsCNK6VjMWq0iL6TMGBtN5BFJ+GAIE77/Mr
CahedYJvmc3HI4zBUjzYO/bq6V5BimBdBbEWeLOmwQ1eaua8uGYZ6L9KjrGdLKrQ
mfaFgXZEltVYX1m+joT7
=Jt9X
-----END PGP SIGNATURE-----

--0iexB5Bk8cF8G6DP--
