Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160AbaKXWDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:03:46 -0500
Received: from mout.web.de ([212.227.15.4]:59639 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaKXWDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:03:44 -0500
Message-ID: <5473AB1F.7090303@users.sourceforge.net>
Date: Mon, 24 Nov 2014 23:03:11 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Frederich <jfrederich@gmail.com>,
        Jon Nettleton <jon.nettleton@gmail.com>, devel@driverdev.osuosl.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] staging: olpc_dcon: Deletion of a check before backlight_device_unregister()
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:KRRmwGVWzSXbTUZRePGpZnT0KWXrJ5MEc9XIc3qmUCLhvZxyPOi
 tPTXxXGuRQZhbADomc+dlIK8JbLl1r8cFAW0LjT6KzzGzVwg3sd9WcIDW72tHgHzvKBAb9d
 sgYJIvoD2ZmcawCtnOsNTRcFNdsf6CMVHXY1dem7K75KDH2jrzr/c/zyBlRsjVNCet30PBO
 MbQ6OF6dITcrxBDJJJ0mA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 24 Nov 2014 22:58:48 +0100

The backlight_device_unregister() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index eb83b28..6a9a881 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -682,8 +682,7 @@ static int dcon_remove(struct i2c_client *client)
 
 	free_irq(DCON_IRQ, dcon);
 
-	if (dcon->bl_dev)
-		backlight_device_unregister(dcon->bl_dev);
+	backlight_device_unregister(dcon->bl_dev);
 
 	if (dcon_device != NULL)
 		platform_device_unregister(dcon_device);
-- 
2.1.3

