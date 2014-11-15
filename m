Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaKOUoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 15:44:39 -0500
Received: from mout.web.de ([212.227.15.3]:53342 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbaKOUoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 15:44:37 -0500
Message-ID: <5467BB2A.2030108@users.sourceforge.net>
Date: Sat, 15 Nov 2014 21:44:26 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] lib/mpi: Deletion of unnecessary checks before the function
 call "mpi_free_limb_space"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:+h40hZeRnXGjZqvdxdSXlWzk+IojcDFL32cPYwjz5Ez0XLEGWfy
 2qgWAorxtrPBvoG5eoV7mpnDAia+uPJDigEuBFxGtKzn6b0UYk2XzNcmiwNJgHELbpoI0Do
 LB8lFVCtrUgo9GPjpcDiDTb9spU/AskGjFQuxOVKsrvevsr3Yal948UkiJLIUfjhMmMR5I8
 kllT43CybCNACBnjkoO1A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 15 Nov 2014 21:33:26 +0100

The mpi_free_limb_space() function tests whether its argument is NULL and
then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 lib/mpi/mpi-pow.c  | 15 +++++----------
 lib/mpi/mpih-mul.c | 21 +++++++--------------
 2 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/lib/mpi/mpi-pow.c b/lib/mpi/mpi-pow.c
index 5464c87..c28882f 100644
--- a/lib/mpi/mpi-pow.c
+++ b/lib/mpi/mpi-pow.c
@@ -308,16 +308,11 @@ leave:
 enomem:
 	if (assign_rp)
 		mpi_assign_limb_space(res, rp, size);
-	if (mp_marker)
-		mpi_free_limb_space(mp_marker);
-	if (bp_marker)
-		mpi_free_limb_space(bp_marker);
-	if (ep_marker)
-		mpi_free_limb_space(ep_marker);
-	if (xp_marker)
-		mpi_free_limb_space(xp_marker);
-	if (tspace)
-		mpi_free_limb_space(tspace);
+	mpi_free_limb_space(mp_marker);
+	mpi_free_limb_space(bp_marker);
+	mpi_free_limb_space(ep_marker);
+	mpi_free_limb_space(xp_marker);
+	mpi_free_limb_space(tspace);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(mpi_powm);
diff --git a/lib/mpi/mpih-mul.c b/lib/mpi/mpih-mul.c
index 7c84171..ff021cc 100644
--- a/lib/mpi/mpih-mul.c
+++ b/lib/mpi/mpih-mul.c
@@ -339,8 +339,7 @@ mpihelp_mul_karatsuba_case(mpi_ptr_t prodp,
 	mpi_limb_t cy;
 
 	if (!ctx->tspace || ctx->tspace_size < vsize) {
-		if (ctx->tspace)
-			mpi_free_limb_space(ctx->tspace);
+		mpi_free_limb_space(ctx->tspace);
 		ctx->tspace = mpi_alloc_limb_space(2 * vsize);
 		if (!ctx->tspace)
 			return -ENOMEM;
@@ -354,12 +353,10 @@ mpihelp_mul_karatsuba_case(mpi_ptr_t prodp,
 	usize -= vsize;
 	if (usize >= vsize) {
 		if (!ctx->tp || ctx->tp_size < vsize) {
-			if (ctx->tp)
-				mpi_free_limb_space(ctx->tp);
+			mpi_free_limb_space(ctx->tp);
 			ctx->tp = mpi_alloc_limb_space(2 * vsize);
 			if (!ctx->tp) {
-				if (ctx->tspace)
-					mpi_free_limb_space(ctx->tspace);
+				mpi_free_limb_space(ctx->tspace);
 				ctx->tspace = NULL;
 				return -ENOMEM;
 			}
@@ -407,16 +404,12 @@ void mpihelp_release_karatsuba_ctx(struct karatsuba_ctx *ctx)
 {
 	struct karatsuba_ctx *ctx2;
 
-	if (ctx->tp)
-		mpi_free_limb_space(ctx->tp);
-	if (ctx->tspace)
-		mpi_free_limb_space(ctx->tspace);
+	mpi_free_limb_space(ctx->tp);
+	mpi_free_limb_space(ctx->tspace);
 	for (ctx = ctx->next; ctx; ctx = ctx2) {
 		ctx2 = ctx->next;
-		if (ctx->tp)
-			mpi_free_limb_space(ctx->tp);
-		if (ctx->tspace)
-			mpi_free_limb_space(ctx->tspace);
+		mpi_free_limb_space(ctx->tp);
+		mpi_free_limb_space(ctx->tspace);
 		kfree(ctx);
 	}
 }
-- 
2.1.3


