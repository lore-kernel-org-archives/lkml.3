Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3JXHBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:01:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:39589 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab3JXHBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:01:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,560,1378882800"; 
   d="scan'208";a="416191202"
From: tianyu.lan@intel.com
To: mingo@kernel.org, hpa@zytor.com, x86@kernel.org, holt@sgi.com,
        davej@fedoraproject.org, lenb@kernel.org, rjw@rjwysocki.net,
        awilliam@redhat.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86/ACPI: Make Sony Vaio Z1 series to use "reboot=pci" default
Date: Thu, 24 Oct 2013 14:49:37 +0800
Message-Id: <1382597377-26797-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

Sony Vaio Z1 series require "reboot=pci" for reboot and power off.
This patch is to add them machines to quirk table and set pci reboot
default.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=61721
Reported-and-tested-by: Adam Williamson <awilliam@redhat.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 7e920bf..083ade7 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -382,6 +382,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
 		},
 	},
+	{	/* Handle problems with rebooting on Sony Vaio Z1 series*/
+		.callback = set_pci_reboot,
+		.ident = "Sony Vaio Z1",
+		.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCZ1"),
+		},
+	},
 	{ }
 };
 
-- 
1.7.9.5

