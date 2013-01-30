Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3A3OsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:48:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41236 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab3A3OsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:48:12 -0500
Date: Thu, 31 Jan 2013 01:48:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-Id: <20130131014801.09c81e1826a2fb234de85550@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_Jan_2013_01_48_01_+1100_N7=F5Od0N6S7fxsV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Jan_2013_01_48_01_+1100_N7=F5Od0N6S7fxsV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
drivers/gpio/gpio-samsung.c between commits f69254328793 ("ARM: dts: Fix
compatible value of pinctrl module on EXYNOS5440") and b533c8685b16
("ARM: dts: fix compatible value for exynos pinctrl") from the arm-soc
tree and commit bda7f6d4e198 ("gpio: samsung: skip gpiolib registration
if pinctrl support is enabled for exynos5250") from the samsung tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/gpio-samsung.c
index b2016ed,0d46db6..0000000
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@@ -3023,9 -3023,9 +3022,10 @@@ static __init int samsung_gpiolib_init(
  	*/
  	struct device_node *pctrl_np;
  	static const struct of_device_id exynos_pinctrl_ids[] =3D {
 -		{ .compatible =3D "samsung,pinctrl-exynos4210", },
 -		{ .compatible =3D "samsung,pinctrl-exynos4x12", },
 -		{ .compatible =3D "samsung,pinctrl-exynos5250", },
 +		{ .compatible =3D "samsung,exynos4210-pinctrl", },
 +		{ .compatible =3D "samsung,exynos4x12-pinctrl", },
++		{ .compatible =3D "samsung,exynos5250-pinctrl", },
 +		{ .compatible =3D "samsung,exynos5440-pinctrl", },
  	};
  	for_each_matching_node(pctrl_np, exynos_pinctrl_ids)
  		if (pctrl_np && of_device_is_available(pctrl_np))

--Signature=_Thu__31_Jan_2013_01_48_01_+1100_N7=F5Od0N6S7fxsV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRCTKhAAoJEECxmPOUX5FEF4kP/Rxq6WCtEf7StTEzbLJtm62o
qN4tsmjKIqhb2G+DsS7QY3DwR1qRo0/fmKCOu6td2gkX1iiTeKSeu2LN1a5aA3NM
7CjFU/TGkIWiryurn9bdq2KP27AzLw61KbqZjeYzLdpzvdQTtPJKXid2nZtWK2bh
IBWSEhUfCnG+iz0A87V7DDkVu8oXgTNSa+QJ8qcfKlrN+ZcNNTiz8Pu26l2Jn8Jc
VtoPHEtRTqzjCixxjyrsyqeWGXEg7nkjxgj2mSvmcN555c1i0r5SJwqgOzae/bJW
56RHVSo3XPA88/UE2DfiQUrGWFjfLJenMeLKiSKsMxq48CHUlthQ4/M53P+AFdvs
2anCoAc1snkcxHpJ3+1Ud82a1laK1YtCCjS2MG+4AqevxVmOjuiSpwdmliWu7UP6
1I7JccxtGkXoIm0ZwHy3OTq75j8Q3XsJH3ZTXV7RJXLewJ1ZqM4IVAotgynkl1W9
iAdms2oHyi/R/sjOWapyWiNalUXEehpeAgNazQfNlzwwoU6VsNpJK9LvSPJoFrfx
ya+KV3aXvy746/miUIlvXU31S9pnNKE0Tr18h/0o3JAtVzZ7o0s7sHQiyLYUMqEJ
00Rn1EFllJ6TJc0IBVHnw0tiqPcc5DDqLIycNsV2t6w/+fN9OsJb9e7Es3RIo0CF
bICxYmOAYYa5PwoTTIpH
=8CTF
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Jan_2013_01_48_01_+1100_N7=F5Od0N6S7fxsV--
