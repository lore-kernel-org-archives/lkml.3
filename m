Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaKUT0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:26:46 -0500
Received: from mout.web.de ([212.227.17.11]:51991 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaKUT0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:26:45 -0500
Message-ID: <546F91E5.60104@users.sourceforge.net>
Date: Fri, 21 Nov 2014 20:26:29 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] IDE: Deletion of an unnecessary check before the function
 call "module_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:7t9oqhvJswdQLPxeT59OD58g2+Cw4KMyV7s8PfhP8QMJ8cB7o7R
 H+BEz2IHyMgNsYsyVcxU6Er1xMe5L57aB6VePz6OzDrqR17L0g8hlAYTSggWkzsf00XleUu
 t4MyzTW3eDfNp2NAIuHcXKg0kClOPAVGzBVVNsMR0t2LYQX64RXlju9YhWU8PxKMrprmFiq
 VDsTxmiuv5PHpjZNOAMQA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Nov 2014 20:22:32 +0100

The module_put() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/ide/ide.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 2ce6268..e29b02c 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -101,8 +101,7 @@ void ide_device_put(ide_drive_t *drive)
 	struct device *host_dev = drive->hwif->host->dev[0];
 	struct module *module = host_dev ? host_dev->driver->owner : NULL;
 
-	if (module)
-		module_put(module);
+	module_put(module);
 #endif
 	put_device(&drive->gendev);
 }
-- 
2.1.3

