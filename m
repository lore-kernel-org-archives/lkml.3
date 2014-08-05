Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbaHEG2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 02:28:55 -0400
Received: from ozlabs.org ([103.22.144.67]:48712 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbaHEG2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 02:28:53 -0400
Date: Tue, 5 Aug 2014 16:28:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: linux-next: manual merge of the char-misc tree with the slave-dma
 tree
Message-ID: <20140805162843.054e1383@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5JscFLzfWH7fGNAnF908wen"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5JscFLzfWH7fGNAnF908wen
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got a conflict in
drivers/dma/Makefile between commit b45b262cefd5 ("dmaengine: add a
driver for AMBA AXI NBPF DMAC IP cores") from the slave-dma tree and
commit 95b4ecbf759a ("dma: MIC X100 DMA Driver") from the char-misc
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/dma/Makefile
index f2b831a994cf,bd9e7fa928bd..000000000000
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@@ -47,5 -47,4 +47,6 @@@ obj-$(CONFIG_MOXART_DMA) +=3D moxart-dma.
  obj-$(CONFIG_FSL_EDMA) +=3D fsl-edma.o
  obj-$(CONFIG_QCOM_BAM_DMA) +=3D qcom_bam_dma.o
  obj-y +=3D xilinx/
 +obj-$(CONFIG_NBPFAXI_DMA) +=3D nbpfaxi.o
 +obj-$(CONFIG_DMA_SUN6I) +=3D sun6i-dma.o
+ obj-$(CONFIG_INTEL_MIC_X100_DMA) +=3D mic_x100_dma.o

--Sig_/5JscFLzfWH7fGNAnF908wen
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT4HmhAAoJEMDTa8Ir7ZwVlmwP/iyA/jqZDrpmsUyvg4Qp9Sk4
RFCC6oxceeXaxDxKfRXfeNytRBphBlSv7AxhMPVlkUGJFdQ1aEIyHBRl2hvSk4r5
HwuzbHSL3XPDXkxWaiGtKw0yHucEc5JsAsCVt8NC6iGtWQ2sUuzAHm7HxRdgaDtd
uWwa0lv6dVe9s5VSl1Trr2tSLAGkhfRPObF2o0e8tmK17p8WVtWck4TxChp/Z+j9
joiX5/n1W0HGk7dnedqJG2rZzMF5+7apx1FgEqaClF0I1tHT/0ZG4kZnq85BXd/O
FNYgZDa/YLj8v5nCWOUPpF8ZAJWGJ/mCtZtpOqrIO+wyb+QpCzAMUvj14o+jzZ0+
Qg9J/IW3rEbOjWhTk8mIUc0zuAcd8y2Q/eLSE+PojCq2ds5hE4N2Day32ohF8TES
k5IBfDf/AMAgFvK8jf5wY8uq6W43kjra+whLp4yZDmRcByqVH7e/vpqY2PhKYpsp
e42bDt4xMX9yJeXOEl21WJHrxOH0Mc4UOb9L+6lEaT2prVdWi373UvELHrfv+M+2
HLSp5/dckF5Zp6ns/RcqpVirw3hx4XJ3bI7o+qdRSs9H4pcnt8R3dWSAzurOv04X
+KBHI/xSYungthbFKpXqhAhrROno2e3XBFy5GirKU1e4r2ufOy6zzcaXYqDwGo7I
FHotVOPcKSrczUJBIveF
=T7rS
-----END PGP SIGNATURE-----

--Sig_/5JscFLzfWH7fGNAnF908wen--
