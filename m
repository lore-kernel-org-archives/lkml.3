Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3GXQGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:06:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57548 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab3GXQGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:06:40 -0400
Date: Wed, 24 Jul 2013 19:06:35 +0300
From: Felipe Balbi <balbi@ti.com>
To: Illia Smyrnov <illia.smyrnov@ti.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Felipe Balbi <balbi@ti.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] Input: omap-keypad: Clear interrupts on open
Message-ID: <20130724160635.GG29384@radagast>
Reply-To: <balbi@ti.com>
References: <1374681293-5320-1-git-send-email-illia.smyrnov@ti.com>
 <1374681293-5320-4-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bO4vSxwwZtUjUWHo"
Content-Disposition: inline
In-Reply-To: <1374681293-5320-4-git-send-email-illia.smyrnov@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bO4vSxwwZtUjUWHo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 24, 2013 at 06:54:53PM +0300, Illia Smyrnov wrote:
> Clear interrupts when open keypad.
>=20
> According to TRM, the recommended way for keyboard controller
> initialization is clear the interrupt-status register, then set up
> certain keyboard events for generating an interrupt request and
> set up expected source of wake-up event that generates a wake-up
> request.
>=20
> Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
> ---
>  drivers/input/keyboard/omap4-keypad.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboa=
rd/omap4-keypad.c
> index b876a0d..0244262 100644
> --- a/drivers/input/keyboard/omap4-keypad.c
> +++ b/drivers/input/keyboard/omap4-keypad.c
> @@ -185,8 +185,9 @@ static int omap4_keypad_open(struct input_dev *input)
>  			(OMAP4_VAL_PVT << OMAP4_DEF_CTRL_PTV_SHIFT));
>  	kbd_writel(keypad_data, OMAP4_KBD_DEBOUNCINGTIME,
>  			OMAP4_VAL_DEBOUNCINGTIME);
> +	/* clear pending interrupts */
>  	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS,
> -			OMAP4_VAL_IRQDISABLE);
> +			 kbd_read_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS));
>  	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQENABLE,
>  			OMAP4_DEF_IRQENABLE_EVENTEN |
>  				OMAP4_DEF_IRQENABLE_LONGKEY);

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--bO4vSxwwZtUjUWHo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR7/uLAAoJEIaOsuA1yqREHBUQAI4KLEaUN+lF+B34fyOJudxQ
YNRNsTNejFUQsD8Zp76a1is8uEvvBqQdHjE/RG15r4uNt4QbId/38FHpzb2Jjw4F
B9kzxq5hcKCOismZiZh2v9XH/Q/Hl4r0SsS5KNJ9FDA31mfeyO/4oKlYRy4RvSH3
XwoKeHSGHw6tRqo3W11z5psZFT5Iwt1ag92TGzXtSRpRd1YJapOFi8yeKg/N/0Bt
XXeQGdeJrPdObl4FcJ9Bl/luG5oTkS9bIoEMrRWjG5iwVUtCn2KWnpncLsVz7D3k
+RursuwahvaZOy/2UIFYUINX+C63HIvtBUTvYZa3N5XogYjIfX8oqayNoYzN4dFY
+Guqv4adgYYPvRHEujU9hlW83I53s2jascgpVXg0nye21KG+d3215hb6D38jG0wN
hzf+oRp73Bajb7M3vG/+J90AU1AoL4OQcfy7idUBZ3hYDXyOlg1SNms8gtGHXUw2
FDQskgBhyBW8Q8D+FWIuuTjqJlB61hBiIxFBDE72qGWAjg2UMXtUmJAqZkgGmZVm
bh6wMaVZ1vmwIA5TfibMr2QibP7HGBPHgmRFbuZfYt+SYFy+P+C6JZtn7sp7ZcZ/
uuXPiYJzevSJZ4MD0qvlZGqcqUt6AxrntuhHsxOnKjGjz64OY+3y49vBdBw/VtcD
rR3i8k3IicXAyju9ESsH
=5lgY
-----END PGP SIGNATURE-----

--bO4vSxwwZtUjUWHo--
