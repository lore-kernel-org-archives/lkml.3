Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaIHIeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:34:00 -0400
Received: from ozlabs.org ([103.22.144.67]:48288 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbaIHId7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:33:59 -0400
Date: Mon, 8 Sep 2014 18:33:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Zhong <zyw@rock-chips.com>
Subject: linux-next: build failure after merge of the regulator tree
Message-ID: <20140908183350.5a4e357c@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/zoC2oSA/zefwwB98hUQTfbI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zoC2oSA/zefwwB98hUQTfbI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the regulator tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/regulator/rk808-regulator.c:312:18: warning: 'struct rk808_board' d=
eclared inside parameter list
           struct rk808_board *pdata)
                  ^
drivers/regulator/rk808-regulator.c:312:18: warning: its scope is only this=
 definition or declaration, which is probably not what you want
drivers/regulator/rk808-regulator.c: In function 'rk808_regulator_dts':
drivers/regulator/rk808-regulator.c:340:8: error: dereferencing pointer to =
incomplete type
   pdata->rk808_init_data[i] =3D rk808_reg_matches[i].init_data;
        ^
drivers/regulator/rk808-regulator.c:341:8: error: dereferencing pointer to =
incomplete type
   pdata->of_node[i] =3D rk808_reg_matches[i].of_node;
        ^
drivers/regulator/rk808-regulator.c: In function 'rk808_regulator_probe':
drivers/regulator/rk808-regulator.c:359:43: error: dereferencing pointer to=
 incomplete type
   pdata =3D devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
                                           ^
drivers/regulator/rk808-regulator.c:364:8: warning: passing argument 2 of '=
rk808_regulator_dts' from incompatible pointer type
  ret =3D rk808_regulator_dts(client, pdata);
        ^
drivers/regulator/rk808-regulator.c:311:12: note: expected 'struct rk808_bo=
ard *' but argument is of type 'struct rk808_board *'
 static int rk808_regulator_dts(struct i2c_client *client,
            ^
drivers/regulator/rk808-regulator.c:370:19: error: dereferencing pointer to=
 incomplete type
   reg_data =3D pdata->rk808_init_data[i];
                   ^
drivers/regulator/rk808-regulator.c:379:26: error: dereferencing pointer to=
 incomplete type
    config.of_node =3D pdata->of_node[i];
                          ^

Caused by commit 2cd64ae3d57b ("regulator: RK808: Add regulator driver
for RK808").

I have reverted that commit and all the following ones in the regulator
tree that touch this file.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/zoC2oSA/zefwwB98hUQTfbI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDWnzAAoJEMDTa8Ir7ZwV2eAP/2ocNK+Kg3vtAZsx2WNTAMpa
yOnbfRkMITY/HgoRBrHgCzyxny/+F1IRdoV7LSmzS0twOBDs4AwQHG8xMBkaDgrs
9XTH7ztXtIqnP28ff1IZTUCCMuVQ8i5ObrotkL3HZed8Xtmpg/912L23Z3MebNcd
yLwsquIrFOFPS5+qmXQOlDMLoXNeGfhDxDL/Ar4kz+49rERW+ql9PgbNc2t6OEUo
62yLH2ADE8tJ0C9a5AGgH+pFl4pryZNn9Iw4QhP3ftllM/twW+YL0sl94K5xXzfw
rHAXRUrJxAL2D+2IE69ZSQ4Az9Y/307bsCHGcP0oguEFXPmeFl/teOpYC2K7Gb3G
ffRHtZA2B0P6w9xdfR9ExR3wpkxbM792P6yvzNeiDG8GiMIzcwAHEpKHbDWcdWO2
jib/tbynQXhNEfx3e4gHl9bw1biXJ+FMKR7lnPW4rvW+3OPhPijwlmvk2hseJ94K
o9rI8Zco5LPhyConKAycp9QzMyU81P6+1Gr15zP9ivbWSfSIideQ0rVUwWFVfnoG
nq4w77Mwu5YtLvMjtrr1Ch1Ro3rZjwgUbQ4uqN/UuK+C9W7829F9HAU9p10A9vUT
KeGEYXTzYNoyokpOVWJDaOVYa9DYDbntfWR+wUDG6ZnJxgLY5/G7e7kCwoxGoUMG
3YPO/T/z9KT20En74e0W
=X1AE
-----END PGP SIGNATURE-----

--Sig_/zoC2oSA/zefwwB98hUQTfbI--
