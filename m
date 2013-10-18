Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab3JRHst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 03:48:49 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:58655 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3JRHsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 03:48:47 -0400
Date: Fri, 18 Oct 2013 09:46:24 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mike Dunn <mikedunn@newsguy.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v2] pwm-backlight: allow for non-increasing brightness
 levels
Message-ID: <20131018074623.GA22291@ulmo.nvidia.com>
References: <1379869196-19377-1-git-send-email-mikedunn@newsguy.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <1379869196-19377-1-git-send-email-mikedunn@newsguy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 22, 2013 at 09:59:56AM -0700, Mike Dunn wrote:
> Currently the driver assumes that the values specified in the
> brightness-levels device tree property increase as they are parsed from
> left to right.  But boards that invert the signal between the PWM output
> and the backlight will need to specify decreasing brightness-levels.
> This patch removes the assumption that the last element of the array is
> the maximum value, and instead searches the array for the maximum value
> and uses that in the duty cycle calculation.
>=20
> Signed-off-by: Mike Dunn <mikedunn@newsguy.com>
> ---
> Changelog:
> v2:=20
> - commit message reworded; correct line wrap used
> - 'max_level' variable renamed to 'scale'
> - loop counter variable type changed to unsigned int
> - value held in scale changed from array index to actual maximum level
> - blank lines added around loop for readability
>=20
>  drivers/video/backlight/pwm_bl.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)

Hey Mike,

I've pushed a slightly different version of this patch which gets rid of
the intermediate max variable and uses the new scale field exclusively
to pass the same information around. Could you look at the patch from my
for-next branch in the PWM tree and see whether that still works for the
specific hardware that you need this for?

Thierry

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYOdPAAoJEN0jrNd/PrOhtoAP+wVufJIkeGn3gbRZaICS/Rtw
3sWWkU7djqHezdjQjpivLGkUVZsYW7YOR28OZmhVzSwLzMPZS6GMSgfvVGz7lP6A
VFFp8ywdGjxqndZItHVh0xahujAvcbWz7xcqZnFcHGwobT6nL5gTBgZNf5yqBubM
H/OKuLfMMepvWekFi1XFoeMGdxXmwwE+m6RQO4LrpmACx22wUsMfCMULMocSlnjg
IqjUq3SRHDzwI+QULX4MCQ1knCoMK8bzJDdJx2YskLeBSp0soL6+5k8dHh5ZNIVR
550xPqnlctwbyHszkW01zlMUJrmZl2CbxBgfXqej8XyQdribedXLAM50sbekoBg8
PxhuDq4nskIEnYzbStR+XPqgt7aB+KOfuhPVAluKp2kpl7BtBxiUSR3KZv5fcBes
dL1joPGS6TIKXx93sGJkn0nQ8KzfyGYLidWjRWNCwhB3PCBwFzeTJVQ4x7ZvHwjW
+RYNQpSdjRZJ39vM2ZhAHsWzcjmgM1OJn9kBP2WaL2mC44tDW/5m+i1yKQqWBFuV
gN0mwloF+G8+98U+cJUXQQYyKdMKkFhLko+d4jkOVEKJZCF7rZl/Aq0zv3PW0DJt
WUGKE66zUxgw8vc7ikIX1owb/sbz1/UbIKe7G077posIUtHOjkhC17s9iYSoSr4/
Cz/lAVgx1FL8Uo/NtZBu
=ql9M
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
