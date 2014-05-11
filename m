Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbaEKVaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 17:30:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54566 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751663AbaEKVaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 17:30:14 -0400
Date: Sun, 11 May 2014 23:25:14 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH] RFT: pinctrl: sunxi: convert to GPIO irqchip helpers
Message-ID: <20140511212514.GV7047@lukather>
References: <1399621082-10712-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BtV3mSscmI0cqW3r"
Content-Disposition: inline
In-Reply-To: <1399621082-10712-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BtV3mSscmI0cqW3r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Fri, May 09, 2014 at 09:38:02AM +0200, Linus Walleij wrote:
> This switches the sunxi pinctrl driver over to using the generic
> gpiolib irqchip helpers for its chained irqs.
>=20
> As the .to_irq() callback on the gpiochip was doing some function
> indexing this was moved over to the .irq_startup callback on the
> irqchip (where it belongs, since it is perfectly legal to request
> an irq from an irqchip without calling gpio_to_irq() first).
>=20
> The gpio_chip was converted into a true member of the pinctrl
> struct instead of being a pointer to a separately allocated
> object, avoiding an unnecessary allocation and making it possible
> to use container_of() to get from the struct gpio_chip * back to
> the sunxi pinctrl state container.
>=20
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Maxime, can you test this thing? And if it doesn't work, can you
> figure out what it is that I want you to do and do it ;-)
> This is done on top of your recently pulled sunxi series.

Thanks for your patches, I'll give it a try some time this week. This
is also a good occasion to discuss a serie of patches to rework
exactly this code.

Currently, we support only the interrupts on the older Allwinner SoCs,
that had only one bank and one parent interrupt.

On the newer ones, like the A31, there is, depending on wether it's
the "primary" or "secondary" pin controller, 2 or 4 interrupt banks,
with a parent interrupt for each bank.

The core logic still applies though, interrupts are still a special
muxing function, so we can definitely reuse this code.

What I did so far is having a single domain, with the same handler
registered for all the interrupts, and the various interrupts from the
various banks just being at a different offsets in the domain.

Basically, something like that:
http://code.bulix.org/ym3zuv-86191

Do you know if it would be possible to use the generic gpiolib
behaviour in such a case?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--BtV3mSscmI0cqW3r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTb+q5AAoJEBx+YmzsjxAgdbMQALw0D7IicyVj8miAuKw9J5uQ
5FIIadkVP07/xtIl5GjTtKZsKzayQVXsiQXQNGpGwqkw8EqS0e/AQDvO1PGA+ASe
4sLw+net3ZkcbVlaDrRB2E5Ov9rSTaNzDqz1jJJ5M9KCh9D8vLoV+M0PjENZU/Ah
1HNRGWzUEcYRpRMlHW5bgRaZxlno6oww0yrANiVYtwfM8f13+SG4b9o0PMu/CF/D
MarbLpSYu2iL3//EHbbv+qjRNKBRA+F09gG2TQm5fhhhFawMplndwuwgYSZClfLC
rW3ejk/1cj9W/1N4v1ZpF+5Dt7+BbHfs0/LszJtpqkD5k58QUAPKRHL4vvBe/Kkx
yPZPV3mVBuEe4z79hPKsDSQd1kx3KVfAD9YqF0lvAKD5HIf1QzQ/kW5vQbpaR+vs
uJ/E1hdteILB2jd6Tv9kJympI0bhVEJsu8GPW2JuPWoMx1UwXVDoQqMzu5H196Qo
o5ojYHiBvfPW+OFb70SjpQOf5lcPqCsybNE7CqV6ipOvY/FdjqJ3g07yHIda537T
je+V1xGlgv4+jXPYrP2ZDXfvVBN+f2QYupIQkzFdFzoJoUiTCtFnmeFZNavdfx9j
UjcM8v6o1+dSggHoBjD+LLw0j2Vi2O56wVsWqHdHS6uMHaqTmVwusbi6dczJ0nJG
phLxWpoDS9E4uPnAMor+
=IpHV
-----END PGP SIGNATURE-----

--BtV3mSscmI0cqW3r--
