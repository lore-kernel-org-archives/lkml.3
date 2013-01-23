Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab3AWE7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:59:00 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37829 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab3AWE67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:58:59 -0500
Date: Wed, 23 Jan 2013 15:58:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the pinctrl tree with the driver-core
 tree
Message-Id: <20130123155852.e8b35c4e85b0c65c4635b422@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Jan_2013_15_58_52_+1100_4BsfJ/wSqIOYQumb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2013_15_58_52_+1100_4BsfJ/wSqIOYQumb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
drivers/pinctrl/pinctrl-nomadik.c between commit 9e0c1fb29a7c ("pinctrl:
Convert to devm_ioremap_resource()") from the driver-core tree and commit
50f690d85e4e ("pinctrl/nomadik: simplify GPIO probe") from the pinctrl
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pinctrl/pinctrl-nomadik.c
index 96e7cfb,b885c09..0000000
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@@ -1350,34 -1351,24 +1351,24 @@@ static int nmk_gpio_probe(struct platfo
  	}
 =20
  	res =3D platform_get_resource(dev, IORESOURCE_MEM, 0);
- 	if (!res) {
- 		ret =3D -ENOENT;
- 		goto out;
- 	}
+ 	if (!res)
+ 		return -ENOENT;
 =20
  	irq =3D platform_get_irq(dev, 0);
- 	if (irq < 0) {
- 		ret =3D irq;
- 		goto out;
- 	}
+ 	if (irq < 0)
+ 		return irq;
 =20
  	secondary_irq =3D platform_get_irq(dev, 1);
- 	if (secondary_irq >=3D 0 && !pdata->get_secondary_status) {
- 		ret =3D -EINVAL;
- 		goto out;
- 	}
+ 	if (secondary_irq >=3D 0 && !pdata->get_secondary_status)
+ 		return -EINVAL;
 =20
 -	base =3D devm_request_and_ioremap(&dev->dev, res);
 -	if (!base)
 -		return -ENOMEM;
 +	base =3D devm_ioremap_resource(&dev->dev, res);
- 	if (IS_ERR(base)) {
- 		ret =3D PTR_ERR(base);
- 		goto out;
- 	}
++	if (IS_ERR(base))
++		return PTR_ERR(base);
 =20
  	clk =3D devm_clk_get(&dev->dev, NULL);
- 	if (IS_ERR(clk)) {
- 		ret =3D PTR_ERR(clk);
- 		goto out;
- 	}
+ 	if (IS_ERR(clk))
+ 		return PTR_ERR(clk);
  	clk_prepare(clk);
 =20
  	nmk_chip =3D devm_kzalloc(&dev->dev, sizeof(*nmk_chip), GFP_KERNEL);

--Signature=_Wed__23_Jan_2013_15_58_52_+1100_4BsfJ/wSqIOYQumb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/24MAAoJEECxmPOUX5FENe8P/3PJ7tp5xnie0gQWxKfOcZHK
b5kL9udQn8G3J1roT2DpdH3QYRhcRIip03wjV3ERpxclQnn8gQZCXxB01T2DQecY
NOFdcFM1EQab8dgqBtSwn8EqgXg5zuF2RE2h+Ovub/m4osHrMv5vRCGunL0zpGNm
gHEuDOVZoefsXRLjXc0IQLC1zE8m0Njv7ffraj0JjpllBHhAkudSiZ8Z0Vob2B99
v3Fnk1Za2nUvPmcbbzW7i6rXuu6gEH4MdEz34eP+aNtWsTHIgL3oaReycjZDC7YN
PEQyDmzb5Xo/xN78XvpGNxM/LxUpLFhP+gc94g+pTeal7cNRnrLI58UanGKQcBeB
D6yJG9LUWcqh+YuCtoT/rrCqkoYnnDpP51t3PHzA+y2TEAY4vHfW3lOpU1cbHHm/
y9LFfDLNn6zK0b57x9uzjZPkMkTdIC6K8ub/QzxMWusxBau6W7QpsvA0hK7hPWVU
VE+ieomRLpATggMho8HH+aViyVOR9aqkxL/F25YUaNO+bmlpVf9ru1US6AgPMMnE
22er3+8cJsn8fsSig39+J+SNQs2yZw1mZOgCsRgfrxPB1I1h9b7lnMytSgNSJB53
gAm916ixKGnN+Q8DDlYSwiznzCklhpg4ii9Tc+xB71axIl2mqtLSCTnrdEJfOcCG
Dum4s14RX3Illmuum8gC
=nNCa
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2013_15_58_52_+1100_4BsfJ/wSqIOYQumb--
