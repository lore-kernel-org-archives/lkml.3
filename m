Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbaLBNBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:01:04 -0500
Received: from mout.web.de ([212.227.15.14]:51756 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933183AbaLBNBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:01:00 -0500
Message-ID: <547DB803.1080406@users.sourceforge.net>
Date: Tue, 02 Dec 2014 14:00:51 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] of-unittest: Deletion of an unnecessary check before
 the function call "of_node_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ciyhSYHWHnwOpG8Z61TdGpy/3sY78dkktP0R9lZiZfzoDEMMsqr
 rSi7WFD60PI5XK4d0k59EXsz0l71nAqoc8tkLkSrozaWrCYC0HAjTrC0IHPG/4cxzEhnkDC
 8yklzoArHijvZarwBOk1uZNnDUG+ShaAgmolqiE7HEK7iWwx4ewsyPfWLW5HLjZyCCeOzxQ
 Urrys2k1ZB38EnN5blfHw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 Dec 2014 13:54:00 +0100

The of_node_put() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/of/unittest.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index cc0c5ec..06ebe9d 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -486,8 +486,7 @@ static void __init of_selftest_changeset(void)
 	/* Make sure node names are constructed correctly */
 	selftest((np = of_find_node_by_path("/testcase-data/changeset/n2/n21")),
 		 "'%s' not added\n", n21->full_name);
-	if (np)
-		of_node_put(np);
+	of_node_put(np);
 
 	mutex_lock(&of_mutex);
 	selftest(!of_changeset_revert(&chgset), "revert failed\n");
-- 
2.1.3

