Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaDOTV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:21:27 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:52623 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaDOTVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:21:20 -0400
X-ME-Helo: PCombes.localdomain
X-ME-Auth: cGFzY29tQHdhbmFkb28uZnI=
X-ME-Date: Tue, 15 Apr 2014 21:21:19 +0200
X-ME-IP: 82.124.119.218
Message-ID: <534D86AE.3090503@orange.fr>
Date: Tue, 15 Apr 2014 21:21:18 +0200
From: Pascal COMBES <pascom@orange.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Jarod Wilson <jarod@wilsonet.com>, Jingoo Han <jg1.han@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-kernel@vger.kernel.org, Naren Sankar <nsankar@broadcom.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Scott Davilla <davilla@4pi.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Robert Foss <dev@robertfoss.se>
Subject: [PATCH v3 2/3] Staging: crystalhd: Removed cast in crystalhd_lnx.c
References: <534AAED2.7050205@orange.fr> <20140413154859.GA18189@kroah.com>
In-Reply-To: <20140413154859.GA18189@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed useless (because automatic) cast from void * in crystalhd_lnx.c

Signed-off-by: Pascal COMBES <pascom@orange.fr>
---
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index fd7f08a..0e432bc 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -28,7 +28,7 @@ static struct crystalhd_adp *g_adp_info;
 
 static irqreturn_t chd_dec_isr(int irq, void *arg)
 {
-	struct crystalhd_adp *adp = (struct crystalhd_adp *) arg;
+	struct crystalhd_adp *adp = arg;
 	int rc = 0;
 	if (adp)
 		rc = crystalhd_cmd_interrupt(&adp->cmds);

