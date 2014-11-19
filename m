Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbaKSJUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:20:50 -0500
Received: from mout.web.de ([212.227.17.11]:54266 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbaKSJUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:20:47 -0500
Message-ID: <546C60E0.1070903@users.sourceforge.net>
Date: Wed, 19 Nov 2014 10:20:32 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] crypto-drbg: Deletion of unnecessary checks before the
 function call "kzfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:KOxjjYI+AKsiE1tjO4B5WBm6BW6Jbh+JE5Ow4rAeQBzgiRoTIn7
 onk0q6qTU8WbR0nQByms1xirJgiG93y8Df8WMpjwckwG8ywrRkSHmdQ+DS1mZiOblAfKJcr
 VFq2lHG/oEAt1rF//3ksOx3VVp9oXUNj/8EDPvucpNnILfjnBzSAe15nUyiv5qKPawFrjOm
 4MscnJNcEMyV9RALLHfjw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Nov 2014 10:11:04 +0100

The kzfree() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 crypto/drbg.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index a53ee09..b6f22d4 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1151,8 +1151,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 	drbg->reseed_ctr = 1;
 
 out:
-	if (entropy)
-		kzfree(entropy);
+	kzfree(entropy);
 	return ret;
 }
 
@@ -1161,19 +1160,15 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 {
 	if (!drbg)
 		return;
-	if (drbg->V)
-		kzfree(drbg->V);
+	kzfree(drbg->V);
 	drbg->V = NULL;
-	if (drbg->C)
-		kzfree(drbg->C);
+	kzfree(drbg->C);
 	drbg->C = NULL;
-	if (drbg->scratchpad)
-		kzfree(drbg->scratchpad);
+	kzfree(drbg->scratchpad);
 	drbg->scratchpad = NULL;
 	drbg->reseed_ctr = 0;
 #ifdef CONFIG_CRYPTO_FIPS
-	if (drbg->prev)
-		kzfree(drbg->prev);
+	kzfree(drbg->prev);
 	drbg->prev = NULL;
 	drbg->fips_primed = false;
 #endif
@@ -1293,8 +1288,7 @@ static int drbg_make_shadow(struct drbg_state *drbg, struct drbg_state **shadow)
 	return 0;
 
 err:
-	if (tmp)
-		kzfree(tmp);
+	kzfree(tmp);
 	return ret;
 }
 
-- 
2.1.3

