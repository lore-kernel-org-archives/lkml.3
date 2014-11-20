Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbaKTQrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:47:47 -0500
Received: from mout.web.de ([212.227.17.12]:51077 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757402AbaKTQrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:47:46 -0500
Message-ID: <546E1B21.2070206@users.sourceforge.net>
Date: Thu, 20 Nov 2014 17:47:29 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Scott Murray <scott@spiteful.org>,
        linux-pci@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] PCI: hotplug: Deletion of an unnecessary check before
 the function call "pci_dev_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:HwHPzuRrFxKlvjeZffSwq2855e3brNNTdunVscDHtGNrJcJgBgG
 jXmRHe6dmUNXtYI/lT1uUPF0JeStPdnfXRwwgf03qW5m9bU9FSxXHagHM851ISCtby0Vqn3
 B4eJRGOQABeqOWN6RQb3bJCqjsIhPYeI1aCLftPe5yFy8vmqvRtDpsMtwBTapLjrtH5fV1X
 1cvbiPah3oV4hJH+1lDQg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 17:42:23 +0100

The pci_dev_put() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/pci/hotplug/cpci_hotplug_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/cpci_hotplug_core.c b/drivers/pci/hotplug/cpci_hotplug_core.c
index e09cf78..82c969b 100644
--- a/drivers/pci/hotplug/cpci_hotplug_core.c
+++ b/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -211,8 +211,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 
 	kfree(slot->hotplug_slot->info);
 	kfree(slot->hotplug_slot);
-	if (slot->dev)
-		pci_dev_put(slot->dev);
+	pci_dev_put(slot->dev);
 	kfree(slot);
 }
 
-- 
2.1.3

