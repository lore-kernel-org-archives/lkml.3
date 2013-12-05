Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3LEL5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:57:01 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:17572 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3LEL47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:56:59 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-pci@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        "Hanjun Guo" <guohanjun@huawei.com>
Subject: [PATCH 2/9] x86/pci: Use dev_is_pci() to check whether it is pci device
Date: Thu, 5 Dec 2013 19:54:34 +0800
Message-ID: <1386244474-28312-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI standard marco dev_is_pci() instead of directly compare
pci_bus_type to check whether it is pci device.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/x86/kernel/acpi/boot.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6c0b43b..d359d0f 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1034,9 +1034,7 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 
 	if (!acpi_ioapic)
 		return 0;
-	if (!dev)
-		return 0;
-	if (dev->bus != &pci_bus_type)
+	if (!dev || !dev_is_pci(dev))
 		return 0;
 
 	pdev = to_pci_dev(dev);
-- 
1.7.1


