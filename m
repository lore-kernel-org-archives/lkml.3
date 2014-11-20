Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbaKTMdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:33:45 -0500
Received: from mout.web.de ([212.227.17.12]:58331 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbaKTMdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:33:44 -0500
Message-ID: <546DDF95.5090300@users.sourceforge.net>
Date: Thu, 20 Nov 2014 13:33:25 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, Mike Isely <isely@pobox.com>,
        linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] [media] USB: Deletion of unnecessary checks before three
 function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:aR99qqUh4ZUcCk9rmRVPvCnbQKoIPd5B8d6IiM83AOoaI1eIIaK
 nYU3T/b+gF6anCNfL8wGueAGV4ZrRQUHGts2jEQqhCHqAYqEHU1aJBYW47HRR4bdmcXC68c
 eunKyY6DvCdNZrxYtdo35P55QZB9fB5VNdGzeV/Y4iV6ggKSigItyTlSxQS4i4CVL0AuxQ2
 uHQ9GiQP4Cfa1ebReM3YA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 13:26:36 +0100

The functions pvr2_hdw_destroy(), rc_unregister_device() and vfree() perform
also input parameter validation. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/au0828/au0828-input.c     | 3 +--
 drivers/media/usb/em28xx/em28xx-input.c     | 3 +--
 drivers/media/usb/pvrusb2/pvrusb2-context.c | 2 +-
 drivers/media/usb/s2255/s2255drv.c          | 3 +--
 4 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index fd0d3a90..3357141 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -353,8 +353,7 @@ void au0828_rc_unregister(struct au0828_dev *dev)
 	if (!ir)
 		return;
 
-	if (ir->rc)
-		rc_unregister_device(ir->rc);
+	rc_unregister_device(ir->rc);
 
 	/* done */
 	kfree(ir);
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index ed843bd..67a22f4 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -838,8 +838,7 @@ static int em28xx_ir_fini(struct em28xx *dev)
 	if (!ir)
 		goto ref_put;
 
-	if (ir->rc)
-		rc_unregister_device(ir->rc);
+	rc_unregister_device(ir->rc);
 
 	/* done */
 	kfree(ir);
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-context.c b/drivers/media/usb/pvrusb2/pvrusb2-context.c
index 7c19ff7..c8761c7 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-context.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-context.c
@@ -80,7 +80,7 @@ static void pvr2_context_set_notify(struct pvr2_context *mp, int fl)
 static void pvr2_context_destroy(struct pvr2_context *mp)
 {
 	pvr2_trace(PVR2_TRACE_CTXT,"pvr2_context %p (destroy)",mp);
-	if (mp->hdw) pvr2_hdw_destroy(mp->hdw);
+	pvr2_hdw_destroy(mp->hdw);
 	pvr2_context_set_notify(mp, 0);
 	mutex_lock(&pvr2_context_mutex);
 	if (mp->exist_next) {
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 2c90186..3cab886 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1976,8 +1976,7 @@ static int s2255_release_sys_buffers(struct s2255_vc *vc)
 {
 	unsigned long i;
 	for (i = 0; i < SYS_FRAMES; i++) {
-		if (vc->buffer.frame[i].lpvbits)
-			vfree(vc->buffer.frame[i].lpvbits);
+		vfree(vc->buffer.frame[i].lpvbits);
 		vc->buffer.frame[i].lpvbits = NULL;
 	}
 	return 0;
-- 
2.1.3

