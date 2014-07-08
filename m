Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaGHDLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 23:11:08 -0400
Received: from ozlabs.org ([103.22.144.67]:43067 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbaGHDLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 23:11:06 -0400
Date: Tue, 8 Jul 2014 13:10:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: linux-next: build failure after merge of the regulator tree
Message-ID: <20140708131057.6bad8c66@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/gH5mkncaHJkD.eCo.JzjLWS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gH5mkncaHJkD.eCo.JzjLWS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the regulator tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/regulator/act8865-regulator.c: In function 'act8865_pmic_probe':
drivers/regulator/act8865-regulator.c:291:13: error: 'act8846_matches' unde=
clared (first use in this function)
   matches =3D act8846_matches;
             ^
drivers/regulator/act8865-regulator.c:291:13: note: each undeclared identif=
ier is reported only once for each function it appears in
drivers/regulator/act8865-regulator.c:296:13: error: 'act8865_matches' unde=
clared (first use in this function)
   matches =3D act8865_matches;
             ^
drivers/regulator/act8865-regulator.c:311:9: error: too many arguments to f=
unction 'act8865_pdata_from_dt'
   ret =3D act8865_pdata_from_dt(dev, of_node, &pdata_of, matches,
         ^
drivers/regulator/act8865-regulator.c:239:19: note: declared here
 static inline int act8865_pdata_from_dt(struct device *dev,
                   ^

Caused by commit 7160912a8c55 ("regulator: act8865: add support for
act8846").

I have used the regulator tree from next-20140707 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/gH5mkncaHJkD.eCo.JzjLWS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTu2FGAAoJEMDTa8Ir7ZwVFo4P/1ekf0y7tzl2l4jmeo+yEXDE
DVCkLTxO5w3KXrWBkU8VgoyCgjh5HJciFOTnXtCdxLhiCO3ZAVNwZ/MfYmre6Ocf
eITFCALWv5xCpNxA2lnm106ot7OAEXsZwMI52j6s4oDYQVHN2f6/c18/kn0G3NR3
OYXO3OAqeHzIyHgPIFXYSU7XbHuMiRjcHi/bEDNK6qkHzVbLR439CXorMVkhrxmb
D7FIfqfcAhzkqvsojGNXr0Vmserauuur/1itbJI6p5RL6Z8nDmMo6v/ol5zN2L7b
AxPRso5id/9cRS4AwD2+ekaHZWf+NV6QrmxxET8OJGSlmkNY1q4ExBIiEcx/yj8V
hFOH0OhVQY9mLrEzPLl5MwZ6ckUJojbZac8/jOyRTbbzQBmb2BvDhmvkgwMh1vJB
d3h5gailfGxW+rVKUNiM/405ag0is/qQLK9PtmAwfOEdN3ABoy9QdJ0xteaIMzTH
LzPiycFMJBbdfIZI+IyyrmqUE7O3lG8/3jMZNl+eu0iuZfhyNhboAGyCWHI2s9/l
kdLG3R+yc122554d1z6O96nsNixUYevIO2JI6oV8OY4tca4hZHN+6wg1B8eAord2
2vBUa7VvzXQXcAOrvkS2XKbMBJpdCshFdPraY04aJljPC4qFNpV224/nVL9tYuJP
/+fdAX/HkYL1Q0KpUex2
=2q9e
-----END PGP SIGNATURE-----

--Sig_/gH5mkncaHJkD.eCo.JzjLWS--
