Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab3LTFiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 00:38:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:63643 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab3LTFiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 00:38:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,518,1384329600"; 
   d="scan'208";a="455297469"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH 1/2] x86: intel-mid: return proper error code from get_gpio_by_name()
Date: Thu, 19 Dec 2013 21:42:58 -0800
Message-Id: <1387518179-4316-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1387244246-20714-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1387244246-20714-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_gpio_by_name() should return an error code instead of hardcoded -1.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/platform/intel-mid/sfi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 80a52288555c..c67b9a2f48a1 100644
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

