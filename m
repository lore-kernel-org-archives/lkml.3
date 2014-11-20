Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbaKTRzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:55:31 -0500
Received: from mout.web.de ([212.227.17.12]:59256 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbaKTRz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:55:29 -0500
Message-ID: <546E2B02.5090902@users.sourceforge.net>
Date: Thu, 20 Nov 2014 18:55:14 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "James E. J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] SCSI: Deletion of unnecessary checks before the function
 call "put_device"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Qc3BIjZXnIhxRUrP+goiuDw9cc5JbKwQ6PiChg2DjHtYdgi/BIS
 PSLLZurzy2QNnWgPN4iENYuasgQYNKHYTGDpI1KTnH5lKKHCb7apjZSVhdlI9vPbo2Xnr2B
 yUsfgXEVDJxJw2DlKsycbbB74e5BcsprSo0KdMCaJcd1a4eDyXWXKd1XdmFh2Zedv7pbLsR
 r3aUB832jmCrWzTG8a4Gg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 18:48:52 +0100

The put_device() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/hosts.c      | 3 +--
 drivers/scsi/scsi_sysfs.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 6de80e3..57afb19 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -337,8 +337,7 @@ static void scsi_host_dev_release(struct device *dev)
 
 	kfree(shost->shost_data);
 
-	if (parent)
-		put_device(parent);
+	put_device(parent);
 	kfree(shost);
 }
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 8b4105a..c977c99 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -426,8 +426,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
-	if (parent)
-		put_device(parent);
+	put_device(parent);
 }
 
 static void scsi_device_dev_release(struct device *dev)
-- 
2.1.3

