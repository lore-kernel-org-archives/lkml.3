Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaKYVz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:55:57 -0500
Received: from mout.web.de ([212.227.17.12]:52582 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbaKYVzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:55:55 -0500
Message-ID: <5474FAD6.4060704@users.sourceforge.net>
Date: Tue, 25 Nov 2014 22:55:34 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, devel@linuxdriverproject.org,
        netdev@vger.kernel.org
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH v2] net: Hyper-V: Deletion of an unnecessary check before
 the function call "vfree"
References: <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>	<5317A59D.4@users.sourceforge.net>	<546DF9D7.6080801@users.sourceforge.net> <20141121.151503.1986113223309494197.davem@davemloft.net>
In-Reply-To: <20141121.151503.1986113223309494197.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:7zBNneMfQpNB66WeLKRmbmsBo5W4QfH1uN1md97Ram0E1WSfVwO
 ayDn51YQJIyDLTOSIyFok63sykNL7DmLpPlnmoXs1jEamZpWNzo1ELg/dPgHgwhnKQwrPkJ
 cXubMsK1PeAb8CGyJ5a45AC1iY9imesO4IOw35XFzv/GgkKGAv/uLIV0+GrBGVf0+RLDpSZ
 PI39PYPbIAud6rDkbK8/w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 25 Nov 2014 22:33:45 +0100

The vfree() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 6b46311..6fc834e 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -561,9 +561,7 @@ int netvsc_device_remove(struct hv_device *device)
 	vmbus_close(device->channel);
 
 	/* Release all resources */
-	if (net_device->sub_cb_buf)
-		vfree(net_device->sub_cb_buf);
-
+	vfree(net_device->sub_cb_buf);
 	free_netvsc_device(net_device);
 	return 0;
 }
-- 
2.1.3

