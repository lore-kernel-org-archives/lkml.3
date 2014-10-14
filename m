Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbaJNNyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:54:51 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33764 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbaJNNyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:54:50 -0400
Date: Tue, 14 Oct 2014 15:54:47 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Bart Tanghe <bart.tanghe@thomasmore.be>
Cc: matt.porter@linaro.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH v7]pwm: add BCM2835 PWM driver
Message-ID: <20141014135445.GA26015@ulmo>
References: <1412763272-24269-1-git-send-email-bart.tanghe@thomasmore.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <1412763272-24269-1-git-send-email-bart.tanghe@thomasmore.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 08, 2014 at 12:14:32PM +0200, Bart Tanghe wrote:
[...]
> diff --git a/drivers/pwm/pwm-bcm2835.c b/drivers/pwm/pwm-bcm2835.c
[...]
> +static void bcm2835_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
> +	u32 value;
> +
> +	value = readl(pc->base);
> +	value &= (~DEFAULT_PWM_MODE << (PWM_CONTROL_STRIDE * pwm->hwpwm));

While applying I noticed this oddity. Is this meant to be:

	value &= ~(DEFAULT_PWM_MODE << (PWM_CONTROL_STRIDE * pwm->hwpwm));

? That would match what's in bcm2835_pwm_request(). If so, what's the
difference between DEFAULT_PWM_MODE and PWM_CONTROL_MASK? Is the value
of a channel's field 0xff or 0x00 in the default mode?

The above indicates that it would be 0x00, in which case it might be
better to just do...

	value &= ~(PWM_CONTROL_MASK << (PWM_CONTROL_STRIDE * pwm->hwpwm));

... and get rid of DEFAULT_PWM_MODE.

No need to respin, I can fix this up when applying. Just let me know if
that's actually the right thing to do.

Thierry

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUPSslAAoJEN0jrNd/PrOhoUsP/0wYidvmLWNAtO1GwOQpdVaE
aR5EvCTeH+9tX8gf8g8X+7KkHihav4z1XSWct/ar07RccmVXGl33GVEAMZ31t4/X
k+LgwwGHLWsOg+MLwM+ivSnQip3yeOv+/Dk1NLB416yZmRTB3OFRG7L0w1m+yONZ
d7P796lhj0LfaxsPefaD0AcIh/kjnXLjIbJJ08A9uO93NnWj6YoQuGUTTXZe3Ksg
svx65Kh8/xPO31As3JtIz0HeHjc8DXHnLSSLYw8C8ooR3ZP9/HJVrm2WlApMrTcw
wjAtJfma8HvWJqQRXgdZWzLatFgu1p+i4ZxALGKr9XQZMs2QP/7+OHfaBOBDYeSV
PVTp0dw94uoS6GwPnGdfPBz6JM626K5AGNsYsO0+HLAGqa3SqieN1Pm4nBtSuJSA
cNlOl8E0ylizkj6iO7KQRpa5c17pm2L70iuRsmjdN+gkaYeZc6QxJw6SjjZYrXW4
7P2jakrfJF8P5PiWLuMZb+ytJwxKpLE1hfyumxwfRnh4sbYKdKl1WFbG7J9Ej8Rs
HYR3lVEamiT/tD0YKR7lIzMY3+wsCs/NoCTeo7vvOJcUBpB1SAKbmalkxnMdKInB
ofOogQf0A+q41Gqa5Rz/k0Q7FM5OqYH1igsGkEiYfHnmmchAgvNrl0aXzGfA+mgr
twG7/Pb25zIU6wGx5D8y
=E/wR
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
