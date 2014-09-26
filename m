Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaIZFkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 01:40:40 -0400
Received: from ozlabs.org ([103.22.144.67]:46933 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbaIZFki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 01:40:38 -0400
Date: Fri, 26 Sep 2014 15:40:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carlo Caione <carlo@caione.org>, Guenter Roeck <linux@roeck-us.net>
Subject: linux-next: build failure after merge of the watchdog tree
Message-ID: <20140926154031.4bc4dc39@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/+GUNZME0gKrn5XI5uxzLddK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+GUNZME0gKrn5XI5uxzLddK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Wim,

After merging the watchdog tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:


drivers/watchdog/meson_wdt.c: In function 'meson_wdt_probe':
drivers/watchdog/meson_wdt.c:178:2: error: implicit declaration of function=
 'register_restart_handler' [-Werror=3Dimplicit-function-declaration]
  err =3D register_restart_handler(&meson_wdt->restart_handler);
  ^
drivers/watchdog/meson_wdt.c: In function 'meson_wdt_remove':
drivers/watchdog/meson_wdt.c:193:2: error: implicit declaration of function=
 'unregister_restart_handler' [-Werror=3Dimplicit-function-declaration]
  unregister_restart_handler(&meson_wdt->restart_handler);
  ^

Caused by commit 575f4153957b ("ARM: meson: add watchdog driver").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/+GUNZME0gKrn5XI5uxzLddK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJPxUAAoJEMDTa8Ir7ZwVkkQP/j1Hzw737if18HKs3fj9sIGy
dMAm4A6OsfHZiZtbMAMhcfj0Sp+OH5fXbbq2sDNa+ogzvUNV2TuoqmYhR/OxI0j3
2F9nkLwjRW4Q7xpYpFS8TwPVD07rPia+kzJY++pJlHv5fD+tZx5wduJil7KExJ3S
kPOCmrB8yECcgdpr0iA7li4twpqS09o9QjKaxLT2S28/DoQyOwPgmTsdEBQeX2gB
iBsiNRg/1CNcfEzw6BByz7YzJ7D2CJREYNR/ShA1pEsi3PYQcjN3ON13fiQg/d66
l8MGdtrVSyHY2vRz3bnwjOznJLa3ra53LLfd2xZ56ipjnF61GBMZMy2Cc+Q1XfMw
YYBv9Z/cWucTlRoeMo5HIp6nl+DYxnoG3itntDGXyz+CxOIebqALHz6KuDO03wCh
FjfDgxYVoHKzsd0yCFThCdTXLHNyVNodxoyIa6ePWaM24O3mhWIey7CZ842Myh8E
kHXX0O0e/C1+8hLR6GnYNC4nQ/mDzyQ3LoiSiRrfAuybibRb9VETbdINAVIicXD+
+E93ma/0WNiQTUYN4pp5ZuTyTfPWdVe0xEe0OnObEk6K7gZ33kDtovMIBtp1Wh/7
LUYxaEPKhTZ8pWDD8sbA4LvsryHuYG8PPodg+rpqSv4V7C4gyDTNAcscnr5cQf1U
f/TK30ObAH/MpTvPawhK
=WPyi
-----END PGP SIGNATURE-----

--Sig_/+GUNZME0gKrn5XI5uxzLddK--
