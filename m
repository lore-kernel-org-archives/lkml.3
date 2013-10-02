Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab3JBRrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:47:45 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:43806 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab3JBRrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:47:41 -0400
Date: Wed, 2 Oct 2013 19:45:51 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        openezx-devel@lists.openezx.org, linux-samsung-soc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] pwm-backlight: Allow backlight to remain disabled
 on boot
Message-ID: <20131002174550.GA29973@ulmo.nvidia.com>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
 <1379972467-11243-11-git-send-email-treding@nvidia.com>
 <524B198B.3010609@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <524B198B.3010609@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 01, 2013 at 12:50:51PM -0600, Stephen Warren wrote:
> On 09/23/2013 03:41 PM, Thierry Reding wrote:
[...]
> > +	if (gpio_is_valid(pb->enable_gpio)) {
> > +		if (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW)
> > +			gpio_set_value(pb->enable_gpio, 0);
> > +		else
> > +			gpio_set_value(pb->enable_gpio, 1);
> > +	}
>=20
> ... That assumes that the backlight is on at boot, and hence presumably
> after this patch still always turns on the backlight, only to turn it
> off very quickly once the following code in this patch executes:

I was just going to fix this, but then saw that the code in .probe() is
actually this:

	if (gpio_is_valid(pb->enable_gpio)) {
		unsigned long flags;

		if (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW)
			flags =3D GPIOF_OUT_INIT_HIGH;
		else
			flags =3D GPIOF_OUT_INIT_LOW;

		ret =3D gpio_request_one(pb->enable_gpio, flags, "enable");
		...
	}

Which sets the backlight up to be disabled by default and is consistent
with the PWM and regulator setup. Only later, depending on the value of
boot_off it gets enabled (or stays disabled).

> (and perhaps we also need to avoid turning the backlight off then on if
> it was already on at boot)

That's true. Although I'm not sure if that's even possible. I think the
pinctrl driver doesn't touch the registers, but what about the GPIO and
PWM drivers. It might be impossible to always query the boot status and
set the internal state based on that. The easiest would probably be if
both the bootloader and the kernel use the same DT, in which case the
bootloader could set the backlight-boot-on property, in which case we
wouldn't need to do anything at .probe() time really.

Thierry

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTFvOAAoJEN0jrNd/PrOhoSYQAIn7plVDrw1cFYwX7Iqq9EP9
yJgz+asuveyXcB9yI5iWL48qDoeedWQmGvKQD7JaNiECeQb5f4k+WmwG02V4JqCz
Om45A5/p8+AbmBz36rdKnZgiU8Bfzef41B7vgdudqTuW+cc0PRLIx/IJMiMK7OCJ
1hfLc46mkINYH/0YQaUHg/k0u4QyR/zMB5Tt4lglPZdRWea1esvYK4lVwcsWCHHl
Wo5SfLd1i40dIp7hlpeW7sGqhLrU05iTNGGINh8FCphb1zbhFqA2D/5arCoya9uy
tzjloVqLzysYP63EfplbvmP15N/c3Uecc1ihIi3cC9gO8WJgVI/qe594WA/+q447
BCvcCgjrISwfr9Muqkort0ycqnNbELiX/BSInNih9UNESMiTpMaXQAQQI/BtHYy4
wZB7ShUQOEF4G8OssLGGvRzin0mm46RygoGnICTUorkzonRXo4SZhsDNoPti62eU
/w816Jv5NN/Ww/vE9f9buPTcPGr/UtcA4M9E8mrGAd3JVr6G7dc9Z4XIjSEyzxf0
ABuYe/inVterHWR2HT7G769RC/HcnpV5xZnV92kZoaMglfpwhlibFv/FMrzf/r3r
3vAgiTx+2eD18cj60ntzc8eqf+hXJRd4CFHR8zPwymauLp/r37NGFb+MQOng+Lmm
T8aCSBJ65TUJWQwNRU//
=yMQc
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
