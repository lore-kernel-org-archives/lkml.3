Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaLDWUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:20:30 -0500
Received: from mout.web.de ([212.227.15.3]:60265 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbaLDWU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:20:28 -0500
Message-ID: <5480DE25.2020802@users.sourceforge.net>
Date: Thu, 04 Dec 2014 23:20:21 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH v2 6/6] net-PPP: Delete another unnecessary assignment in
 mppe_alloc()
References: <5307CAA2.8060406@users.sourceforge.net> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547B4886.4080406@users.sourceforge.net> <547B496E.604@users.sourceforge.net> <547C5CBC.6060607@cogentembedded.com> <547C82A6.2030808@users.sourceforge.net> <547CA157.1080401@cogentembedded.com> <5480DA32.8000201@users.sourceforge.net>
In-Reply-To: <5480DA32.8000201@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:zPexKzTdbYOgbRogxiLIFv/f7SeAglprBH7P+9zZz3iXyocQ06i
 i7sWYDT03fp3aElRZPovrZFytfjO9/6sDmq4whlfdV7vU671GYD0Z/oNgeahXBTV/6BQlUH
 z6d+m/aHrNtikzGpaoCr2HXudpoyK3G4bWs+/ZZLGIuxsyIQsoDLmD5OKZHY7Ic4KRuvZH2
 2miB95WRFO4pGFGcRP/4w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 4 Dec 2014 22:42:30 +0100

The data structure element "sha1" was assigned a null pointer by the
mppe_alloc() after a function call "crypto_alloc_hash" failed.
It was determined that this element was not accessed by the implementation
of the crypto_free_blkcipher() function.

Let us delete it from the affected implementation because the element "sha1"
will not be accessible outside the function after the detected
allocation failure.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/ppp/ppp_mppe.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
index b7db4b1..32cb054 100644
--- a/drivers/net/ppp/ppp_mppe.c
+++ b/drivers/net/ppp/ppp_mppe.c
@@ -208,10 +208,8 @@ static void *mppe_alloc(unsigned char *options, int optlen)
 		goto out_free;
 
 	state->sha1 = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(state->sha1)) {
-		state->sha1 = NULL;
+	if (IS_ERR(state->sha1))
 		goto out_free_blkcipher;
-	}
 
 	digestsize = crypto_hash_digestsize(state->sha1);
 	if (digestsize < MPPE_MAX_KEY_LEN)
-- 
2.1.3

