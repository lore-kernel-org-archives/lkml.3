Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaLDWPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:15:17 -0500
Received: from mout.web.de ([212.227.15.14]:56691 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbaLDWPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:15:15 -0500
Message-ID: <5480DCEE.4070803@users.sourceforge.net>
Date: Thu, 04 Dec 2014 23:15:10 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH v2 3/6] net-PPP: Deletion of unnecessary checks before the
 function call "kfree"
References: <5307CAA2.8060406@users.sourceforge.net> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547B4886.4080406@users.sourceforge.net> <547B496E.604@users.sourceforge.net> <547C5CBC.6060607@cogentembedded.com> <547C82A6.2030808@users.sourceforge.net> <547CA157.1080401@cogentembedded.com> <5480DA32.8000201@users.sourceforge.net>
In-Reply-To: <5480DA32.8000201@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:XZC8Tu0UNS6rWgRke8VSCOWa0jDvIYibSf55H3cgLM9SS+yDQEV
 m7JDbPkHd6pTUvNbYPP+5IZPH8NON2IunTR/my6ljjjH8En0GfRcuwvfFUkkc4wOmNz2THW
 qQTxNZ5oGCcMy2q/zItq2A2R0GqkVl+b3Ohj+zoMtW3lf9FN+cHaavOAkoI61I1XxzlR85s
 MX0FYgs7ulLPeOsMiY1xg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 4 Dec 2014 22:22:23 +0100

The kfree() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/ppp/ppp_mppe.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
index b80af29..94ff216 100644
--- a/drivers/net/ppp/ppp_mppe.c
+++ b/drivers/net/ppp/ppp_mppe.c
@@ -237,8 +237,7 @@ static void *mppe_alloc(unsigned char *options, int optlen)
 	return (void *)state;
 
 out_free:
-	if (state->sha1_digest)
-		kfree(state->sha1_digest);
+	kfree(state->sha1_digest);
 	if (state->sha1)
 		crypto_free_hash(state->sha1);
 	if (state->arc4)
@@ -255,8 +254,7 @@ static void mppe_free(void *arg)
 {
 	struct ppp_mppe_state *state = (struct ppp_mppe_state *) arg;
 	if (state) {
-		if (state->sha1_digest)
-			kfree(state->sha1_digest);
+		kfree(state->sha1_digest);
 		if (state->sha1)
 			crypto_free_hash(state->sha1);
 		if (state->arc4)
-- 
2.1.3

