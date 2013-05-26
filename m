Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3EZQB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 12:01:56 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35911 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab3EZP5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 11:57:35 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-alpha@vger.kernel.org
Subject: [PATCH v3, part2 05/20] PCI, Alpha: use hotplug-safe iterators to walk PCI buses
Date: Sun, 26 May 2013 23:53:02 +0800
Message-Id: <1369583597-3801-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance Alpha architecture specific code to use hotplug-safe iterators
to walk PCI buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-alpha@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/alpha/kernel/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
index edb4e00..094cd58 100644
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -305,7 +305,7 @@ pcibios_claim_console_setup(void)
 {
 	struct pci_bus *b;
 
-	list_for_each_entry(b, &pci_root_buses, node)
+	for_each_pci_root_bus(b)
 		pcibios_claim_one_bus(b);
 }
 
-- 
1.8.1.2

