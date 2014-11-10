Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaKJA66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 19:58:58 -0500
Received: from ozlabs.org ([103.22.144.67]:37924 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbaKJA65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 19:58:57 -0500
Date: Mon, 10 Nov 2014 11:58:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: linux-next: build failure after merge of the slave-dma tree
Message-ID: <20141110115846.390ce45e@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/k._mfmUA58myoFoih/mBawS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/k._mfmUA58myoFoih/mBawS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

After merging the slave-dma tree, today's linux-next build (x86_64 allmodco=
nfig)
failed like this:

drivers/dma/at_xdmac.c: In function 'at_xdmac_off':
drivers/dma/at_xdmac.c:317:2: error: implicit declaration of function 'writ=
el_relaxed' [-Werror=3Dimplicit-function-declaration]
  at_xdmac_write(atxdmac, AT_XDMAC_GD, -1L);
  ^

Caused by commit e1f7c9eee707 ("dmaengine: at_xdmac: creation of the
atmel eXtended DMA Controller driver").

Also, lots of warnings like:

drivers/dma/at_xdmac.c: In function 'at_xdmac_prep_slave_sg':
include/linux/dynamic_debug.h:64:16: warning: format '%x' expects argument =
of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=3D]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:84:2: note: in expansion of macro 'DEFINE_DYN=
AMIC_DEBUG_METADATA'
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/device.h:1107:2: note: in expansion of macro 'dynamic_dev_dbg'
  dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
  ^
drivers/dma/at_xdmac.c:621:3: note: in expansion of macro 'dev_dbg'
   dev_dbg(chan2dev(chan),
   ^

I have used the slave-dma tree from next-20141106 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/k._mfmUA58myoFoih/mBawS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYA3LAAoJEMDTa8Ir7ZwVaF0P/1v2laNIhF78Ni+GBsa2ymh+
LYhUL85NX9PXJi+9MjAyC/+ibs1U6l3YefOmApUx9e3Myw4UsYpQATvLNlKPUDo7
rlaU/VlsHMbJ3qANzIzIToUdpI3GKYxCpG9cscyg0HAaT1Arz//Zu6rMcUZz4R77
YxqLinwMQfq9/Pkeb0/jaVtwqtVd4BEOp6SJmBJCt5DEOvgzMDCodlJO80oshUSz
nFf+Yj7SUhaakXRlyzLByltxZeryr87LPVtQnBQa0rD1wSZBFdqDsR8tB5MgBYw9
wAtRmA/U4Fm/dRcSfmRE4EuwjZCCLQX/nJ5MumYPj504xFCFCpbtmdM0otJY/pBq
buDVqSxuSEO/NC5KXdDnDyAhavEfqAJJjJ0gpGqyn0e1mLQJyPYXh5DzmUTiYgMF
11tGcNNGnh9daS+yKL0uKUXKLZ2lXIl2cPmhH/N2ZwjtTcg49gHl02L5I/WYGvI/
cqvL5eBIvhDk+jf5JexECZf5GClH3ZM03aS8/k9zXD45ZlbRarxbaNmmczY13XW4
Gk2BTiLxiU2dkGhJXM4LaVLYpwB9i4e3MT4Rhkxhz2qDf+igSNsLB0YUADeDQyAI
FTgvxTFjulswYu7OyjV8sl/1wf0b4JLIFaqm5gZPrnFQmKih6YZ0vJUWYk1XZS7X
Wzs0L8Z6ojWBQvKtxNVV
=TD4U
-----END PGP SIGNATURE-----

--Sig_/k._mfmUA58myoFoih/mBawS--
