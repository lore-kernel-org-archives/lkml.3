Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaKQSnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:43:17 -0500
Received: from mout.web.de ([212.227.17.12]:51851 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaKQSnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:43:16 -0500
Message-ID: <546A419B.7060409@users.sourceforge.net>
Date: Mon, 17 Nov 2014 19:42:35 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joel Becker <jlbec@evilplan.org>
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] configfs: Deletion of unnecessary checks before the function
 call "config_item_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ZgtTzwtD8g3VghMv7Iwl4uYdoypesjkSEWyRbi0xkmolilIriSE
 KwqGs1+jkaiCpPWy9PnMMbcOxBn+R4t8KFYmXQ4qQ888bhayltb/usKsO4ih92Ib/rkyQbl
 TzzKs3s3ozvGgja9Ma33+ZYKSgfpqtLDaudsdqNGh+dIlFVlze6TmKy+Wghd2lOBg0vf1fW
 RhEudbQLPYoemv9dHMPTw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 17 Nov 2014 19:37:03 +0100

The config_item_put() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/configfs/file.c | 3 +--
 fs/configfs/item.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/configfs/file.c b/fs/configfs/file.c
index 1d1c41f..48f36e7 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -291,8 +291,7 @@ static int configfs_release(struct inode * inode, struct file * filp)
 	struct module * owner = attr->ca_owner;
 	struct configfs_buffer * buffer = filp->private_data;
 
-	if (item)
-		config_item_put(item);
+	config_item_put(item);
 	/* After this point, attr should not be accessed. */
 	module_put(owner);
 
diff --git a/fs/configfs/item.c b/fs/configfs/item.c
index e65f9ff..891b20e 100644
--- a/fs/configfs/item.c
+++ b/fs/configfs/item.c
@@ -153,8 +153,7 @@ static void config_item_cleanup(struct config_item *item)
 		t->ct_item_ops->release(item);
 	if (s)
 		config_group_put(s);
-	if (parent)
-		config_item_put(parent);
+	config_item_put(parent);
 }
 
 static void config_item_release(struct kref *kref)
-- 
2.1.3

