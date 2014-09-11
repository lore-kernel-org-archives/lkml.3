Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbaIKLKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:10:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48536 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaIKLKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:10:05 -0400
Date: Thu, 11 Sep 2014 13:10:01 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: dri-devel@lists.freedesktop.org,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Bryan Wu <cooloney@gmail.com>,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH RFC 3/4] backlight: add kernel-internal backlight API
Message-ID: <20140911111000.GA552@ulmo>
References: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com>
 <1410364463-12692-4-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1410364463-12692-4-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2014 at 05:54:22PM +0200, David Herrmann wrote:
[...]
> +void backlight_set_brightness(struct backlight_device *bd, unsigned int =
value,
> +			      enum backlight_update_reason reason)
> +{
> +	mutex_lock(&bd->ops_lock);
> +	if (bd->ops) {
> +		value =3D clamp(value, 0U, (unsigned)bd->props.max_brightness);

max_brightness should really be unsigned to begin with...

> +		pr_debug("set brightness to %u\n", value);

dev_dbg(&bd->dev, ...)?

> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> index adb14a8..bcc0dec 100644
> --- a/include/linux/backlight.h
> +++ b/include/linux/backlight.h
> @@ -141,6 +141,22 @@ extern bool backlight_device_registered(enum backlig=
ht_type type);
>  extern int backlight_register_notifier(struct notifier_block *nb);
>  extern int backlight_unregister_notifier(struct notifier_block *nb);
> =20
> +struct backlight_device *backlight_device_lookup(const char *name);
> +void backlight_set_brightness(struct backlight_device *bd, unsigned int =
value,
> +			      enum backlight_update_reason reason);
> +
> +static inline void backlight_device_ref(struct backlight_device *bd)
> +{
> +	if (bd)
> +		get_device(&bd->dev);
> +}

Perhaps for consistency with get_device() this should return bd? That
way you can chain things like so:

	priv->backlight =3D backlight_device_ref(bd);

Thierry

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUEYMIAAoJEN0jrNd/PrOhUv4P/Ayd+EsTZZ4VxwJMQSRtrn1z
okJgTTcJfC902PW+irsyGdacSAJygB4HOKJMNREFXIZtAa/CkkfSNiOCOpREROkW
6L0/0Hx0WILj/9syD5LuNOx3ijUuh8nysmYq34l48vH/adoo6N7bhGh+EmKAoeGm
CgPAbRaxfKWaYrVT4B86YV0aubAqz2gAPrArPR6cJk0TDU6EsXjmSGbf0ptF9JNn
BlcYA0kOGczonLgH8vVNZuDezs0khUSNu0N5FwT6h4xG9zw9PAEY6ffJoHIZmFQT
XSv7Nw1mq5nokikz5Jo9XlzFi74k6Xe2T3nAGvwymDZhRMoD7KYqOyL+5MQtRtAY
YUluuUxWmhNZhogFIa1sjCvWyU8b8fywZLvZdOdmMiHntF/BDOGX021bK4bfyHu5
ZnU9LlFIaUXaonEnfu+r6fRHhLuRx+NNvfVTmdtvgqImCI6+YlQZsy5tsg95o3UE
Li02DSEWN6TcSG/xrE6ZdZQn0JDrqyN1Zr9lY9a6dQwOPZ2Mpu3g7p564u7aUcTq
SdbkGJ7jDQziu5hyihn8E7flAXaVxRzr6GVfQYPGbtEPQoXpa8232nTC8zfyBkJm
+SEHh+9o3NZuEaDJAfn0iAP5uMBZoewgG66QJiFcC6MoAO2Ca7pWyAI67ErBg+Ak
PihUo/6OG0feOMq+2yR4
=A1BS
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
