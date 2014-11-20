Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbaKTOZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:25:46 -0500
Received: from mout.web.de ([212.227.15.3]:63252 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140AbaKTOZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:25:43 -0500
Message-ID: <546DF9D7.6080801@users.sourceforge.net>
Date: Thu, 20 Nov 2014 15:25:27 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org,
        netdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] net: Hyper-V: Deletion of an unnecessary check before
 the function call "vfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:CGH1CZHAK29iklR+VssNYWCP/ZGHlKxMce3Zxl2oSv9evPZvwnT
 bhkiMFAiJxj91A1GReH8g7LnzMASF5y9fKq6/gv3vYjxYj2JvUl3qatL2ohSufT/aRfupql
 Qv6IdYFAf5gOpGXjnE+Rofhhs84sIyAFN4hcNIIzhaIYHS1Q2JQnyxcbO8icx11SGszedsC
 VL0BRG63p7Q82DNjraRgg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 15:15:21 +0100

The vfree() function performs also input parameter validation. Thus the test
around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/hyperv/netvsc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index da2d346..ffe7481 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -548,8 +548,7 @@ int netvsc_device_remove(struct hv_device *device)
 	vmbus_close(device->channel);
 
 	/* Release all resources */
-	if (net_device->sub_cb_buf)
-		vfree(net_device->sub_cb_buf);
+	vfree(net_device->sub_cb_buf);
 
 	kfree(net_device);
 	return 0;
-- 
2.1.3

