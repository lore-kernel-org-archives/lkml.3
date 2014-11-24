Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaKXVkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:40:32 -0500
Received: from mout.web.de ([212.227.15.4]:59932 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaKXVkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:40:31 -0500
Message-ID: <5473A5C4.6050104@users.sourceforge.net>
Date: Mon, 24 Nov 2014 22:40:20 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] [media] Siano: Deletion of an unnecessary check before
 the function call "rc_unregister_device"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:iIIFsPsNWk/e8+wbotE240lMq8UaIFbp6NG9GQtMy6L/WVDvgGx
 ou+nuVy0ed85JnMdIV/1hkWQ377CijD0nw/UXajDza74XTkyDG4tnaOwwbq+iLbP4lvnd5H
 lHZXooMc5giHMAN/galjzejv/Z6FjA6qzt+hOZ/MrRtjA9P75W6VHRUT9PY6qWjZFvgsm93
 KvT9BbqpuuNKl/7EfrIag==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 24 Nov 2014 22:32:30 +0100

The rc_unregister_device() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call
is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/common/siano/smsir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
index 273043e..35d0e88 100644
--- a/drivers/media/common/siano/smsir.c
+++ b/drivers/media/common/siano/smsir.c
@@ -107,8 +107,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 
 void sms_ir_exit(struct smscore_device_t *coredev)
 {
-	if (coredev->ir.dev)
-		rc_unregister_device(coredev->ir.dev);
+	rc_unregister_device(coredev->ir.dev);
 
 	sms_log("");
 }
-- 
2.1.3

