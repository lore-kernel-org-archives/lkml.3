Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3EYNwG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 09:52:06 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:64741 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab3EYNwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 09:52:00 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Donald Dutile <ddutile@redhat.com>, Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH v3, part1 08/10] PCI, IOV: don't touch bus->is_added flag
Date: Sat, 25 May 2013 21:48:36 +0800
Message-Id: <1369489718-25869-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com>
References: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flag pci_bus->is_added is used to guard invoke of
pcibios_fixup_bus(pci_bus). And when virtfn_add_bus() is called,
pci_bus->is_added flag has already been set, so remove the redandunt
	bus->is_added = 1;

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Donald Dutile <ddutile@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/iov.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 2652ca0..8f1e117 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -47,7 +47,6 @@ static struct pci_bus *virtfn_add_bus(struct pci_bus *bus, int busnr)
 		return NULL;
 
 	pci_bus_insert_busn_res(child, busnr, busnr);
-	bus->is_added = 1;
 
 	return child;
 }
-- 
1.8.1.2

