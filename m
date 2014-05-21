Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaEUJSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:18:50 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:55976 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaEUJSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:18:47 -0400
Date: Wed, 21 May 2014 11:16:27 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Tony Lindgren <tony@atomide.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCHv2 resend 00/11] improve PWM lookup support without device
 tree
Message-ID: <20140521091626.GA21211@ulmo>
References: <1400532162-29483-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <1400532162-29483-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 10:42:31PM +0200, Alexandre Belloni wrote:
> Hi,
>=20
> Originally sent on Apr 14th, note that this series is blocking another 16
> patches series, I would like it to be taken in 3.16 if we can agree on th=
is
> implementation.
>=20
> A patch set as suggested by Thierry to make lookup with the lookup table
> instead of device tree behave more like when using device tree.
>=20
> The first patch adds a period and a polarity member to the lookup table a=
nd use
> those to set period and polarity.
>=20
> Patch 2, 4 and 5 are making use of those new members from the board files.
> Patch 3 removes useless code since setting the polarity is now handled by=
 the
> PWM core.
>=20
> I couldn't decide on a good name for the extended PWM_LOOKUP macro and I =
believe
> we won't have to add members to that structure soon so:
> Patch 6 modifies the PWM_LOOKUP macro to also initialize period and polar=
ity
> and
> Patch 7-9 are making use of the new PWM_LOOKUP macro in the board files
>=20
> Patch 10 and 11 are making the leds-pwm and pwm_bl drivers get the period=
 from
> the PWM before using pwm_period_ns if it is not already set.
>=20
> Patch 10 will obviously conflict with the series of Russell reworking the
> leds-pwm probing. I can rebase if necessary
>=20
> The final goal would be to get rid of .pwm_period_ns in leds-pwm and pwm_=
bl
> after moving all the remaining users (still around 25) to pwm_lookup.
>=20
> Changes in v2:
>  - correctly unlock the pwm_lookup_lock mutex before returning.
>  - don't change PWM_LOOKUP atomically
>  - remove tpu_pwm_platform_data and the associated header file
>  - make the leds-pwm and pwm_bl drivers get the period from the PWM
>=20
> Alexandre Belloni (11):
>   pwm: add period and polarity to struct pwm_lookup
>   ARM: shmobile: Armadillo 800 EVA: initialize all struct pwm_lookup
>     members
>   pwm: renesas-tpu: remove useless struct tpu_pwm_platform_data
>   ARM: OMAP3: Beagle: initialize all the struct pwm_lookup members
>   ARM: pxa: hx4700: initialize all the struct pwm_lookup members
>   pwm: modify PWM_LOOKUP to initialize all struct pwm_lookup members
>   ARM: OMAP3: Beagle: use PWM_LOOKUP to initialize struct pwm_lookup
>   ARM: shmobile: Armadillo 800 EVA: use PWM_LOOKUP to initialize struct
>     pwm_lookup
>   ARM: pxa: hx4700: use PWM_LOOKUP to initialize struct pwm_lookup
>   leds: leds-pwm: retrieve configured pwm period
>   backlight: pwm_bl: retrieve configured pwm period
>=20
>  Documentation/pwm.txt                          |  3 ++-
>  arch/arm/mach-omap2/board-omap3beagle.c        |  3 ++-
>  arch/arm/mach-pxa/hx4700.c                     |  3 ++-
>  arch/arm/mach-shmobile/board-armadillo800eva.c | 14 +++-----------
>  drivers/leds/leds-pwm.c                        |  5 ++++-
>  drivers/pwm/core.c                             |  8 +++++++-
>  drivers/pwm/pwm-renesas-tpu.c                  | 19 +++----------------
>  drivers/video/backlight/pwm_bl.c               |  8 +++++---
>  include/linux/platform_data/pwm-renesas-tpu.h  | 16 ----------------
>  include/linux/pwm.h                            |  6 +++++-
>  10 files changed, 33 insertions(+), 52 deletions(-)
>  delete mode 100644 include/linux/platform_data/pwm-renesas-tpu.h

I've applied this whole series with some minor fixups (mostly adding
detail to commit messages). Test builds show no breakage, so I've pushed
this to the for-next branch.

Thanks,
Thierry

--huq684BweRXVnRxX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfG7qAAoJEN0jrNd/PrOhoZcQAJLVaadi0dPMOAVmywvNkR/0
J8CN/DyyzLwzp8P8N28UAAoSDlc7aTDiqToG9oPYiDlV0884SmPTeendS5ptqJ/r
cgKTXH4Z+j827e9FrfCTpboD7+X7Mx6/qiP+fiKqNdwvxl9a15WxqhmNCvLRkPkK
V5gQ698E2UiOlZBUfIK9DNo5zNSyAzzQAGFpFwNxNdtbv7Cdsp1IU9HX2vMJwhbI
mr+HQ684nPiT0JV4oobY4AG2WC9L3PLNihkIn9pZaL7STlwQDHu1t9xAhQ7lARB5
+SuWsBO7BW4EjVtqAYpCu2kWxy6ymuvfMkk/sp0EkxX0ygSSh4Y/fiRx2a4l1per
D7ecXOTb1XGVSY0GkdVy93X6YB58VEx2de6shfVHgA+F4XpCp3hY/46QAam9CQtR
mebbhgKvcPxqjid6iPzSjQkR7o4aQPD5xguXoF4nKwJjucQjmIgy9vK+FXAic21d
9BmBnZPJnhOpcx2dMUaGTSOFYJaMp66eSasGk+M6N50B35Go8N+xoxACG6vJGJe6
6UlhgJfp39R2FxvnWJ9iPxQm3xZNHx4DhwcPoylcDIlo/cS1xYhcJQB7CYzpBvaW
Ld699GEiQj2JuHUiCmnLMMRxaCdulVdKh/3OHKf8bafI0ZsYdd0J/owLmv7SLXvc
z/pPSF4gKqz2EWzMNovu
=Wmh/
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
