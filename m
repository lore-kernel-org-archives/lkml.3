Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaAPXCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:02:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:12166 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbaAPXCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:02:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="467941419"
From: David Cohen <david.a.cohen@linux.intel.com>
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Cc: david.a.cohen@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] x86: intel-mid: return proper error code from get_gpio_by_name()
Date: Thu, 16 Jan 2014 15:07:04 -0800
Message-Id: <1389913624-9149-4-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389913624-9149-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1389913624-9149-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does a cleanup on get_gpio_by_name().
It should return an error code instead of hardcoded -1.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/platform/intel-mid/sfi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 1d5d20b088fa..438306ebed05 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -224,7 +224,7 @@ int get_gpio_by_name(const char *name)
 		if (!strncmp(name, pentry->pin_name, SFI_NAME_LEN))
 			return pentry->pin_no;
 	}
-	return -1;
+	return -EINVAL;
 }
 
 void __init intel_scu_device_register(struct platform_device *pdev)
-- 
1.8.4.2

