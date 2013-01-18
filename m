Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab3ARDbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:31:14 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46361 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3ARDbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:31:12 -0500
Date: Fri, 18 Jan 2013 14:31:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alessandro Rubini <rubini@gnudd.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: linux-next: manual merge of the samsung tree with the slave-dma
 tree
Message-Id: <20130118143110.8555b3708e3b7674c090f93e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_Jan_2013_14_31_10_+1100_NjdGiaT5=BIcnIj9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Jan_2013_14_31_10_+1100_NjdGiaT5=BIcnIj9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/mach-s3c64xx/dma.c between commit 3a95b9fbba89 ("pl080.h: moved
from arm/include/asm/hardware to include/linux/amba/") from the slave-dma
tree and commit f2bfd174bdc0 ("ARM: S3C64XX: make regs-sys.h local") from
the samsung tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s3c64xx/dma.c
index a77f521,ec29b35..0000000
--- a/arch/arm/mach-s3c64xx/dma.c
+++ b/arch/arm/mach-s3c64xx/dma.c
@@@ -29,8 -28,9 +29,7 @@@
  #include <mach/map.h>
  #include <mach/irqs.h>
 =20
- #include <mach/regs-sys.h>
-=20
 -#include <asm/hardware/pl080.h>
 -
+ #include "regs-sys.h"
 =20
  /* dma channel state information */
 =20

--Signature=_Fri__18_Jan_2013_14_31_10_+1100_NjdGiaT5=BIcnIj9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ+MH+AAoJEECxmPOUX5FEyY8QAKFWjrdEqGg7luEK29C7RCU6
oLmn/uVUBPWRU+S1c1SWBbHdTAACgnBtk3re5hcg87zMVSq5Gv0h8iroIrDzX86d
OnuKghWBW5Hz4pJT/6NPeQdJIz8Q0ltMRgUN7wdHJmvZEyAyLka4yguDmrjK8vhe
cW4xSI6ALn2eK3GNeEjRlxcZ3hhnGekoQLafCJ5MXs/4Yq/jqKHNRuQU8ZvG51f7
KSNEnSxV8srMOtERVtGi2802DMl6235He1rSxZTfJmLWzhR3p1tXe24zuNR+NNK6
Wf3hLxZ78PqRZrtKTyxZPQwgRKP4mB5CcHOboiz58/ve7/rvQSZM0eXES4W+0/VZ
/UJsOOis7464u/OmSVIa49QozpoezuyPROewC0CfzqD8IOD03/s+Zi3P+/XYF61/
zbQzIx897/gWJSTjaIfRlax5pUgbOlfCn7jutiHchaecPvMIz6qL4pNAIwOgm5xp
j/RP5EPmFc8+1/aPKPbk9qDNU1qUyR4Dd5Z05/cnr7B6bnDvCbdtLLM/kblAVu1Y
HPsrj8Bo1Zg1N53AR7fUh4jGAKjloRoOFDwY5siNpXtb9QtuvLLrp92iOf4VvOW2
zFleHJdOFyA+SQokmsd26tlGUMveZCo8fG9oOug4s+bRXvODxSuIDx52eug2fZYV
ruKP1zR4R/JOpktgrfxK
=2klg
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Jan_2013_14_31_10_+1100_NjdGiaT5=BIcnIj9--
