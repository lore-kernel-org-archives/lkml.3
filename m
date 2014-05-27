Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaE0PfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:35:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39233 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751711AbaE0PfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:35:05 -0400
Date: Tue, 27 May 2014 17:34:56 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH] RFT: pinctrl: sunxi: convert to GPIO irqchip helpers
Message-ID: <20140527153456.GL4730@lukather>
References: <1399621082-10712-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aqWxf8ydqYKP8htK"
Content-Disposition: inline
In-Reply-To: <1399621082-10712-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aqWxf8ydqYKP8htK
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


I've been quite late at testing this, I'm sorry, but I finally gave it
a try.

Besides the minor glitches here and there that were expected, I think
that it can't really work now given the state of gpiolib_irqchip.

The way this controller works depends on two cases:

  - On the older (the one on which we support interrupts) SoC:
    + we have 8 pin banks, almost all of them being at least able to
      be muxed to gpio in and out functions.
    + 32 of these 256 pins are actually muxable to another function
      that is the one to generate interrupts
    + The interrupt controller is a single 32 bits register, each bit
      being about one of these 32 pins, that are pretty much spread
      across the banks.
    + There's a single parent interrupt.

  - On the newer code (that is not supported yet) would be a bit
    easier to support, since the interrupt sources are grouped by
    banks. That means that we still have our 8 banks, but this time, 4
    banks are interrupt controllers. These banks support as much
    interrupts as there is pins in the banks, with a 1:1 mapping
    between the pin number and the interrupt number.

This is not something that looks to be well supported at the moment in
gpiolib_irqchip wrapper, especially since it seems to be making the
assumption that there's as much gpio than there is interrupts.

But I guess some of these changes are still useful, especially the
ones on the callbacks.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--aqWxf8ydqYKP8htK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJThLCgAAoJEBx+YmzsjxAgnHYP/0Zmsvy/HYhcEhwVFcgxVZM0
toLzqlX4yD6yDuf3nbFZ1Er/wr+Dgb9ln4TldAeSwhrtc70CCONFW54tDRyS4bht
zR6e8wu0ZJNa5jByUaZBJGuc0//6ZztCscID1mxWzA36v0lwsfUOZwc4+lyNBPJm
a3Qq8JQJtcfmsZTyxGG5mzgU/iFOlvfGeimAZ3AxJZzcjDTMpHec49Jcz0b09o4o
dub2EtrusgDTEQiPcNThjO/70hSn0fDpTesW7nFGlXg0/o/HEnYEvsO4FBh/PQz0
TtfhdQ8THTjjXW2GMG1IPoBtYu2PMqfQRtT+V6W8wBceRu2hZzg/SYCgF/NFsc5o
rXchhr/4aHcXOMdQtDupdhX5tIjTYrkJUu1gdE/4VVBZPzZdSodp0pCJrXjFgZjn
W0Pr5ZDka0F0Cv+43aeYwwTOXg/9+tyWeiI/fwoMWJWX0jGKJlKXBbbjxDBrc5Bv
ZoGI/ifaa6hm+IfbpQD9iaZ/hB8xtE9ixZtuS/bFegWPOuOqNGtHnH/64DLCby8X
yiFL91gBc4JHlEB9e5je2kG3ZtA1LtHg4+OuMIOkGh/jcycCTWLF9XOuYg1379ol
ma3iGFPI+MkPQDR1YMAte7D+gA5IWq0My1pTKBiG3q0KkEwrqAbxIHKTgHMuSBcb
8xkk6LoFBG+6/nFc6toC
=lChM
-----END PGP SIGNATURE-----

--aqWxf8ydqYKP8htK--
