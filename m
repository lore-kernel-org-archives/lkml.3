Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaHTGJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:09:10 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41366 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaHTGJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:09:08 -0400
Date: Wed, 20 Aug 2014 08:09:04 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olof@lixom.net>,
        Eddie Cai <eddie.cai@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-pwm <linux-pwm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] pwm: rockchip: Allow polarity invert on rk3288
Message-ID: <20140820060903.GE13793@ulmo>
References: <1408381749-14156-1-git-send-email-dianders@chromium.org>
 <1408381749-14156-3-git-send-email-dianders@chromium.org>
 <20140819071857.GD12859@ulmo>
 <CAD=FV=Uvx3PMJRdnm4FKWWx4h3sN0Mn1yG6v245HnKur_3vgqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yb+qhiCg54lqZFXW"
Content-Disposition: inline
In-Reply-To: <CAD=FV=Uvx3PMJRdnm4FKWWx4h3sN0Mn1yG6v245HnKur_3vgqQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Yb+qhiCg54lqZFXW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2014 at 09:05:20AM -0700, Doug Anderson wrote:
> On Tue, Aug 19, 2014 at 12:18 AM, Thierry Reding <thierry.reding@gmail.co=
m> wrote:
> > On Mon, Aug 18, 2014 at 10:09:07AM -0700, Doug Anderson wrote:
[...]
> >> @@ -74,10 +78,14 @@ static void rockchip_pwm_set_enable_v2(struct pwm_=
chip *chip, bool enable)
> >>  {
> >>       struct rockchip_pwm_chip *pc =3D to_rockchip_pwm_chip(chip);
> >>       u32 enable_conf =3D PWM_OUTPUT_LEFT | PWM_LP_DISABLE | PWM_ENABL=
E |
> >> -                       PWM_CONTINUOUS | PWM_DUTY_POSITIVE |
> >> -                       PWM_INACTIVE_NEGATIVE;
> >> +                       PWM_CONTINUOUS;
> >>       u32 val;
> >>
> >> +     if (pc->polarity =3D=3D PWM_POLARITY_INVERSED)
> >> +             enable_conf |=3D PWM_DUTY_NEGATIVE | PWM_INACTIVE_POSITI=
VE;
> >> +     else
> >> +             enable_conf |=3D PWM_DUTY_POSITIVE | PWM_INACTIVE_NEGATI=
VE;
> >
> > I have a feeling you're going to answer the above question with: "Becau=
se
> > it's needed here". If so, my reply would be: "Then this function should
> > take a struct pwm_device instead of struct pwm_chip."
>=20
> OK.  I've chosen to have it take a pwm_device AND a pwm_chip.  It is a
> little redundant because a pwm_device has a pointer to its pwm_chip,
> but it follows the lead of all of the callbacks in "struct pwm_ops".
> If you'd like me to spin it to take only a pwm_device I'm happy to.

No, that's fine.

Thierry

--Yb+qhiCg54lqZFXW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9Dt/AAoJEN0jrNd/PrOhWtMP/1F8/L5PlM9ONIGPDRuQEE36
zrTO06BfTklEeFc7PULQGoIkvG+MNEy08qZrY+erWGEMSBIM7SnVKl8UfaZ5F9xe
s4y0nz7thY9hkF9ltB7n/tjmJlAEzgkwvLH0MoqQUKtPgzOjMP+9gOx4g3//4dA3
exg+yjTi85+KEjd9JEzTRdN1D0eF+p1jBgFR3Cx+I8GURETZtIHc25Ay0zPcwv3H
5Z9QnSlXLaJHBFxuCyWhlGSdYn511cOcjb54oisixMAnsT/9lhd5GDjmzkuKFFRZ
ZKwm/BjgsCQpdcBf8FSUkKd+HqdA0qi7hn1GfbaG8AGRYF6CCiKWky+JDUPKVb6K
Mc+mD7AvYiyojsZzocmfH/eoMD/mpakPsqwyZSUoc/YaVwyPOdO/z3SjC+NTYhjM
1plJipdC6oFC2DKZE/A5YCo7MIjtUB94W9kZ2p7tjrP0Rihn6JvWi9xdohZiOUR0
WxrFAP9zN82w6Q570cH5f8ji1yMj9GLHkrNjdJbvW2qZzteUlI2/v5+pTHpaS1H9
PbFtL2Ae0zmQVQXptcwtDRdPaMLy0+wcZTw0cZFRFjJedk/e305Q0mHhUFlMbE9O
ZzQi9uhvtk3XTwSlHdWiWL8os35UqhkjsJd/IFtkm+aAVj83TXAGQSlrmdJRkEal
Z6X814UYdzk+mWaw3a0d
=JJEc
-----END PGP SIGNATURE-----

--Yb+qhiCg54lqZFXW--
