Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaE0Elf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 00:41:35 -0400
Received: from ozlabs.org ([103.22.144.67]:56958 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaE0Eld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 00:41:33 -0400
Date: Tue, 27 May 2014 14:41:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: linux-next: build failure after merge of the regulator tree
Message-ID: <20140527144123.2ae08251@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/nK3coX+YyU0Vw1og2paTjV0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nK3coX+YyU0Vw1og2paTjV0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the regulator tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/built-in.o: In function `ltc3589_probe':
ltc3589.c:(.text+0xccf24): undefined reference to `devm_regmap_init_i2c'
drivers/built-in.o: In function `ltc3589_driver_init':
ltc3589.c:(.init.text+0x9ebc): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `ltc3589_driver_exit':
ltc3589.c:(.exit.text+0x2d1): undefined reference to `i2c_del_driver'

Caused by commit 3eb2c7ecb7ea ("regulator: Add LTC3589 support").

Clearly some dependencies are incorrect.  Presumably the required
interfaces are in modules for this build.

I have used the regulator tree from next-20140526 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/nK3coX+YyU0Vw1og2paTjV0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThBd6AAoJEMDTa8Ir7ZwV32wP/2KkEqLnqTcjLCqWjfqgRhl9
TLIprzsBGHSsb9oonA3oj7IFCF+BjWcveqodMiLud5/6aBH9TyHhTl7yjYJXUbnY
tnB35zmvkZdrt+X/EBT3/guGyozU3TqnMujdhh4NW0AeUp/Y1Mzm6+5ddHOirb+z
3lnJuKLWPtqvonA5fFZiyMlNad3HTW5Z23JBy9A7HfNOPRx1T9LaaeYQLLtCrcVU
X16Y63v90qBDmSqpzMnIBRvAFD2INf9OQtTqoduTVbKUf6cuULCPvDLzJQOQEhzv
788vSByd2hpVHGY9noii4BIfmzL44gxISoa4pjumy2S+ew02PckCU5V6rTpQ4i3z
HIg7r6igOq04H/8Zs+4dPuYhiScvVoHKsuP7tr/5PyNoqsbEkr6qeW80dLZ93JVe
FaxX95NQ6928zkxPU5wy8e78oE7wd46VmqQs0/pYCbQ3OPF2RfuFJhznk4yUCKQM
HkL5wPs3p1o3NvBptW/kledV4OIlig+NaJlIoWHCkrV3KYSMJgx6CkjBKbrBjBsZ
k4Hwled0N5KHES9KXEy0s8szdPSMjyRcj3AGySoH7hVdD2cZ8w1KaGpAn8pXgdvx
zs3bxenIfN47Ft9WS/HNEmX5h/+SA1CBzVImueXNHqpfYvNcAxnONe5IYBxGq2zX
2bMwoYSQUN0NXU4YASBC
=jp7z
-----END PGP SIGNATURE-----

--Sig_/nK3coX+YyU0Vw1og2paTjV0--
