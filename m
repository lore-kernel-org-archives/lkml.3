Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaBZBqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:46:44 -0500
Received: from ozlabs.org ([203.10.76.45]:36670 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaBZBqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:46:42 -0500
Date: Wed, 26 Feb 2014 12:46:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>
Subject: linux-next: manual merge of the mvebu tree with the arm-soc tree
Message-Id: <20140226124635.46eb18b096b7835e28e62d3e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Feb_2014_12_46_35_+1100_6XCAFRunFs/MK/gk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Feb_2014_12_46_35_+1100_6XCAFRunFs/MK/gk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got a conflict in
arch/arm/boot/dts/Makefile between commit 8fc1b0f87d9f ("ARM: qcom: Split
Qualcomm support into legacy and multiplatform") from the arm-soc tree
and commit a02dd0271d01 ("ARM: mvebu: select dtbs from MACH_ARMADA_*")
from the mvebu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/Makefile
index cf8bb9f05c94,01f9ceb450ca..000000000000
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@@ -123,9 -138,16 +139,13 @@@ kirkwood :=3D=20
  	kirkwood-ts219-6282.dtb \
  	kirkwood-ts419-6281.dtb \
  	kirkwood-ts419-6282.dtb
+ dtb-$(CONFIG_ARCH_KIRKWOOD) +=3D $(kirkwood)
+ dtb-$(CONFIG_MACH_KIRKWOOD) +=3D $(kirkwood)
+ dtb-$(CONFIG_ARCH_LPC32XX) +=3D ea3250.dtb phy3250.dtb
  dtb-$(CONFIG_ARCH_MARCO) +=3D marco-evb.dtb
  dtb-$(CONFIG_ARCH_MOXART) +=3D moxart-uc7112lx.dtb
- dtb-$(CONFIG_ARCH_MVEBU) +=3D armada-370-db.dtb \
 -dtb-$(CONFIG_ARCH_MSM) +=3D qcom-msm8660-surf.dtb \
 -	qcom-msm8960-cdp.dtb \
 -	qcom-apq8074-dragonboard.dtb
+ dtb-$(CONFIG_MACH_ARMADA_370) +=3D \
+ 	armada-370-db.dtb \
  	armada-370-mirabox.dtb \
  	armada-370-netgear-rn102.dtb \
  	armada-370-netgear-rn104.dtb \

--Signature=_Wed__26_Feb_2014_12_46_35_+1100_6XCAFRunFs/MK/gk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDUeAAAoJEMDTa8Ir7ZwVSz8P/1pDATgA62SPFUtqE4hHafpb
lCxCwEpZRRBnYWaEqi76jKZwkDYoK/gvRDaLza7a4FUPYtVxVzWjcKqUUJ8sSulL
fNR05inUAAjFfW9aL4TV5g/Qzcth+tw9HZOfcjFbBHRAW90wyBK104cuPiD4Rk3o
j25oFaN2UpDdlfbtMQnFbxSbfXyVpwsqTv9esLwJdap6UuESMGL4LmosJsRgBjz1
IsJhRpR+jFJUK616m8I1CM8Vw5dxefr0naaAsFyB1i9jjv53mh5BnH08kHHqrqew
hNSok98cFDpgql3RYrLOy+bn8gtG9ayf76D1fxFUVCqclZeJ8bFDWeS+1vkJuTtC
Eg4BH1gmMUvBlQVPIAlmiTxnhNgB/YRQEnGN0E03sQfc6Q+7i2noLXe2idn0IMg+
65/9aM9s3n5QGVEp4aBzH32fEP3EJcGh5FzqRiT8t5IEFwEzcmrcxsfZFPCdAtOi
xtgSjiaWfGWhutneWR1lG/ro3+x0rCXAbHe601PNJafFtrDL14P8M4nkALkWJ75i
kGD6PE8blb2xouMgevnFoixpJkhRYtSqSXEK38KVzEo7QheluaQIi4fDrQgHpRE5
/brNrBOrP4ntNVWC67oVhldLvPG1h26zxjFgJGOYq97/54cZipHNfAMiHxYUWNLc
duHv9q6ka2lkpZlN5Wmb
=P8T7
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Feb_2014_12_46_35_+1100_6XCAFRunFs/MK/gk--
