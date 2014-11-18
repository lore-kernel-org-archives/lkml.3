Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbaKRUqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:46:12 -0500
Received: from mout.web.de ([212.227.17.11]:54944 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbaKRUqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:46:09 -0500
Message-ID: <546BAFF5.5020603@users.sourceforge.net>
Date: Tue, 18 Nov 2014 21:45:41 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] net: xfrm: Deletion of an unnecessary check before the
 function call "ipcomp_free_tfms"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:7O8h5JQvN6Xm+mm+X2AR2QnOYcJlyH4tczIDkJi7VizOZGa6kc4
 WEbYvrrK5gLNObRVW1cuMxPuTMJb7g/Fnt1BY2fTJiFvM80s1h/U+BrrPCs/uah8xoN8Ylr
 jDQ+UVn17zRoh5bG8V7O3uitOL9SxDRTmC1JYR9IvK+HWWSQUgzHTDqIMYMchkNqtIL3+HG
 mu8b3AP1WBzLgve5Z8JRg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 18 Nov 2014 21:41:26 +0100

The ipcomp_free_tfms() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 net/xfrm/xfrm_ipcomp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index ccfdc71..47863cd 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -320,8 +320,7 @@ error:
 
 static void ipcomp_free_data(struct ipcomp_data *ipcd)
 {
-	if (ipcd->tfms)
-		ipcomp_free_tfms(ipcd->tfms);
+	ipcomp_free_tfms(ipcd->tfms);
 	ipcomp_free_scratches();
 }
 
-- 
2.1.3

