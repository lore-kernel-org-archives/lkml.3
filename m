Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbaGTFre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 01:47:34 -0400
Received: from m12-16.163.com ([220.181.12.16]:51504 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbaGTFrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 01:47:33 -0400
X-Coremail-DSSMTP: 180.110.162.144
From: weiyj_lk@163.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH] xen/pciback: Fix error return code in xen_pcibk_attach()
Date: Sun, 20 Jul 2014 13:46:01 +0800
Message-Id: <1405835161-8546-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EMCowECZAESlV8tTZ9UDCA--.236S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7WryUGw4furWfCF17GrWDXFb_yoWxKFc_ua
	98WrZrur4YqFZrt34v9398ZrySyFyqvFWrW3ZrKFySyw4qkr48Z39rZFs5Jr4UKrZ8JFsI
	ya1jqryfGF1xAjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUY3MaUUUUUU==
X-Originating-IP: [180.110.162.144]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbioxbO1lD+VZoV0QABsJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -EFAULT from the error handling case instead of 0 when
version mismatch with pcifront.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/xen/xen-pciback/xenbus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index 4a7e6e0..c214daa 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -174,6 +174,7 @@ static int xen_pcibk_attach(struct xen_pcibk_device *pdev)
 				 "version mismatch (%s/%s) with pcifront - "
 				 "halting " DRV_NAME,
 				 magic, XEN_PCI_MAGIC);
+		err = -EFAULT;
 		goto out;
 	}
 

