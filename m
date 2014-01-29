Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbaA2DcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 22:32:15 -0500
Received: from ozlabs.org ([203.10.76.45]:41959 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbaA2DcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 22:32:14 -0500
Date: Wed, 29 Jan 2014 14:32:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the clk tree
Message-Id: <20140129143203.3856df2abbf5f3c52b444ca5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Jan_2014_14_32_03_+1100_Dyiv0vskT6JAR3OQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Jan_2014_14_32_03_+1100_Dyiv0vskT6JAR3OQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

After merging the clk tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/clk/clk-si5351.c: In function 'si5351_i2c_probe':
drivers/clk/clk-si5351.c:1314:2: error: too many arguments to function 'si5=
351_dt_parse'
  ret =3D si5351_dt_parse(client, variant);
  ^
drivers/clk/clk-si5351.c:1296:12: note: declared here
 static int si5351_dt_parse(struct i2c_client *client)
            ^

Caused by commit 9d43dc7f403d ("clk: si5351: remove variant from
platform_data").

I have used the clk tree from next-20140128 for today.  (Yes, I know that
Linus already took this - I guess I won't have to worry about it
tomorrow.)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__29_Jan_2014_14_32_03_+1100_Dyiv0vskT6JAR3OQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS6HY8AAoJEMDTa8Ir7ZwVokEP/R+NxZbVnnF6RTnxHZJzp5rA
UjoBuOXfejmQhbmh8sc/g61vsN2qYRRpEn/CSmi5AGFTIxdDmbl8946Uq/D1Gxcy
ldzM0e+oNxYbDp7Ht5asyV+6rSP+fHfcPCTci9pU1u1c9JJ1897qhjf1/diiBcsY
5aczkZJCtLdieY/A6zbvUjOimSJTRxfvkYYZDSEgVwGUJLy9nJ/ogVsBorAdcb6i
CRu6CHiRfiT7GiINk9nrpBZoLlyWz6IxB0ceszu0oP5bpaYN7sWyKTiBOpjHA2iT
tbfMUq8Gm8nfoOIPthggoTUE+TDqfw8HUiWv6Ye+thk9DzHS49YHIrV1uXZscntU
ZfovBDUNHgr3Jn922/8JQJ4bdX8IYoq+MX7sx9YYX5AsqY9GOGPFumMc3ATEtMbz
Oa3qbR35cm9G0DYKL8WJKicZ1TbiXCfMNdeYNwF1PYRDceNIPaXJj3DOj1PwQK8y
n0o4ZSEhdoxa9C0kgz8BSRLgZiT2Vvl9seypLbUSfVpJ2AaLa+p4BdLnaD5CGKFP
UP8tsKC+NPZS4qfP5R5Z8fpiL2igVk0ZSCwDQ0y58uqrMbAWglQM27Ze6xsmtl4U
rr36aFXhz/fmL5TgkdTKC7OwzHtYUxNLuRnzGjEi+PWEzn1M39LZ+CnajPf4AKeh
vpMnu2tMLFaq4HdXHQWg
=tsU8
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Jan_2014_14_32_03_+1100_Dyiv0vskT6JAR3OQ--
