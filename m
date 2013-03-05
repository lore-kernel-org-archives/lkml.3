Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab3CEHKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:10:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64613 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3CEHKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:10:46 -0500
Date: Tue, 5 Mar 2013 08:10:43 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Chew <achew@nvidia.com>
Cc: acourbot@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 v2] pwm_bl: Add support for backlight enable GPIO
Message-ID: <20130305071043.GB7212@avionic-0098.mockup.avionic-design.de>
References: <1362458630-31576-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <1362458630-31576-1-git-send-email-achew@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Xf7THM+xyJVR1kVd3hVKEcQc21Vo9YYc3oe0OdU17gM
 kEQlafMTvwkHvB0f3YHuy9aNpPfzVu2wUqOLSZ7ZFoA+diQEeq
 Xk7cBNq0Ipi6MBc30cwgYa6M7LvmH6135vAWjCSgablnyElV7e
 xplcI5FvJqNLFFwJ16kANldx9s26B4kNVhr77JJlXz9aLvqIqK
 mMb9IC7WGQ2MHaj7529tU/7l1U0ZGjA5a6qc0o/MEPWdpdmSw7
 bEdGj6EB21QtGJ1fsp/3TleC3r4gnzFi0DJnTRcTDWm+hr64bR
 ud4+qteH5hOSHqYC7nw4cU5QL+pv+PxOiU14YT21wJflxIGZzL
 oUO9majnMBOPs6e3oiLe/7SF9kFatAsudjtcIniRFNGNUFQbik
 1JWfUc/tCGgnnfaQjlrqo2w2ANkb15009f5JBWrAoKUXNheUqz
 U+K3u
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 04, 2013 at 08:43:50PM -0800, Andrew Chew wrote:
> The backlight enable GPIO is specified in the device tree node for
> backlight.
>=20
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
> I decided to go ahead with disabling/enabling the backlight via GPIO as
> needed.  Note that I named the new functions pwm_backlight_enable() and
> pwm_backlight_disable() (instead of something more gpio-specific) because
> I thought it would be convenient to have a generic hook for when someone
> wants to add yet more stuff to be done on enable/disable.
>=20
> I tested this by going into /sys/class/backlight/backlight.n and manually
> adjusting the brightness, and checked the gpio state to see that it had
> the appropriate value.
>=20
>  .../bindings/video/backlight/pwm-backlight.txt     |    2 +
>  drivers/video/backlight/pwm_bl.c                   |   50 ++++++++++++++=
++++--
>  include/linux/pwm_backlight.h                      |    2 +
>  3 files changed, 50 insertions(+), 4 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backli=
ght.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.t=
xt
> index 1e4fc72..1ed4f0f 100644
> --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> @@ -14,6 +14,8 @@ Required properties:
>  Optional properties:
>    - pwm-names: a list of names for the PWM devices specified in the
>                 "pwms" property (see PWM binding[0])
> +  - enable-gpio: a GPIO that needs to be used to enable the backlight

According to Documentation/devicetree/bindings/gpio/gpio.txt this should
be called "enable-gpios".

> +  - enable-gpio-active-high: polarity of GPIO is active high (default is=
 low)

There is OF_GPIO_ACTIVE_LOW, which is automatically parsed from the
second cell of a GPIO specifier. It will only work if you request the
GPIO using of_get_named_gpio_flags(), though, so it will only work in
the non-DT case.

I think using a regulator would be more appropriate, since it gives you
more flexibility than a plain GPIO. Does anybody see a problem with
using a regulator instead?

Thierry

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRNZpzAAoJEN0jrNd/PrOhNegQAKDqBN+Kq/5AlQGBPPQgcx4p
6WoNqf1YdNjq+kn6d68tO/bNXVDghoYBliCI78it9Bl+xR8Oflkr9gwGLiJhkHJO
XvWZOtKhjqzJuY8sn5Pt1TCTUVENR/falyySU0btRp8vMMcS4mDzRa7p8NZAS7Kd
VX5RxXHrNF6OYO+/cHo1WVLWODi0xUbEVBFXE532VFCzY4FGDy/r5Jh3a+KGlWYR
w/xnvDbJzgJkunQ/KuPege7zrcoqHsMsnpvEk+ljbNHPdIckIQyBRyLUtNk9zeAh
rU27mjQeK1OlVPlrxiPhG0UcTRCu2pmDaMiT0OlCON9qyCttbHefWUuMGaEejQY2
zbJYJynwhLqhasVh1zW/v4FWg8wmBMUGdXpcvBgZ+zcQ9+bUR9lNXncIHZbbhn0E
2JuOQRa8bPjOex2xiJnC+gqs9iCpZc3Tv/babLEdm6Es8ixRAWsO30DgbWBPzJK0
vjgQRzMNkJVSROe1M8FE8PGHO/xXNbgX8DO1T/u7l2j90zAKfj6kw5uLjqpTvI3R
wtfOUkeCavRRxIdGy9X4g2V2y+zhOdmvuj4hZG9mkaVxq34jqWTVuVaQPpAACiO/
GgzsUHvujJq/XBUn5Y7It45wfe9ly2Y4PT6tyPKFbegl3y3QpDKMDRiosHvbe9iJ
emp70+CmiSYkx25NuZhk
=gT/8
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
