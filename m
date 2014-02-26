Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaBZHPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 02:15:30 -0500
Received: from ozlabs.org ([203.10.76.45]:59659 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbaBZHP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 02:15:27 -0500
Date: Wed, 26 Feb 2014 18:15:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: linux-next: manual merge of the clk tree with the keystone tree
Message-Id: <20140226181521.e8cecdff21d892ea1f037bff@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Feb_2014_18_15_21_+1100_+0Il8Pt7isG4sZzw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Feb_2014_18_15_21_+1100_+0Il8Pt7isG4sZzw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
arch/arm/boot/dts/keystone-clocks.dtsi between commit 0cfc9ccec2a8 ("ARM:
dts: keystone: preparatory patch to support K2L and K2E SOCs") from the
keystone tree and commit 565bbdcd3b91 ("ARM: keystone: dts: fix clkvcp3
control register address") from the clk tree.

I fixed it up (by adding the following merge fix patch) and can carry the
fix as necessary (no action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 26 Feb 2014 18:12:55 +1100
Subject: [PATCH] ARM: keystone: dts: fix for code movement

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/boot/dts/k2hk-clocks.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/k2hk-clocks.dtsi b/arch/arm/boot/dts/k2hk-cl=
ocks.dtsi
index 4eed84feb761..a71aa2996321 100644
--- a/arch/arm/boot/dts/k2hk-clocks.dtsi
+++ b/arch/arm/boot/dts/k2hk-clocks.dtsi
@@ -339,7 +339,7 @@ clocks {
 		compatible =3D "ti,keystone,psc-clock";
 		clocks =3D <&chipclk13>;
 		clock-output-names =3D "vcp-3";
-		reg =3D <0x0235000a8 0xb00>, <0x02350060 0x400>;
+		reg =3D <0x023500a8 0xb00>, <0x02350060 0x400>;
 		reg-names =3D "control", "domain";
 		domain-id =3D <24>;
 	};
--=20
1.9.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__26_Feb_2014_18_15_21_+1100_+0Il8Pt7isG4sZzw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDZSOAAoJEMDTa8Ir7ZwVWN0P/0bD5kprh+dJ0AasN8wPP+s2
Rdof+q4eTJDuHmKAuvT9qszMtsr7vLSQCPhGzbjN6/2b0bHePvZ0GsBrW9kGQvnp
MP5LypxYjFckV7FvzUgMWVvMMvnlLmvCRybWSS6jXAovu+K+J3rTqkE8FziapHwF
dkfGgENpNtv4D6NOMGa8CUg1f5Z9euns1aZ7rtN9CO34ptLy5fZio+Xlyz3SNf8i
2ViJgFPanKQJRAwkWqUToXl/9uDpdezv0ahzgU6HNRtpdSsJQBWVweTlJchhdGaM
agDMsV3VbkWaglEbJaDh/gBLvBLFwqpq2m2Tqxh3qWOJczuBcc6R/s/aI2YBTlyh
dAVbHypQkSFFEJ5rIXrrUOTU6mqnc7Sc/DI/HP/uJBnzRBLJTTFp3FbznuMCnLXR
cbxB0y8NbkepHofX4nNQ4g+Nu51HU+ecybVZ1syWCVA75+jCvhzkznzVAMZCHA2B
hkP7EtNwsphgJcMroYAQalQiQtYsDf2RKe/JQiRET0XjFt7qeORzRe+hMQwz5Zqt
sBC7cPoMCNfZWrPMfJy6rZi12Z7vJ3p03YdYi2oky5LLCYGJFaYMZdT5N3lryUu0
gdsas+GCBiWN80mjyuwsN2PmlqUEtswL2idkeAt1BRCcebcDs4bpEUmflTC40ks7
ALsQhYSDSdDSYAJbEgYa
=Gplr
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Feb_2014_18_15_21_+1100_+0Il8Pt7isG4sZzw--
