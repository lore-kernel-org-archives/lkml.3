Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaIZBzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:55:47 -0400
Received: from ozlabs.org ([103.22.144.67]:57192 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbaIZBzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:55:46 -0400
Date: Fri, 26 Sep 2014 11:55:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Jiancheng Xue <xuejiancheng@huawei.com>, Wei Xu <xuwei5@hisilicon.com>
Subject: linux-next: build failure after merge of the arm-soc tree
Message-ID: <20140926115539.6873630b@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/POjXz5pledPf3.4rRcoCSvW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/POjXz5pledPf3.4rRcoCSvW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the arm-soc tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

Error: arch/arm/boot/dts/hisi-x5hd2.dtsi:374.22-23 syntax error
FATAL ERROR: Unable to parse input tree

There are a series of new commits to this file today and I have no idea
which one caused the problem.

I reverted:

610bd8722ef4	"ARM: dts: hix5hd2: add wdg node"
6868feb6dd97	"ARM: dts: hix5hd2: add gpio node"
420a2d55f046	"ARM: dts: hix5hd2: add sata node"
f16c7fb2f3ff	"ARM: dts: hix5hd2: add usb node"
b196e1ca400d	"ARM: dts: hix5hd2: add mmc node"
de8b6054780e	"ARM: dts: hix5hd2: add gmac node"

which fixed the build problem.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/POjXz5pledPf3.4rRcoCSvW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJMefAAoJEMDTa8Ir7ZwVUDEP/0hBYdLNrUoqm2CwnmmDB1B2
c1F+Rx9LehDEne3LOE3e5WHFOmNuN3Xs7KOeNBSTUfxR5OIK+ovM1cb9BRULHj/H
wL+c58//Hve/FIMdP7ou0s5xtLUOYhWv21rzuvH5TBFG6C3j+0c0OnsKAJgET8ue
qxsvh/6zuTHWwtRhEqMBFBzUJZreVJXJVexE4o7Jmtsz90hDZoeFdv0j3U8iW8wI
akVK5gTzANswe59DerS8aWs+1pgcbOWoS5MM3Sam7LlIEsw5Qtn6cOabF3BBUEAX
fsrWwAxtSh+2wvykEJ6saveEovwy5X35WEchRDo5u8m2xm0ofqRLPosbns7gg86R
rx/FB67rKoP976l67TlFNeqbv/SSy1yYAhKcPa59fTFVKV8GGle++hBmSHAhlO7r
+8wEQErpzg4WwbxKIuNReNpbVh31QxxcQElDjcHTu5OVnz7t5hvvqAbmYqkknz2C
aOzcQxARF0g9TbFt3n6jC8PUJ+MSOWh43jnegy0kxfI6mNspKtF3BMnzL52kUS58
wMr4LFkOGjRgEy56VhCQA4s00KtSulUX5KyMxTC2sAp8aGB5hBvn0glqslN+sXvS
dM0lQfLWBGFRysA3s3NjUbaR/FiMylsRIRxIjM0lsPdkVESvgQmbKiZ1R803oTSs
4cDL5WEfqp41r4r9tpSM
=9Ps4
-----END PGP SIGNATURE-----

--Sig_/POjXz5pledPf3.4rRcoCSvW--
