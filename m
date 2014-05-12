Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaELFQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 01:16:57 -0400
Received: from ozlabs.org ([103.22.144.67]:52139 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbaELFQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 01:16:55 -0400
Date: Mon, 12 May 2014 15:16:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: linux-next: manual merge of the gpio tree with the net-next tree
Message-ID: <20140512151647.1ceae8f2@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/MVjs+d+Msi0bgSUrUcBA4U+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MVjs+d+Msi0bgSUrUcBA4U+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the gpio tree got a conflict in
Documentation/driver-model/devres.txt between commit 6d48f44b7b2a
("mdio_bus: implement devm_mdiobus_alloc/devm_mdiobus_free") from the
net-next tree and commit f9748ef13b6a ("gpio: Add missing
device-managed documentation") from the gpio tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/driver-model/devres.txt
index d483f2cf221b,8ff1167cfedf..000000000000
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@@ -310,7 -309,7 +310,12 @@@ SLAVE DMA ENGIN
  SPI
    devm_spi_register_master()
 =20
 +MDIO
 +  devm_mdiobus_alloc()
 +  devm_mdiobus_alloc_size()
 +  devm_mdiobus_free()
++
+ GPIO
+   devm_gpiod_get()
+   devm_gpiod_get_index()
+   devm_gpiod_put()

--Sig_/MVjs+d+Msi0bgSUrUcBA4U+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTcFlEAAoJEMDTa8Ir7ZwVhxgQAI5sk/kqpjeNzZN8CUOO1h5w
42mbASrCn1dgUO+dns6PmIfdnCnKqrMlZpt3Ri8eDWIGTJvn4YtQfsjx4hcXNen4
bd3yycCeoduHkzY9BnarW8bTa0xHsu5wND4NOHVCJFO8sMeRKq+J1I2KX0Jvam5U
i0M9p1MqBpt+n/6b4qgM2TTGh9cBPJep5vF1bZLHUBdK6TS94+9yOaYvow9lD0Yz
7OevnKrpRw7jybG0i1HQDhKFY03Ec2UeiY0I74yG9IiFZ5ttKyk4MGXi+ZJrDbq8
5MfPdLEuZYsGDtkZ/oUbCjlPz9vMiFWbwsUpqINnUN8osLfNXakgOMvgjcy1JjvZ
drZQy4BHhI/NpJJ8W9s3jHXBT/tD9aCl4DglspWXnIewdKlS1Gcy62GI6+woSqAV
JqOJxV4ldYv1SgTP+Pf4v893KPTJwT8+l0xKNnt5gh0NU3Vj/fOePgfuxI6ltTXa
6sTJ94fPD5XQ764AuJ2qLzPtuMF9IllntoWi4zpARagWuCpODYvgzHCSc2BJH66i
BF/PRZg/mqP7uEeqooif3ctbgifF10P5NgENudEKjmpoIltEeBkJBrxsMnWBOI4D
53jN7IYH1LHyCzhMmP6F8AkB7vpBQZNTekvBhTqyUAvyitGnfHcE9iAFb7Pc/wC5
v8YHRUZxOBI8sBVBC14l
=VVtt
-----END PGP SIGNATURE-----

--Sig_/MVjs+d+Msi0bgSUrUcBA4U+--
