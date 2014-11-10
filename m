Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaKJETI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:19:08 -0500
Received: from ozlabs.org ([103.22.144.67]:44636 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbaKJETF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:19:05 -0500
Date: Mon, 10 Nov 2014 15:18:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>, Aaron Lu <aaron.lu@intel.com>
Subject: linux-next: manual merge of the driver-core tree with the pm tree
Message-ID: <20141110151856.0b644fb3@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/42O_w7HlK2co7k9T9GMiGKO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/42O_w7HlK2co7k9T9GMiGKO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/input/keyboard/gpio_keys_polled.c between commit b26d4e2283b6
("input: gpio_keys_polled: Make use of device property API") from the
pm tree and commit 1d05726c315c ("input: keyboard: drop owner
assignment from platform_drivers") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/keyboard/gpio_keys_polled.c
index c9c1c8ca7267,10f0098f3c77..000000000000
--- a/drivers/input/keyboard/gpio_keys_polled.c
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@@ -297,8 -307,7 +297,7 @@@ static struct platform_driver gpio_keys
  	.probe	=3D gpio_keys_polled_probe,
  	.driver	=3D {
  		.name	=3D DRV_NAME,
- 		.owner	=3D THIS_MODULE,
 -		.of_match_table =3D of_match_ptr(gpio_keys_polled_of_match),
 +		.of_match_table =3D gpio_keys_polled_of_match,
  	},
  };
  module_platform_driver(gpio_keys_polled_driver);

--Sig_/42O_w7HlK2co7k9T9GMiGKO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYDy1AAoJEMDTa8Ir7ZwVc9MP/0K/i/3g7n+NDa1jl0+kGad3
fvD3y8JLOHTKYBx2pFwLL4JROviUNCmLE0THrz8lyrD9ldHR5z42OnbOgJpHlLZH
LPKPmP6KHpv6NrW16qEOFQoEVecVAZ1khghxWfUmtkb3s35YigriCU4doFErbWBK
KQkUkX7T7dtCWvYjUXwvg9mjX3yRxcyJSasxH2yjic/ej6ojtfwGiqV8NZXPh/IC
ZruYsdO7wMqIx9Y66g60sst/x8aU4K+dSVf0OIShcsd0fTYMfaE3xARu7uyzO3TT
4dRzZum/BL0htwRCCGBpj+bTgJhERXbk6RIkAyOrJFcJCGHZ7f//oz1IIbMjp4kM
0fWbY8ARW1LaI/ukrspF4Rq0rsL3VVFNy+8uuK2FDTA+Zgg+tv8qAcF389oiM1NQ
yi0rjfaJJe4mqwNDpHPaHk7unE6IBlz6N7bYitalOPOIWpHRBzej0kwi9ir9D0QW
CJAqV88Z1je8D/7Wwm6FfadO73G9zmP3kKlaCLrJcYiZ1qZmj4AKNzSwCKGd3Zca
UfcKW6dIv2lfpteH8awxqwyi6wgzWcgw54PjHYPns4WKxN23Ii61yF9hVEg8XwkV
5pxkZiOShSlMd2D9IgdmtNAohIdOHtg/cENqDCy3C3UMS2hBg3nQQdl0eYCxeEQc
gfWyn2ROLmSFpx/pLfh5
=3nrY
-----END PGP SIGNATURE-----

--Sig_/42O_w7HlK2co7k9T9GMiGKO--
