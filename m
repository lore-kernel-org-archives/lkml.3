Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaKSN3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:29:08 -0500
Received: from mout.web.de ([212.227.15.3]:64762 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbaKSN3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:29:07 -0500
Message-ID: <546C9B12.5070800@users.sourceforge.net>
Date: Wed, 19 Nov 2014 14:28:50 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] agp/intel-gtt: Deletion of unnecessary checks before
 the function call "pci_dev_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:shtEhoOrQNfnsWxZISwacNoU9TV4d/RLhw0CLStdAy69vbdqzFQ
 5RViRiQuou5K8fbqxMjDJsvOjMpzJFWJGrnFWEIsQPx644q83hegnnGgC9HijS+8AfnW3n3
 fAaNJqVWtnkfPSZB3KJK4N4YOCu0KBNFs9jSHu79+h1h5f/9eu4/+Ota5s6b0m4dk3xm5v3
 7o5mAPsarVlqK2VYFxgIw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Nov 2014 14:24:20 +0100

The pci_dev_put() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/char/agp/intel-gtt.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 9a024f8..db5877e 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1434,10 +1434,8 @@ void intel_gmch_remove(void)
 	if (--intel_private.refcount)
 		return;
 
-	if (intel_private.pcidev)
-		pci_dev_put(intel_private.pcidev);
-	if (intel_private.bridge_dev)
-		pci_dev_put(intel_private.bridge_dev);
+	pci_dev_put(intel_private.pcidev);
+	pci_dev_put(intel_private.bridge_dev);
 	intel_private.driver = NULL;
 }
 EXPORT_SYMBOL(intel_gmch_remove);
-- 
2.1.3

