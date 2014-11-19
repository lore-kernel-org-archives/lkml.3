Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaKSSZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:25:58 -0500
Received: from mout.web.de ([212.227.17.11]:55723 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbaKSSZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:25:57 -0500
Message-ID: <546CE09B.9090101@users.sourceforge.net>
Date: Wed, 19 Nov 2014 19:25:31 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Hal Rosenstock <hal.rosenstock@gmail.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        linux-rdma@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] InfiniBand: Deletion of unnecessary checks before two
 function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:HCohZf6pFKPNSVAW3WfaDPLfLHxHmu7y995oGgJkrBuf7RZb9MX
 9yJgBi7uxL+v/91JUZZWnD3QXvF4FrKbLrL7AgmkJTKL6o5P/QMBQ+170J8QkCObnDe72oe
 s5dWl2Ir5OL8ek1+4bNvxNe9sQ44u2uSwesJIbHExjpoCEn7+JlfFL08cCI8TZech7M1cK3
 BW1zVKAMvfS6uWGaPXY6Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Nov 2014 19:19:21 +0100

The functions kfree() and pci_dev_put() test whether their argument is NULL
and then return immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/mlx4/main.c         | 3 +--
 drivers/infiniband/hw/mthca/mthca_reset.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 8b72cf3..50dee1a 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2512,8 +2512,7 @@ static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init)
 		if (!dm[i]) {
 			pr_err("failed to allocate memory for tunneling qp update work struct\n");
 			for (i = 0; i < dev->caps.num_ports; i++) {
-				if (dm[i])
-					kfree(dm[i]);
+				kfree(dm[i]);
 			}
 			goto out;
 		}
diff --git a/drivers/infiniband/hw/mthca/mthca_reset.c b/drivers/infiniband/hw/mthca/mthca_reset.c
index 74c6a94..c521654 100644
--- a/drivers/infiniband/hw/mthca/mthca_reset.c
+++ b/drivers/infiniband/hw/mthca/mthca_reset.c
@@ -279,8 +279,7 @@ good:
 	}
 
 out:
-	if (bridge)
-		pci_dev_put(bridge);
+	pci_dev_put(bridge);
 	kfree(bridge_header);
 	kfree(hca_header);
 
-- 
2.1.3

