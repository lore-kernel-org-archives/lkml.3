Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935757Ab3FUHde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:33:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55793 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933901Ab3FUHdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:33:32 -0400
Date: Fri, 21 Jun 2013 17:33:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jamie Iles <jamie@jamieiles.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Robin Holt <holt@sgi.com>
Subject: linux-next: manual merge of the akpm tree with the arm-soc tree
Message-Id: <20130621173326.42120edc7f766a527cef7470@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Jun_2013_17_33_26_+1000_EK+Qc=6AEG+YVi.X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Jun_2013_17_33_26_+1000_EK+Qc=6AEG+YVi.X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/arm/mach-picoxcell/common.c between commit 4b83f75a7af3 ("ARM:
picoxcell: Remove init_irq declaration in machine description") from the
arm-soc tree and commit "reboot: arm: change reboot_mode to use enum
reboot_mode" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-picoxcell/common.c
index b13f51b,37add6d..0000000
--- a/arch/arm/mach-picoxcell/common.c
+++ b/arch/arm/mach-picoxcell/common.c
@@@ -8,8 -8,13 +8,9 @@@
   * All enquiries to support@picochip.com
   */
  #include <linux/delay.h>
 -#include <linux/irq.h>
 -#include <linux/irqchip.h>
 -#include <linux/irqdomain.h>
+ #include <linux/reboot.h>
  #include <linux/of.h>
  #include <linux/of_address.h>
 -#include <linux/of_irq.h>
  #include <linux/of_platform.h>
 =20
  #include <asm/mach/arch.h>

--Signature=_Fri__21_Jun_2013_17_33_26_+1000_EK+Qc=6AEG+YVi.X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRxAHGAAoJEECxmPOUX5FELMwP/RwchtwM5dOb3XjAlqrm5c6V
s/6rHt6m4I1+Y1ggLt7FbflmgQbCs2n875N/rqxUaO3QNJ1G1Zr6KPPmXpl4/vvB
BFztB70tbL6ZT65ivJHBoE6SWTha6TulT9XHJ9eyE+216PqJi9GQAhV3Ybg/GUhC
Kg263IN8s2asZGzVRDIoThEs2zwfpXt+Vwfojf7+atiKyZLEKHRkdGQzjpEQCL1o
NfCkTuhrP+j7FmYePwBp3DFSHW/RE58+cPxsU6VU+9BC5TbjqT1KX2/8uRCR7Uuc
RlXp2t1huXfMNRxrPW1StayLI16Pq5JhXmzZTvb91l2K8592rNkLS967mS3L5GZL
JmyQBfCkeTgRX3m0bSW35v2SJ9f5j6ALwvgggD4kQMmC3iW2icU6q9zCewnbScDd
fv5It6Cizcdnor2uDqrOBNPs7MMCZQOve40U6LRU2D5zaHFUD4r0SOpfrKX5AYdm
C2Y1wMNYqm9DaoXdObISmrH1D7RGLbl6YQfnXNH93CtwvxVnHK5ImOo9c81xYgGV
zbK+uX/SrpCGLVqEh8TdTOpXJOR+T+P7Rwt4TvAZBNOabqG5a19K7vu4g9YAnkCt
2/WDSQuBNJqocRDGA3TZ+WoiGJyqyCDZ7f24S+xQyxiq90B/tjPGoBIrW1Mn4ruQ
nd6tGxEXgPIEnXimF4IP
=suaf
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Jun_2013_17_33_26_+1000_EK+Qc=6AEG+YVi.X--
