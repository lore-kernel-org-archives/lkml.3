Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbaJHO5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:57:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40835 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbaJHO47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:56:59 -0400
Date: Wed, 8 Oct 2014 15:56:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141008145627.GD4609@sirena.org.uk>
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
 <1412775847-15213-6-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGdfKiBebYi9ts3p"
Content-Disposition: inline
In-Reply-To: <1412775847-15213-6-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/5] ARM: dts: Add initial regulator mode on exynos Peach
 boards
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGdfKiBebYi9ts3p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 08, 2014 at 03:44:07PM +0200, Javier Martinez Canillas wrote:

> The regulator core now has support to choose a default initial
> operating mode for regulators from DT. Set the initial opmode
> for the max77802 PMIC regulators with the same modes that are
> used in the downstream ChromeOS kernel, in order to allow the
> system to lower power at suspend time.

The stated goal of this change doesn't appear to correspond to what it
actually does.  It's saying that we want to be able to set the regulator
into low power modes on suspend which is a sensible and useful thing to
want to do (especially for regulators which don't have physical suspend
modes which we currently make any effort to handle) but what the change
actually does is cause us to set the default state of supplies on boot.

The device tree should describe what it's trying to achieve, otherwise
even if things happen to work right now it's going to be vulnerable to
being broken by future kernel changes which take what it's saying at
face value.

>  			buck2_reg: BUCK2 {
> @@ -201,6 +203,7 @@
>  				regulator-always-on;
>  				regulator-boot-on;
>  				regulator-ramp-delay = <12500>;
> +				regulator-initial-mode = <REGULATOR_MODE_STANDBY>;
>  			};

This appears to set the supply which is labelled as VDD_ARM into standby
mode by default (from a first glance the change appears to set all
supplies into standby mode) and of course we currently have no way of
changing the mode at runtime in DT systems.  Are you *really* sure this
is a good idea of which an electrical engineer would approve, CPU cores
are typically one of the most demanding workloads available for a
regulator?

--MGdfKiBebYi9ts3p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNVCaAAoJECTWi3JdVIfQ6d4H/RKFTlRKARoyK/IaHPdtzVmb
NVVuEoxCYhVGfO6Cde5ZD8i209nASA+XuREQAg0gOYtTnK3i93W+yXxjV7cpjZtS
jXoMcM1XADBU+rExtMfAr9R2IWPf6bXkCsmS5MdW5tHziWgmxCtkea+T1wZCQL22
11SoZMb4GefKzBrsBSDi8TKW1bthbXmaSvqUufUVXuge+zWWf3dUbC2IlSQxErS8
vUfvvwYjcZQi/CSFEiAN5tkrYQZSC9Hg7S4tZAzK8z+UtYBN5g4d8cey6vz91CVV
ezyhcd2Jud+I5rs9Z/Eq3j6BHZ3NPxnHqyW5trtAlij8zxZV5nvKj1XaTrIRg0o=
=8jd7
-----END PGP SIGNATURE-----

--MGdfKiBebYi9ts3p--
