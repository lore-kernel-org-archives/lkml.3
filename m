Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaG1Kcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:32:43 -0400
Received: from ozlabs.org ([103.22.144.67]:45917 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaG1Kcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:32:41 -0400
Date: Mon, 28 Jul 2014 20:32:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: linux-next: build warnings after merge of the regulator tree
Message-ID: <20140728203233.26341abf@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7k69u1LqMXVUBZde=3W.0MM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7k69u1LqMXVUBZde=3W.0MM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the regulator tree, today's linux-next build (i386
defconfig among others) produced these warnings:

In file included from include/linux/regulator/machine.h:18:0,
                 from drivers/acpi/bus.c:36:
include/linux/regulator/consumer.h:468:23: warning: 'regulator_get_regmap' =
defined but not used [-Wunused-function]
 static struct regmap *regulator_get_regmap(struct regulator *regulator)
                       ^
include/linux/regulator/consumer.h:473:12: warning: 'regulator_get_hardware=
_vsel_register' defined but not used [-Wunused-function]
 static int regulator_get_hardware_vsel_register(struct regulator *regulato=
r,
            ^
include/linux/regulator/consumer.h:480:12: warning: 'regulator_list_hardwar=
e_vsel' defined but not used [-Wunused-function]
 static int regulator_list_hardware_vsel(struct regulator *regulator,
            ^

And more like that.

Introduced by commit 04eca28cde52 ("regulator: Add helpers for
low-level register access").  Missing "static inline"s ...  I suspect
this is becoming more common due to the lack of "extern"s in our header
files now. :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au


--Sig_/7k69u1LqMXVUBZde=3W.0MM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT1ibHAAoJEMDTa8Ir7ZwVDlgP/2/dvg/va3ag5asoKKdOrlf/
2+uDmO3CR5+cjEzI+80+xeFVAZFjNaTR/Gjh9vHVsRnwWqDQ7Y4523VyLuUre212
M0cFupPyK8P+y92Yc9dsKRoCJV67eyT+I1F+GxgUJV3cRQb578JU1dvDrwQUd6ym
CEm7HEttTYKscRvwKbfeolrvgfjZUkg5xX++onmetUm6egC+KzZDlO3K0lEFdKTm
6g47igsRxfdM7pv3jD1u1SbxtaQVOSiYwfSJTIe9eCpCr+SuR9FR1D7cmjLUb7ib
IpWep5r23kfOlyYb+HbcQGxkwhC72eiJA8ykVzLLSJ5Mn/3r4mABMvTmOuTU+Y+L
d8gYCcnFSUitcM/v8SzGJAUg+JOglYmZwKPmNE7SS5DeeKHqCtSpNSC+8sJSkFhD
21pRSztgEgVY9IZlpuJqcQ/ndtv9ZrJJGgkIr5UzT5eOe23f7If8dl5BhLG5TFxQ
Ff4++68CBiQ7Z70V7lfXZiJXmzkM76clwQwDoMlzTzxQejxdi2wAMd++h0KpcRGm
GNWKI6m23TBYtizP/uWrdfe6rwTtubju9BNxCwMYsIINlxswmsUab72FANXJbe8o
8AjI/4ONm1BvWiNWyF4VqLCB7U1zxUseDWFJqIpwMeBSvlwyd8K+zIrHMtfR3N+p
Lie4h5ursUImIODxoP4U
=JhZo
-----END PGP SIGNATURE-----

--Sig_/7k69u1LqMXVUBZde=3W.0MM--
