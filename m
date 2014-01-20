Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbaATFmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 00:42:33 -0500
Received: from ozlabs.org ([203.10.76.45]:35943 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaATFmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 00:42:31 -0500
Date: Mon, 20 Jan 2014 16:42:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars Poeschel <poeschel@lemonage.de>
Subject: linux-next: build failure after merge of the gpio tree
Message-Id: <20140120164222.e56f0c9abfbe4f3dcf726d4c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__20_Jan_2014_16_42_22_+1100_IpKbluxJ6grWWHRs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Jan_2014_16_42_22_+1100_IpKbluxJ6grWWHRs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the gpio tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/gpio/gpio-mcp23s08.c: In function 'mcp23s08_irq_setup':
drivers/gpio/gpio-mcp23s08.c:482:46: error: 'struct gpio_chip' has no membe=
r named 'of_node'
  mcp->irq_domain =3D irq_domain_add_linear(chip->of_node, chip->ngpio,
                                              ^
drivers/gpio/gpio-mcp23s08.c: In function 'mcp23s08_probe_one':
drivers/gpio/gpio-mcp23s08.c:651:55: error: 'struct gpio_chip' has no membe=
r named 'of_node'
  mcp->irq_controller =3D of_property_read_bool(mcp->chip.of_node,
                                                       ^
drivers/gpio/gpio-mcp23s08.c:654:43: error: 'struct gpio_chip' has no membe=
r named 'of_node'
   mirror =3D of_property_read_bool(mcp->chip.of_node,
                                           ^

Caused by commit 4e47f91bf741 ("gpio: mcp23s08: Add irq functionality for
i2c chips").  The presence of of_node depends on CONFIG_OF_GPIO.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__20_Jan_2014_16_42_22_+1100_IpKbluxJ6grWWHRs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS3LdEAAoJEMDTa8Ir7ZwV8CoQAIbyMw3s2cyDuE3c3F+RD/vX
Fl8NTXlrIvJE1nOOCsl7fox5ftFEkbHEZIbXk3OucrFaYsl7FkusLnBBwffHTmFl
5UgBBZbJwWv684GExO0lF2wM6oh/gj304d4pQEtlzmSyV9PdW08a7mytcNHTYaL5
rcMg5sqj3K6bM7HrOJXmX9MJQxtN+n1rBNN+jd0GV5x90U/nyH7zGAGK3+0hkMKe
vBzZaqE5vBjLcGrICJCEFNGlBbvvTTqAn98I4+VYX4DUExNPmToffZKZEDJZQznr
eANM69IJ1FuJu1HR7/q0hKgyN2FqbbK8y5NvvVKKewMJcByx9Qhg9Rt3jgERbDVn
zUFmr1yT+IIsdtWQTkuwcPEoy3RiDHt8+2Wqa15S4d6ytCs+JzVT4djqfHqrLJCI
cvvkrQBXPxNGFFrA6j4PjtMx0POqMoI8XfKTrCKOATVKIWmfjqOEgANFbveHUTm3
lbUgGkGdqXle9RifCrPdHcn9OrR7wjNy+xfX2+r0+pKdVITd+JOjNv1rXAwNrGo9
6ZbHVYmOqA/ee0jqe/j57GwVbLgcPot/MBtYMO03YnEkgOXhZkvjvPyZPiT+9y94
St/tSCXe74OatQiVUYA3GNBG43ddCgRVvPIxCAg72Cd4MoaQwUFDgxsgcHl/6tUJ
+POTNBWqMvd3o/QVjz7D
=yIXe
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Jan_2014_16_42_22_+1100_IpKbluxJ6grWWHRs--
