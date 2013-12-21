Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3LUBKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 20:10:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:19751 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab3LUBKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 20:10:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,524,1384329600"; 
   d="scan'208";a="428104821"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, david.a.cohen@linux.intel.com
Subject: [PATCH v2 3/3] x86: intel-mid: return proper error code from get_gpio_by_name()
Date: Fri, 20 Dec 2013 17:15:13 -0800
Message-Id: <1387588513-25701-4-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1387588513-25701-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1387518179-4316-1-git-send-email-david.a.cohen@linux.intel.com>
 <1387588513-25701-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_gpio_by_name() should return an error code instead of hardcoded -1.

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

