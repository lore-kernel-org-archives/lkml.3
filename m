Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3AUHtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 02:49:39 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55859 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3AUHtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 02:49:36 -0500
Date: Mon, 21 Jan 2013 08:49:28 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Mark Zhang <markz@nvidia.com>, gnurou@gmail.com
Subject: Re: [PATCH 0/3] pwm-backlight: add subdrivers & Tegra support
Message-ID: <20130121074928.GE15508@avionic-0098.adnet.avionic-design.de>
References: <1358591420-7790-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X3gaHHMYHkYqP6yf"
Content-Disposition: inline
In-Reply-To: <1358591420-7790-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:JQLXmxtOR0pEbJQHxrHtYAwwikyuF0W5SUDdU7+qt2C
 XbJ9oI4BLWlhbdDjl+q1DW7avfjOS/hIUbmMLV6V5eSObu7KoQ
 GIFOtjpiNiXavHSPlFdBRM7ZB/vTQByS+1A12Xk3YfFO3P/QOq
 vZlSCiXaLVR3pgu4uGf1tbs/adRd6xRABentoFKW1Bpf51TX8B
 8ttZrp62PilC4kO0Xe818VfDNwBcHjWr6SlG6lQWpXfS22Csd6
 9z1/sVN9nUxO4+Ssqucr+Rdalr1joYwmNFtFHFJqTcNY59nb9+
 yjU+dRgFFJiyJ58xTowsAR6Pl25oHSgs/GNli8/cmWWIWJW5Mf
 f8c8UVnXjmQoJjFBkw2viRmhf5qjDOtDOje8g1qkUEgbPN/+MN
 WyYHhhnbeHOyIcrS/rM6bR03Okx5E8PspJHh45CU0/hg0PQAlt
 N125O
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X3gaHHMYHkYqP6yf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 19, 2013 at 07:30:17PM +0900, Alexandre Courbot wrote:
> This series introduces a way to use pwm-backlight hooks with platforms
> that use the device tree through a subdriver system. It also adds support
> for the Tegra-based Ventana board, adding the last missing block to enable
> its panel. Support for other Tegra board can thus be easily added.
>=20
> I have something else in mind to properly support this (power
> sequences), but this work relies on the GPIO subsystem redesign which will
> take some time. The pwm-backlight subdrivers can do the job by the meanti=
me.
>=20
> There are a few design points that might need to be discussed:
> 1) Link order is important: subdrivers register themselves in their
> module_init function, which must be called before pwm-backlight's probe.
> This forbids linking subdrivers as separate modules from pwm-backlight.
> 2) The subdriver's data is temporarily passed through the backlight
> device's driver data. This should not hurt, but maybe there is a better w=
ay
> to do this.
> 3) Subdrivers must add themselves into pwm-backlight's own of_device_id
> table. It would be cleaner to not have to list subdrivers into
> pwm-backlight's main file, but I cannot think of a way to do otherwise.
>=20
> Suggestions for the 3 points listed above are very welcome - in any case,
> I hope to make this converge into something mergeable quickly.
>=20
> Note that these patches are the last missing block to get a functional
> panel on Tegra boards. Using 3.8rc4 and these patches, the internal panel
> on Ventana is usable out-of-the-box. Yay.

Hi Alexandre,

It's great to see you pick this up. I've been meaning to do this myself
but I just can't find the time right now. Generally I think the approach
you've chosen looks good, but I don't think doing it in pwm-backlight is
the right way.

Eventually this should all be covered by the CDF, but since that's not
ready yet we want something ad-hoc to get the hardware supported. As
such I would like to see this go into some sort of minimalistic, Tegra-
specific display/panel framework. I'd prefer to keep the pwm-backlight
driver as simple and generic as possible, that is, a driver for a PWM-
controlled backlight.

Another advantage of moving this into a sort of display framework is
that it may help in defining the requirements for a CDF and that moving
the code to the CDF should be easier once it is done.

Last but not least, abstracting away the panel allows other things such
as physical dimensions and display modes to be properly encapsulated. I
think that power-on/off timing requirements for panels also belong to
this set since they are usually specific to a given panel.

Maybe adding these drivers to tegra-drm for now would be a good option.
That way the corresponding glue can be added without a need for inter-
tree dependencies.

Thierry

--X3gaHHMYHkYqP6yf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/PMIAAoJEN0jrNd/PrOhSUsP/2Ln9bxzgHXpCRq3ULOIj2H2
c3rliK7PvQDW2fHWkrUlwlsTc5jA2LNE+Y7XCBNi45cv6r11DKpDgSz6OPSq+GML
5bFT0ZO4+et0fc0+exOfPjN/crHMovpnGk5FhM8gAKGLdyDWpDSFFuM+DEN5eYuf
8n5jypiuYDu/InMzF4PlGqt7Y8XweBoo64vpO9W1RQ9oFRoAv8gq2/zNFydett43
If6nWjOCNbSv3i6L7M7SeTU6Sqw7ZsMcahPYTYjvl3qgevAqNeuoOffkCFaq7HG7
Q30t5efs3g0O/c2OwwdoszNEcLaKijDSQr6PgZaw2YIZwhkvMbDlzO8iCD75pZBA
CxYuSg+JAP+NjlVm5Lzz5QGXTneh/ZAIvTJokMBkcOvZkQyXwLofDVAewmyAR+Rf
zlq2hWDQmtLXo3ByFzkF9hLdKvTGiYYGDRxGkG030bi+S06iONft9C7KUibpBFVb
yaosKGwgEWN7arXV/KC/r9DnW8BvRw9mCeiN2hPX2QHAggkmjYSm8gdkxTF9W2P6
rLdtqc/5iC2CjhWE5o2MQ17KEi9pWDjBlyWPdXHdVj1sPf/hJi1oOikej/Horbhg
3HaJiSRXT2WgVnvnVC1ROBUxdMxg/KRkvD79/qgysVGAyjN0/fAHpZ00koUIAboD
MscwCxL1IIDZnc/ORv61
=hOoR
-----END PGP SIGNATURE-----

--X3gaHHMYHkYqP6yf--
