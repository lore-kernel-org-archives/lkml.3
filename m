Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaEWFXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 01:23:19 -0400
Received: from ozlabs.org ([103.22.144.67]:57393 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbaEWFXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 01:23:18 -0400
Date: Fri, 23 May 2014 15:23:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <chris@printf.net>, Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Balaji T K <balajitk@ti.com>
Subject: linux-next: manual merge of the mmc tree with the slave-dma tree
Message-ID: <20140523152310.05323045@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/jtCCf/dYflbXQurqZD24aRV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jtCCf/dYflbXQurqZD24aRV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next merge of the mmc tree got a conflict in
include/linux/omap-dma.h between commit a8246fedacad ("dmaengine: omap:
hide filter_fn for built-in drivers") from the slave-dma tree and
commit ee526d515ad1 ("mmc: omap_hsmmc: split omap-dma header file")
from the mmc tree.

I fixed it up (I effectively applied the former commit to the new file)
and can carry the fix as necessary (no action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 23 May 2014 15:19:48 +1000
Subject: [PATCH] dmaengine: omap: fix for code movement

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/omap-dmaengine.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/omap-dmaengine.h b/include/linux/omap-dmaengine.h
index 2b0b6aa01922..8e6906c72e90 100644
--- a/include/linux/omap-dmaengine.h
+++ b/include/linux/omap-dmaengine.h
@@ -10,7 +10,7 @@
=20
 struct dma_chan;
=20
-#if defined(CONFIG_DMA_OMAP) || defined(CONFIG_DMA_OMAP_MODULE)
+#if defined(CONFIG_DMA_OMAP) || (defined(CONFIG_DMA_OMAP_MODULE) && define=
d(MODULE))
 bool omap_dma_filter_fn(struct dma_chan *, void *);
 #else
 static inline bool omap_dma_filter_fn(struct dma_chan *c, void *d)
--=20
2.0.0.rc4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/jtCCf/dYflbXQurqZD24aRV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBCAAGBQJTfttEAAoJEMDTa8Ir7ZwVeRIP+I9y1wzGwF3HDrL8UAeApWD0
HJax0H5mX+dGn8DeORmylM+hCucI3FV4gKv6GfJ25hRnIPMyZzLKC77aU0Hw8/Eh
Ir6OjBhim2B7IEHiMlMpaBlROAXwoUmwv8zRlJza3S0lkr3QxhwVv0xfHsyVbX1f
Twu0UevQ7nkSU7y/QkkPinwer+sHiIYpsISBRP7rT4WQYqVODP8gBoYIOHiQKcu0
dIp1MyribpLFg46DimQb0Qn2wW7zZhpk8iJuOiHII63AFbfWu4B0iB/SF/k6z9+R
wbByvjYgVKoPFWqtgpcyEqSmxvjN3Gq4E1qvWQYdoQQlbOnifZr7EG3iBA5mSQDk
weZHEtcAwAilZ5420x/pyJgshV/c31v3ZvIIJpPWuTBrdUJ2DjWFBEIwinHtnutS
nVxsUF5Iisq+h71a6qhFYE3nLKqm4vWmRdVt1pBInrA+Z4UCF845Rwct6rHg+p+3
emjTQjYQx4leKSD10jkZxZGPaga6yP2ZMDVq1o1/9JtIbV+vg5NSvU5DoptqcVr0
mSx8wyUUlQrOyY+PaQvHHcyMo1suo/Whi0RFcqUkTa0HE2KGU/W3avv7BUJudHy8
eTEsLr/Z53IfADVRD+w9h2pHnUSNSOo17MwyP0L0B/mr07s9IhvG9mrEiapYfKpn
1J9JGP622NAL+iuLn80=
=83FN
-----END PGP SIGNATURE-----

--Sig_/jtCCf/dYflbXQurqZD24aRV--
