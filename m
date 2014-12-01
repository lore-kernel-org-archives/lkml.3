Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaLAEup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 23:50:45 -0500
Received: from mout.web.de ([212.227.15.3]:58013 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaLAEun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 23:50:43 -0500
Message-ID: <547BF398.8010407@users.sourceforge.net>
Date: Mon, 01 Dec 2014 05:50:32 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>, Zhang Rui <rui.zhang@intel.com>,
        linux-pm@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] thermal: int3403: Delete a check before thermal_zone_device_unregister()
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:dh205Xqkr0l+fdruVsdAI/rhDcJZ2s6ONwSmlntGlzF2yDb1//v
 9iCogSig33PPx8aXd6/af1YpdpiMxhnnna11MdKo0QTR2nz7lxP0sYyyPw1DebY/ZMHDAEc
 LIUAfowfsP6nVqgf8BQ6sfMYf4RohfxDpXkhht7myTk/oKp5pM13O9RHcMoObmKKPVKn4Fq
 +9MTiGDds3gZRl+9fmOJA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 1 Dec 2014 05:45:42 +0100

The thermal_zone_device_unregister() function tests whether its argument
is NULL and then returns immediately. Thus the test around the call
is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/thermal/int340x_thermal/int3403_thermal.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/thermal/int340x_thermal/int3403_thermal.c b/drivers/thermal/int340x_thermal/int3403_thermal.c
index 6e9fb62..790b8f6 100644
--- a/drivers/thermal/int340x_thermal/int3403_thermal.c
+++ b/drivers/thermal/int340x_thermal/int3403_thermal.c
@@ -293,8 +293,7 @@ static int int3403_sensor_add(struct int3403_priv *priv)
 	return 0;
 
  err_free_obj:
-	if (obj->tzone)
-		thermal_zone_device_unregister(obj->tzone);
+	thermal_zone_device_unregister(obj->tzone);
 	return result;
 }
 
-- 
2.1.3

