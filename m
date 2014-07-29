Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaG2Hig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 03:38:36 -0400
Received: from ozlabs.org ([103.22.144.67]:58553 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaG2Hif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 03:38:35 -0400
Date: Tue, 29 Jul 2014 17:38:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>
Subject: linux-next: manual merge of the char-misc tree with the slave-dma
 tree
Message-ID: <20140729173824.51e94ce2@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/EhXV6tAerJvRiv_e7EAuYv3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/EhXV6tAerJvRiv_e7EAuYv3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got a conflict in
drivers/dma/Makefile between commit 555859308723 ("dmaengine: sun6i:
Add driver for the Allwinner A31 DMA controller") from the slave-dma tree a=
nd
commit 95b4ecbf759a ("dma: MIC X100 DMA Driver") from the char-misc
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/dma/Makefile
index d08bd966da13,bd9e7fa928bd..000000000000
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@@ -47,4 -47,4 +47,5 @@@ obj-$(CONFIG_MOXART_DMA) +=3D moxart-dma.
  obj-$(CONFIG_FSL_EDMA) +=3D fsl-edma.o
  obj-$(CONFIG_QCOM_BAM_DMA) +=3D qcom_bam_dma.o
  obj-y +=3D xilinx/
 +obj-$(CONFIG_DMA_SUN6I) +=3D sun6i-dma.o
+ obj-$(CONFIG_INTEL_MIC_X100_DMA) +=3D mic_x100_dma.o

--Sig_/EhXV6tAerJvRiv_e7EAuYv3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT1091AAoJEMDTa8Ir7ZwVQ9EP/28vlwJTtNIDVjug8/YPgl1I
NVm5Pgrgy1TgbwqHa2LWHumhDcDWP4TW5THchZbmqiKt9DTkJxZ1KvduP2XT9kyn
fXzGiH8piUG6AGC87cPvzfk05Toh028b1SigPFhbSsq1H3se67jnSvVeEAtXLP6O
hgGecrqMfm9wPNDeu1zXmeTJ2PMdl/oqkRDyuiVoZ8Uo0ScFsMYLWb7ca24hIqFY
ZmTo52RAEWGKiT+tIr/uivJKuSY9TosmENTOsFqULG765iJTXqZy8nPWKty4XGE4
VZKoS72rVxPvwkXQoHIt3e1e2yzZMD7Y22fUrmOuSj2gLXONXXPhNCZ1cRtA/9YY
r9KwzpgFqWHWSThsxcg528LrepnYBatac1bVvuwAwxxGqfj3MS8LjKbv9RUdyNvg
dWTLw+osGA6NKSXtcx3QkzxwS18t9N4vI/Jwc9OGb20aif4qNRnG/rNj13ER6/HY
7Ayk+XQFly8DAmyAnZuYYGl4Dxij9VyrUTBFjBxY6q/1rBcprK8KmBPVEUPvcHQu
hazclYNMo8S3rrs3Nq93Cz0k4g6ItVIJYg7mVvMIO6i93gKPVI1SA0/BAiGItmXF
u5DFUqrjvZyKezgT+B9YCoEfqYL1AUxDDtKE1behWdij+nwg9LBzOCLnHp2ELjIQ
4KIOZp0lt8f7f8NM5kkx
=2LIc
-----END PGP SIGNATURE-----

--Sig_/EhXV6tAerJvRiv_e7EAuYv3--
