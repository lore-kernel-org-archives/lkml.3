Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3J1Hrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 03:47:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34453 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab3J1Hrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 03:47:49 -0400
Date: Mon, 28 Oct 2013 18:47:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: linux-next: manual merge of the security tree with the  tree
Message-Id: <20131028184740.ee58871cc5bd149901cbdf03@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Oct_2013_18_47_40_+1100_yz/Fz+OO.245Eh3l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Oct_2013_18_47_40_+1100_yz/Fz+OO.245Eh3l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the security tree got a conflict in
crypto/Makefile between commit a62b01cd6cc1 ("crypto: create generic
version of ablk_helper") from the crypto tree and commit ee08997fee16
("crypto: provide single place for hash algo information") from the
security tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc crypto/Makefile
index e0b7cf4e18b6,b3a7e807e08b..000000000000
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@@ -109,4 -104,4 +109,5 @@@ obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER)=20
  obj-$(CONFIG_XOR_BLOCKS) +=3D xor.o
  obj-$(CONFIG_ASYNC_CORE) +=3D async_tx/
  obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) +=3D asymmetric_keys/
 +obj-$(CONFIG_CRYPTO_ABLK_HELPER) +=3D ablk_helper.o
+ obj-$(CONFIG_CRYPTO_HASH_INFO) +=3D hash_info.o

--Signature=_Mon__28_Oct_2013_18_47_40_+1100_yz/Fz+OO.245Eh3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSbhahAAoJEMDTa8Ir7ZwVtXUQAI0S/ZmU+E9f9Nyqhyq+nuG/
gzSZVGixO6GkqteRQekOOBFnb4kx4oBHp/20D5jRu0/tslnAsB7yz9k7G85CpKm0
pB7V0DjY+0P/7oBdB6fVSyTK66gARgqc3bXhNUiGuFT8RhAujEv31w4kfHzjrrVq
UhCWosVev7FGjqey/O9Kw0uHVcT6vNzZoPRc3t+utauf9xY3vrdtk15rjhOANMCC
Y2Bvps69CC+ayBu6dZHZdnmvGZ3MlxBoxbEjIyoM80bk8Altd9BXEGfs4j8eH6PJ
BFFiL3tP/94Gsuw/qVTvMXIRwyT2sACT2kQ/Nl15+IbhwE/8WgmpjHo9io/HjDgA
viGQNhLVf2siLQqXF+zgvFZ0cvjIiojUYfowFSudhNROU3PZimiNl6Z82qtHQPvZ
yMgLEwz5/2DzccoJluD+I259iZxtI+hsbmpYwTS4dwfgdwepNLYzXopjq4GE4SaZ
cjpR1FwF1ZnQZj/GuJfRAEAOUwb7goy61JpQdpQvvpQn6LmnRPf9RnlfP+2DOrjS
RLBHGHSWYgB/oLsTXyf4/adARwLIF/Lq9SyVP1ifa7Q2GezjM1ezx2SzEhgSICkN
bmBkPCxgGNv9XrBncKCYHFU0rWJmQElAXowiakhuLjPSUzRJHykkgt/kEPjQbwzS
8vP/2zhHgu3aTTU2zfRE
=sQdB
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Oct_2013_18_47_40_+1100_yz/Fz+OO.245Eh3l--
