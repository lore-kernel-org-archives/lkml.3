Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaLARTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:19:08 -0500
Received: from mout.web.de ([212.227.17.12]:49446 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaLARTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:19:05 -0500
Message-ID: <547CA303.9000001@users.sourceforge.net>
Date: Mon, 01 Dec 2014 18:18:59 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] block-skd: Deletion of an unnecessary check before the
 function call "kfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:slXOT9RQsRLPv4V9OBfkAbexS2MCyDlNS9fEdTkd+qBhh05tnOy
 GktqAYC6ihXjwN4b6PRTtLnU7cKza9YyEne6KLKB5FarmPJ84yfigHGWv7hMWGXcnsIWW3d
 WV9ThPJ4PD402/as3nXGzJuAzP1H4A7FQzPvn5RZRjneob+er8A/5m+G/7tBW5BKbMnFJAX
 tij/PjiXz3z+qehKa5qDA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 1 Dec 2014 18:15:46 +0100

The kfree() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/block/skd_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 1e46eb2..c4b0259 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -3998,8 +3998,7 @@ static int skd_acquire_msix(struct skd_device *skdev)
 	return 0;
 
 msix_out:
-	if (entries)
-		kfree(entries);
+	kfree(entries);
 	skd_release_msix(skdev);
 	return rc;
 }
-- 
2.1.3

