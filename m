Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaAFHDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:03:18 -0500
Received: from ozlabs.org ([203.10.76.45]:42727 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbaAFHDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:03:16 -0500
Date: Mon, 6 Jan 2014 18:03:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>
Subject: linux-next: build failure after merge of the spi tree
Message-Id: <20140106180305.2839a467466f52f97ac68b93@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Jan_2014_18_03_05_+1100_wSRUuS1DcmxyRyJl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jan_2014_18_03_05_+1100_wSRUuS1DcmxyRyJl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

After merging the spi tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/spi/spi-dw-pci.c: In function 'spi_pci_probe':
drivers/spi/spi-dw-pci.c:50:29: error: 'dev' undeclared (first use in this =
function)
  dwpci =3D devm_kzalloc(&pdev-dev, sizeof(struct dw_spi_pci), GFP_KERNEL);
                             ^

Caused by commit 04f421e7b0b1 ("spi: dw: use managed resources").

I have used the spi tree from next-20131224 for today (since the above
commit does not revert cleanly).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__6_Jan_2014_18_03_05_+1100_wSRUuS1DcmxyRyJl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSylUtAAoJEMDTa8Ir7ZwVbVEP/3p8LJwB/AN0dqoKSPdwmg+9
5kMkT3JqdVSmfMyAh760B+RNDkBNOZpSeFOaQR5b3OyrrBkAm9Gf1f5Pkcy6vmb7
pjXUGrypJgS2pl6lXvxL0piWi8YsTUCUmf5B6qfMmQ1k/6ZHGKJW5z3I2WxzNhjt
nELACP1WnDA8HAh/93hqNVbllUUgGVyHZeMBQ6G1wIploBBYrcMC/6H3DNiYCFgN
z/oqbuuxMyJDF4FCa0vmI8hZQFstqa4IJbrX/3GqJHrqvP6JfIlk+jDQi9MV1kV6
Lt/WPT2FPQDkWpWtW14VbYAmweZ1VidXZJPE0N3zBbPiWTOxRTpoTR3DALzaGsRb
Th3Gy6sNN0K1njk4A6c7NI7pBoIxBem42dbgcyVWSRKVftseA+l2e/1y++AtNefh
M1QcMSBIRpweOu6W2mz8RqBA0BJA/e0ILUqmMz/j5x5xDcHLfCgQR6QyEW7Qvept
AVPES/j/4HTltH9H/yecVH9cR8lJ9WXDW8ASFpZoDnz7vemf5amFjfz7PpnHfozp
9kZvz0pfMnGBSAYB2Y1/qb6RAz7sC7ndVVbLXUosuRt20/5vlG0m8DbVYMGyGiza
dtpxqgSOZvabBc9UoUEhAzJBne5xd73CBWZWyETAgsDg0Rdgw9sv0KP2zxZr/xys
xRvahMV7GUdSFQP8UCcG
=VxAT
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jan_2014_18_03_05_+1100_wSRUuS1DcmxyRyJl--
