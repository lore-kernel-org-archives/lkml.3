Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3ARQI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 11:08:29 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:45604 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3ARQI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 11:08:26 -0500
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [RFC PATCH v5 6/8] pci_slot: replace printk(KERN_xxx) with pr_xxx()
Date: Sat, 19 Jan 2013 00:07:44 +0800
Message-Id: <1358525267-14268-7-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial changes to replace printk(KERN_xxx) with pr_xxx().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/acpi/pci_slot.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index 2b38f4d..3b821db 100644
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -52,13 +52,12 @@ module_param(debug, bool, 0644);
 ACPI_MODULE_NAME("pci_slot");
 
 #define MY_NAME "pci_slot"
-#define err(format, arg...) printk(KERN_ERR "%s: " format , MY_NAME , ## arg)
-#define info(format, arg...) printk(KERN_INFO "%s: " format , MY_NAME , ## arg)
+#define err(format, arg...) pr_err("%s: " format , MY_NAME , ## arg)
+#define info(format, arg...) pr_info("%s: " format , MY_NAME , ## arg)
 #define dbg(format, arg...)					\
 	do {							\
 		if (debug)					\
-			printk(KERN_DEBUG "%s: " format,	\
-				MY_NAME , ## arg);		\
+			pr_debug("%s: " format,	MY_NAME , ## arg); \
 	} while (0)
 
 #define SLOT_NAME_SIZE 21		/* Inspired by #define in acpiphp.h */
-- 
1.7.9.5

