Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaK3QsB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 11:48:01 -0500
Received: from mout.web.de ([212.227.15.4]:60416 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbaK3QsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 11:48:00 -0500
Message-ID: <547B4A35.7000500@users.sourceforge.net>
Date: Sun, 30 Nov 2014 17:47:49 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 3/3] net-PPP: Delete an unnecessary assignment
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547B4886.4080406@users.sourceforge.net>
In-Reply-To: <547B4886.4080406@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:miZioYw1GXqTMsQqywf/7f58jLloHTFJ9DrJP+zgSN+ExgHDBzM
 5vQ6y40msroHqeBaX91KBrXzIpsgGbgGQ/xx7NWDnGIbl0V+5FJga7xqdZ24Lar2cOhq7Af
 cBYjDudLEvHmmr6zrNvLozJ2Z09TiIIJPzTAty+QH5UhQS06u2T8TTrP3L58a8hmm6jeJ2W
 3iYYPKA5ZqdxIMguId2lA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 30 Nov 2014 17:17:36 +0100

The data structure element "arc4" was assigned a null pointer by the
mppe_alloc() function if a previous function call "crypto_alloc_blkcipher"
failed. This assignment became unnecessary with previous source
code adjustments.
Let us delete it from the affected implementation because the element "arc4"
will not be accessible outside the function after the detected
allocation failure.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/ppp/ppp_mppe.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
index 962c1a0..d913bc9 100644
--- a/drivers/net/ppp/ppp_mppe.c
+++ b/drivers/net/ppp/ppp_mppe.c
@@ -205,10 +205,8 @@ static void *mppe_alloc(unsigned char *options, int optlen)
 
 
 	state->arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(state->arc4)) {
-		state->arc4 = NULL;
+	if (IS_ERR(state->arc4))
 		goto out_free;
-	}
 
 	state->sha1 = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(state->sha1)) {
-- 
2.1.3

