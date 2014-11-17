Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaKQRk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 12:40:29 -0500
Received: from mout.web.de ([212.227.15.14]:60064 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaKQRk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 12:40:28 -0500
Message-ID: <546A3302.9040804@users.sourceforge.net>
Date: Mon, 17 Nov 2014 18:40:18 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Seth Jennings <sjennings@variantweb.net>, linux-mm@kvack.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] mm/zswap: Deletion of an unnecessary check before the
 function call "free_percpu"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:aYeb6tPFilBGPqw0/CxY3TPGS+4Z3XFsxpqs2vwh1xFaQwoAXZD
 EjT1eQlcPqEXHsxlH9tNLsettq1ugI2PtHMxUoSGzJVKo9Iu8DIUSA6pnopFipBHos1cLvi
 +qPr0smi7+lDcV4sSc5XkB7Imk0Q+a7ocF/rAI9IAzUrKdOZcNhpFDnzSMEL9AjNm4mLywv
 /bfhTXQzy6j43gFWh/Cfg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 17 Nov 2014 18:33:33 +0100

The free_percpu() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 mm/zswap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ea064c1..35629f0 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -152,8 +152,7 @@ static int __init zswap_comp_init(void)
 static void zswap_comp_exit(void)
 {
 	/* free percpu transforms */
-	if (zswap_comp_pcpu_tfms)
-		free_percpu(zswap_comp_pcpu_tfms);
+	free_percpu(zswap_comp_pcpu_tfms);
 }
 
 /*********************************
-- 
2.1.3

