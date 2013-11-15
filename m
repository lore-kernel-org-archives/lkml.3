Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab3KOB4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 20:56:25 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52924 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab3KOB4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 20:56:15 -0500
Date: Fri, 15 Nov 2013 12:56:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>
Subject: linux-next: manual merge of the dmaengine tree with the slave-dma
 tree
Message-Id: <20131115125604.a12f24a58bcbf91cc26cc20e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Nov_2013_12_56_04_+1100_5hfUh=U8=qyGJA_g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Nov_2013_12_56_04_+1100_5hfUh=U8=qyGJA_g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

Today's linux-next merge of the dmaengine tree got a conflict in
drivers/dma/dmatest.c between commit 19e9f99f273b ("dmaengine: dmatest:
use DMA_COMPLETE for dma completion status") from the slave-dma tree and
commit 872f05c6e9a3 ("dmatest: replace stored results mechanism, with
uniform messages") from the dmaengine tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/dma/dmatest.c
index 59e287f56dfc,329b7cf02f8e..000000000000
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@@ -735,17 -633,17 +633,17 @@@ static int dmatest_func(void *data
  			 * free it this time?" dancing.  For now, just
  			 * leave it dangling.
  			 */
- 			thread_result_add(info, result, DMATEST_ET_TIMEOUT,
- 					  total_tests, src_off, dst_off,
- 					  len, 0);
+ 			dmaengine_unmap_put(um);
+ 			result("test timed out", total_tests, src_off, dst_off,
+ 			       len, 0);
  			failed_tests++;
  			continue;
 -		} else if (status !=3D DMA_SUCCESS) {
 +		} else if (status !=3D DMA_COMPLETE) {
- 			enum dmatest_error_type type =3D (status =3D=3D DMA_ERROR) ?
- 				DMATEST_ET_DMA_ERROR : DMATEST_ET_DMA_IN_PROGRESS;
- 			thread_result_add(info, result, type,
- 					  total_tests, src_off, dst_off,
- 					  len, status);
+ 			dmaengine_unmap_put(um);
+ 			result(status =3D=3D DMA_ERROR ?
+ 			       "completion error status" :
+ 			       "completion busy status", total_tests, src_off,
+ 			       dst_off, len, ret);
  			failed_tests++;
  			continue;
  		}

--Signature=_Fri__15_Nov_2013_12_56_04_+1100_5hfUh=U8=qyGJA_g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJShX85AAoJEMDTa8Ir7ZwVtJ8P/2PSXyCg3s8LenKqGaLz+rfJ
LXTJodkSgRq4MpECtr0sYou9E6H7ftPO6UNqH6kq6m/Za3Yw1gbqoG+i2dzMG4uE
ZSPR4ox1v/l4/h1Mdi6e12X7Tinnb9n9P8/4CF/cpk3KdgcSEkw3N43JchgAFnj9
B7GcbtKI7MBq3xPCoFVhdzf0sgavMzJB9/BE895pjCW+uyTotKwcO0Fc5iJ40kzG
fnL/G6PBIrmVHeAhc6PbtwhRr+uO8//ZaR+mE5gC5SAoWRg/xQ4aOuw6mwsfg63f
DmF7NGzOpIg60SE2qFvZia8OrJUergsZl9gr7CacEumUgtmxRNO7qw4trAQ76zoR
Yl4MMNu6fPiN2MbS9CNUKS+TTNZKLQZKe78yi0L2Ncumy2G4p3gXDUImSpszJqbr
vzgXPfzAksr2OYKL6nOMoFAvRil9L1MHPWPHFAkZvDrjlouSY+bdlZm/cLhQnjtG
q1MvBw2okPUbEhO/8OMNuYur8WcOHOy6RJZ4H0ku0kDyMXU7mB/0DycAwemDlYlT
ZIJzw5hs3rG9059EpjJxm6awu3zWcXn03mr8ZvXYKkNcItbrj3dbWJ4vtl/MKX8c
yArXwDb+8ezsXApPCg5TfEvsNsobFxGb7rguf3fTrHFFFCQ75OvhJX6w5yBmADe9
X9VUK020G67LP557SRo7
=s+aE
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Nov_2013_12_56_04_+1100_5hfUh=U8=qyGJA_g--
