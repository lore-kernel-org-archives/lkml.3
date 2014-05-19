Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaESNaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:30:39 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:62017 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaESNah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:30:37 -0400
Date: Mon, 19 May 2014 15:28:23 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] gpio: make of_get_named_gpiod_flags() private
Message-ID: <20140519132822.GA9728@ulmo>
References: <1400306090-4092-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <1400306090-4092-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 17, 2014 at 02:54:50PM +0900, Alexandre Courbot wrote:
> of_get_named_gpiod_flags() is visible and directly usable by GPIO
> consumers, but it really should not as the gpiod interface relies
> on the simpler gpiod_get() to provide properly-configured GPIOs.
>=20
> of_get_named_gpiod_flags() is just used internally by gpiolib to
> implement gpiod_get(), and by the old of_get_named_gpio_flags()
> function, therefore it makes sense to make it gpiolib-private.
>=20
> As a side-effect, the unused (and unneeded) of_get_gpiod_flags()
> inline function is also removed, and of_get_named_gpio_flags() is moved
> from a static inline function to a regular one in gpiolib-of.c
>=20
> This results in all references to gpiod_* functions in of_gpio.h being
> gone, which is the way it should be since this file is part of the old
> integer GPIO interface.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> Changes since v1:
> - Fixed compilation error when CONFIG_OF_GPIO is not defined
> - Fixed warning due to of_gpio_flags enum not being declared
>   in private gpiolib.h header
>=20
>  drivers/gpio/gpiolib-of.c | 14 ++++++++++++++
>  drivers/gpio/gpiolib.h    |  5 +++++
>  include/linux/of_gpio.h   | 35 +++--------------------------------
>  3 files changed, 22 insertions(+), 32 deletions(-)

There are cases where GPIOs need to be obtained from device tree nodes
without a corresponding struct device. Do you have any ideas on how to
support such use-cases?

There's currently no API to do that except of_get_named_gpio_flags().
But that doesn't handled flags automatically in a way that gpiod_get()
does.

Thierry

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTegb2AAoJEN0jrNd/PrOhcKMQAJYpv2p10U92963/jN3m8Ub3
zF9y1NZAc7SUg0NrJhc1oN+kIm1fR/bofMcAXBvdwStOaVQkZxSMIa8bq06Rq/hg
Zdd23OcQ7lmjN4isj1GfWYdsPY2nUPY8FMdyqCl411aiA5Bus3FPfNqrAgE0fOLH
+oMFQ5Yw+1pxgHJgUblfDYNNiU0DEiSTh0hKrT+dS0vzSKDrm3FJn1K7U18n/4jR
HtaR1AnGHLiGWi0MOopL6HtukHLFiGJKbv5hTH/KsRUO9qxlDZMQiiXiHaM/Ic/A
RgQzV6ztEoAhNUIIODey3JygJt6CJJymbzVexb0clCTS92xDYzPkJg5vsuUm2SZc
dgyAFBCKlB+nhQ64Up0O5RS29cPg2PWOxz0zQbGpZV4aNSYLsViiDlEV5KtvTkbf
L2b+hnGUdo9wVKQk0tg9TlGzzRJxy5NJFcTErsl+i7chS/8u51RREBBZ9iK9OYnr
5JOJ8JALvgfGOXeXe2gRq0W73BvdCte6TzGj6iSWahWKpBFxsEQznWHe471DqSpe
tzaqjX4nni/L1dF9kTDXAJmdpbVd1KvJvJERU76//TEucrgWA5qnVdhQWFe64kIA
kFtiCkL+G9QYWEbcoHFsdaFplLF6lC6ILRslKyABT4eGEe75HspmJt2/mz6sz43G
qRxwjtUr2yAS8tml6h1j
=lQ1z
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
