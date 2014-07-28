Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaG1CTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 22:19:10 -0400
Received: from ozlabs.org ([103.22.144.67]:57784 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaG1CTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 22:19:07 -0400
Date: Mon, 28 Jul 2014 12:18:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: linux-next: build failure after merge of the slave-dma tree
Message-ID: <20140728121856.56d0162e@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/vHs8cy=O/ffZSFBj5+xZJWF"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/vHs8cy=O/ffZSFBj5+xZJWF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

After merging the slave-dma tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/dma/sun6i-dma.c: In function 'sun6i_dma_dump_chan_regs':
drivers/dma/sun6i-dma.c:203:2: error: implicit declaration of function '__v=
irt_to_phys' [-Werror=3Dimplicit-function-declaration]
  phys_addr_t reg =3D __virt_to_phys((unsigned long)pchan->base);
  ^

Caused by commit 555859308723 ("dmaengine: sun6i: Add driver for the
Allwinner A31 DMA controller").  Presumably missing an include file.

I have used the slave-dma tree from next-20140725 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/vHs8cy=O/ffZSFBj5+xZJWF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT1bMWAAoJEMDTa8Ir7ZwVTKkP/3tf+YU8dspMs8UGRe513JAc
md3sRfduDAhwTWzim4UnZmf5gCt/VTID6QQpqgVU2Cu38LOUuAfSxRwVuAfBNXef
cxsN9sbQsnVl9A6dEMKAri5k9ZSoJ2uRhJYWePGXbmBL/gPyZ5gA9sSyXeUClG97
2Q8M+LIh9NeL7tJ9af6M3NWUPgiWXubla8yvW8fwt3M3/S57DmbAcO65ITsH+DyB
fknGq0oMrBq5/QspYErEZGkJEKFLPsHGzONmVixPVh2oTC0BYqQVPcj807O3jpzo
/GoARQStbiefpvM7gByiX0VM2tYH8o0Hblfh3yl7UOO5901x/x607eSvMwiR6jS+
U5tDMmylj7rawmin/Ma70dXrx1lU7Nk0FoG4nYCbiMpzm69GuR9MiLwPyBBkNtsi
+KsShzx6KMcmzTgObcQbVBK2R7iwb/jtqvuWx07eT3b8YW+VLzxtujwhAX2zDH2m
2bKkCX9Ttv8ocVq6ENfKuAHSAWZrnzk164emQDi7ErjhZCb/Zkl/W+SDMo0k4G86
7BiBc6+zpmXrMqjIbGNXBRZIIiJRj1K1X4IwE4b7Xx4nLolCVKHLi2UyJyG/vjcZ
bysDiwp0FVXxRA0A21fE7zLojo+7kJjy1YNTACqg3oxSzdkmS0293iZAhWkYkCAJ
mj5s9cYffexp1OveXIEl
=RP8L
-----END PGP SIGNATURE-----

--Sig_/vHs8cy=O/ffZSFBj5+xZJWF--
