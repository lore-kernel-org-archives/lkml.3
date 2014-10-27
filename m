Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaJ0DfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 23:35:19 -0400
Received: from ozlabs.org ([103.22.144.67]:56607 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbaJ0DfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 23:35:17 -0400
Date: Mon, 27 Oct 2014 14:35:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Naveen Krishna Ch <naveenkrishna.ch@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: linux-next: build failure after merge of the pinctrl tree
Message-ID: <20141027143509.550b8545@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.0 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/C1BSpUh2I3mVNTU03U7UEow"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/C1BSpUh2I3mVNTU03U7UEow
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the pinctrl tree, today's linux-next build (arm multi_v7_defc=
onfig)
failed like this:

drivers/pinctrl/samsung/pinctrl-exynos.c:1194:43: error: array type has inc=
omplete element type
 static const struct samsung_pin_bank_data exynos7_pin_banks0[] __initconst=
 =3D {
                                           ^
drivers/pinctrl/samsung/pinctrl-exynos.c:1195:2: error: field name not in r=
ecord or union initializer
  EXYNOS_PIN_BANK_EINTW(8, 0x000, "gpa0", 0x00),
  ^
drivers/pinctrl/samsung/pinctrl-exynos.c:1195:2: error: (near initializatio=
n for 'exynos7_pin_banks0')
drivers/pinctrl/samsung/pinctrl-exynos.c:1195:2: error: field name not in r=
ecord or union initializer

And so on ...

Caused by commit 9d3de28d785f ("pinctrl: exynos: Add initial driver
data for Exynos7").

I have used the pinctrl tree from next-20141023 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/C1BSpUh2I3mVNTU03U7UEow
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUTb1xAAoJEMDTa8Ir7ZwVJMIQAI1OOG8NNXaMrovW4i0hSHNg
lqJMuqSlEn9cUIMnO80i15lb0n8ZDgi2H47jGQhN4dJnPjfLncrIrtjKPOQ7LIXY
oBw8cNqfqyOCO7rLVXmUsg31jJKfNx+MgAHqR6TmTcPG0IFgVgC6Y8LNkEnaIvG9
BryUlKu8u5I2HKpRbKrA6tQMloM0XpbFRqf+ZApbqw/nBQLlPuH+vbZfSgxBcSUL
qG/9l3NWIH/Q6Y48BAF4H048P1qmEQhcUTKG8Tp72H1+cfjIh4nzmVtbKT1LPCbl
tj7TRUvL1zZSqGuTKwWOXAQSlW2qRX9omorOhwWTJfZLd4UqY6nVLgp9PU3UtSW+
mBQ4oQF5ciEzXJPM1+ucxccz1TufW98OAiA6k2Uj92++oFVAHaqZBWtd4N3Iq/73
yKVe2j49atPw3bnUOmJr3xORadLiTZGZ3rVgiyzk6V/WLY/TPKjTakEUPccY+kP8
qfUir4ntUYBzcLP8pv04MeabCXz23gycHLmdf3nSLgAsWWylt8xWwdNcNqCmUZT7
2sZ6GAksP0JursKh5vZqBjdAOQdP4A7mwX6lI+VU3zkSW6dU4flc5hnBa4aj7b4p
Kgj4iq/lieJyuGxuyNq2lUErnuHxzbK2u6NW/OO1cl6E50L0BI4Dp6CNbnLGwPO4
hYmXDV/asCwE/9+hkMpj
=Oh+d
-----END PGP SIGNATURE-----

--Sig_/C1BSpUh2I3mVNTU03U7UEow--
