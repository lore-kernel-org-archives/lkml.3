Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaKJEVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:21:33 -0500
Received: from ozlabs.org ([103.22.144.67]:47406 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaKJEVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:21:31 -0500
Date: Mon, 10 Nov 2014 15:21:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: linux-next: manual merge of the driver-core tree with the  tree
Message-ID: <20141110152125.73e33634@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/9paZSJo/GD88msEAUpyZ07p"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/9paZSJo/GD88msEAUpyZ07p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/leds/leds-gpio.c between commit a43f2cbbb009 ("leds: leds-gpio:
Make use of device property API") from the  tree and commit
81902d5f658f ("leds: drop owner assignment from platform_drivers") from
the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/leds/leds-gpio.c
index b3c5d9d6a42b,ac4768f2b2b4..000000000000
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@@ -281,8 -287,7 +281,7 @@@ static struct platform_driver gpio_led_
  	.remove		=3D gpio_led_remove,
  	.driver		=3D {
  		.name	=3D "leds-gpio",
- 		.owner	=3D THIS_MODULE,
 -		.of_match_table =3D of_match_ptr(of_gpio_leds_match),
 +		.of_match_table =3D of_gpio_leds_match,
  	},
  };
 =20

--Sig_/9paZSJo/GD88msEAUpyZ07p
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYD1JAAoJEMDTa8Ir7ZwVZuAP/1wRIGPxo8cbbGBp+LqDdC4P
IyXyBU5AtrUFLmg9wsd2cNgXrtljfonzF5wRHxD6yxqa6HjfXrkxApTExhffPFxf
X0BeKkzE2jTzBd0DYFKhdjMO7ouetYENwQQZpkhnYdyQnZYa34sZMwKf8DLthPrT
tnGHBcxxMmEyNGQEVhtvaZgeaCVmsAXjPDMADFrfpaywnvTaqzTzC/IiSl6N7ZT9
+fYGn0RdB/DHuW8lASpHDzmqOxp5xABrftzD3BiNVxANGAIzRr21WqKYs6bqDjiB
B9X2Xc7WpNBV4x59ztzQyRtdT8mstZecKHVvndgvGiZtMCeVVh/D/iSSFp7Sbojj
GQAiKjuWVezk+dYVdMHG/ZP4Z9qahJKZ1BHslrZra0hdUpTxrbTDizU82SlMP5OL
16p6b1bmbe4X2yO+TQHTJzmGggKzPjGTRTg/Hua7z79nPjIuutz0jofD8y9bLdq6
wFOUFfsHh+swR6Y8JauawD9odLd96xuPdjqJl5GPdeQ2FEnq294cjUV0FhSDd6Lx
knq9HkJdp5UcV7L10uYk8BLHHRxi/4B0pj2QHk4k5oitMG9FgF6EBe/mZkCpjGBs
MshshOsFxRxAKjTwY3DSoTIgl2CR93kH/BLUMqpVFc22THJyz1QL/dkIMB7sUU0v
LAzJ8f3Km+UzOnFJ/OH1
=pQzr
-----END PGP SIGNATURE-----

--Sig_/9paZSJo/GD88msEAUpyZ07p--
