Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaK2OFo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 09:05:44 -0500
Received: from mout.web.de ([212.227.15.14]:56303 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaK2OFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 09:05:42 -0500
Message-ID: <5479D2AD.9060704@users.sourceforge.net>
Date: Sat, 29 Nov 2014 15:05:33 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] net: cassini: Deletion of an unnecessary check before
 the function call "vfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <5479CD2A.9030009@users.sourceforge.net>
In-Reply-To: <5479CD2A.9030009@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:bUmZ8QkHBGE7lNelcpF5hF8ajek6MQOXv8IbjCv3+0M38WaNn4n
 4wrJl+sZMQWzj/chG1szwDf1AJpHOCoSovBA3w8gI16OX2L+teRHUapUMpz9hu0+Qut7fes
 pPAmyTQGUPiWfO/cUSlrrRP6gst4Pmg3pB4Un7H+oWU61cx8ERJnygySuA+Ms1DgfY4uIlG
 PvN8ZBUoAHA5n4R2tRKOQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 29 Nov 2014 14:34:59 +0100

The vfree() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/ethernet/sun/cassini.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 37f87ff..d745808 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -5179,8 +5179,7 @@ static void cas_remove_one(struct pci_dev *pdev)
 	cp = netdev_priv(dev);
 	unregister_netdev(dev);
 
-	if (cp->fw_data)
-		vfree(cp->fw_data);
+	vfree(cp->fw_data);
 
 	mutex_lock(&cp->pm_mutex);
 	cancel_work_sync(&cp->reset_task);
-- 
2.1.3

