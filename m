Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbaLDWNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:13:35 -0500
Received: from mout.web.de ([212.227.15.3]:52655 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933257AbaLDWNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:13:32 -0500
Message-ID: <5480DC84.1020601@users.sourceforge.net>
Date: Thu, 04 Dec 2014 23:13:24 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH v2 2/6] net-PPP: Fix indentation
References: <5307CAA2.8060406@users.sourceforge.net> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547B4886.4080406@users.sourceforge.net> <547B496E.604@users.sourceforge.net> <547C5CBC.6060607@cogentembedded.com> <547C82A6.2030808@users.sourceforge.net> <547CA157.1080401@cogentembedded.com> <5480DA32.8000201@users.sourceforge.net>
In-Reply-To: <5480DA32.8000201@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ak5ptdBI4gNoa3E/dAbqrD7nCbw9iHeUYfyO6IIN28AgnaxfNoM
 FxTtFe60EpG1tKQ31fwmuy4VGCmWJvAYgP65YM870Oon3Miipc9rG3T7DM4Jwp/f2zIG3Fa
 OSJma/H0pQe4fHJCiO7e5iLO8UzxLoh4YYAH7UtqqDjrQH67XF0AbukE/FLo/BT96GMOc6X
 6d89pakaOFT5jXr8QUPlQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 4 Dec 2014 22:15:20 +0100

The implementations of the functions "mppe_alloc" and "mppe_free" contained
unwanted space characters.

Let us improve the indentation according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/ppp/ppp_mppe.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
index 84b7bce..b80af29 100644
--- a/drivers/net/ppp/ppp_mppe.c
+++ b/drivers/net/ppp/ppp_mppe.c
@@ -236,15 +236,15 @@ static void *mppe_alloc(unsigned char *options, int optlen)
 
 	return (void *)state;
 
-	out_free:
-	    if (state->sha1_digest)
+out_free:
+	if (state->sha1_digest)
 		kfree(state->sha1_digest);
-	    if (state->sha1)
+	if (state->sha1)
 		crypto_free_hash(state->sha1);
-	    if (state->arc4)
+	if (state->arc4)
 		crypto_free_blkcipher(state->arc4);
-	    kfree(state);
-	out:
+	kfree(state);
+out:
 	return NULL;
 }
 
@@ -255,13 +255,13 @@ static void mppe_free(void *arg)
 {
 	struct ppp_mppe_state *state = (struct ppp_mppe_state *) arg;
 	if (state) {
-	    if (state->sha1_digest)
-		kfree(state->sha1_digest);
-	    if (state->sha1)
-		crypto_free_hash(state->sha1);
-	    if (state->arc4)
-		crypto_free_blkcipher(state->arc4);
-	    kfree(state);
+		if (state->sha1_digest)
+			kfree(state->sha1_digest);
+		if (state->sha1)
+			crypto_free_hash(state->sha1);
+		if (state->arc4)
+			crypto_free_blkcipher(state->arc4);
+		kfree(state);
 	}
 }
 
-- 
2.1.3

