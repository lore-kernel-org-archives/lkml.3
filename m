Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3JAUp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:45:28 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:36103 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3JAUpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:45:24 -0400
Date: Tue, 1 Oct 2013 22:43:35 +0200
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
Subject: Re: [PATCH 05/10] ARM: SAMSUNG: Initialize PWM backlight enable_gpio
 field
Message-ID: <20131001204335.GB9201@ulmo.nvidia.com>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
 <1379972467-11243-6-git-send-email-treding@nvidia.com>
 <524B14E8.5040302@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
Content-Disposition: inline
In-Reply-To: <524B14E8.5040302@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 01, 2013 at 12:31:04PM -0600, Stephen Warren wrote:
> On 09/23/2013 03:41 PM, Thierry Reding wrote:
> > The GPIO API defines 0 as being a valid GPIO number, so this field needs
> > to be initialized explicitly.
>=20
> >  static void __init smdkv210_map_io(void)
>=20
> > @@ -70,6 +70,7 @@ static struct samsung_bl_drvdata samsung_dfl_bl_data =
__initdata =3D {
> >  		.max_brightness =3D 255,
> >  		.dft_brightness =3D 255,
> >  		.pwm_period_ns  =3D 78770,
> > +		.enable_gpio    =3D -1,
> >  		.init           =3D samsung_bl_init,
> >  		.exit           =3D samsung_bl_exit,
> >  	},
> > @@ -121,6 +122,10 @@ void __init samsung_bl_set(struct samsung_bl_gpio_=
info *gpio_info,
> >  		samsung_bl_data->lth_brightness =3D bl_data->lth_brightness;
> >  	if (bl_data->pwm_period_ns)
> >  		samsung_bl_data->pwm_period_ns =3D bl_data->pwm_period_ns;
> > +	if (bl_data->enable_gpio)
> > +		samsung_bl_data->enable_gpio =3D bl_data->enable_gpio;
> > +	if (bl_data->enable_gpio_flags)
> > +		samsung_bl_data->enable_gpio_flags =3D bl_data->enable_gpio_flags;
>=20
> Won't this cause the core pwm_bl driver to request/manipulate the GPIO,
> whereas this driver already does that inside the samsung_bl_init/exit
> callbacks? I think you either need to adjust those callbacks, or not set
> the new standard GPIO property in samsung_bl_data.

I don't think so. The samsung_bl_data is a copy of samsung_dfl_bl_data
augmented by board-specific settings. So in fact copying these values
here is essential to allow boards to override the enable_gpio and flags
fields. Currently no board sets the enable_gpio to a valid GPIO so it's
all still handled by the callbacks only.

Thierry

--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSzP3AAoJEN0jrNd/PrOhSFQP/11jJjdDbYPbijEhOmc3lpw/
rIKIpmH82cNyEmc6RU+8+JgsSYDUeoQveP2K+8JRerWKbKrFkQTZbPXmoKTnTFT7
wsf8EpAglvvwsW8gJjUJAuMwxr2b2eefG4JCRo2v/pKzLz6F2MOoubKWG1u34suE
XWZTH6UwnjlSr7z9ryBft9zUsJuLDvPtPtpwb8yrS4fOe2JS1YY/E+1lAUc28MpQ
y7/hgldsKmz6dlyW3DxIaaMISjQoklVMKPmZDGuSwsgNu4WpiTp/IAQNwrCQMDfm
XFwJDtgDvL3PGcHOQxYvE7pSEYuOpnrs0JJE+2X8hV2mzgiD1n+X/8HodaQeVoge
EffVGqOcW6j52V1zZC7etZGTZfV8FnkhR/xKcJKQkao5+gb2GTmFTjnp8u63VO1n
VRmk5dBqWr9r2iTele6d0dj2wl9o8mQ5y/emfH69ISmoUotcMFdHrqe6R1YjzKw+
Xs/pOceHk/9S8b9Mjdxjwf9xvDPVOiWq750OovzH935AkQWYeCDybBAd2+9xWpEk
XbSib2tgy0eGAftZl6YHsE/QadbXSKOR3923Kk665HSf5R4lVucLaOq7htW16MF2
65VIrKas0BgQNTA4joqZU0dc+A9qwsxUCIruCvdIkjqrmZhqMzU/JxR1EM0UAZpb
Rlw+3BSSYUcniScTN0+v
=DDMb
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--
