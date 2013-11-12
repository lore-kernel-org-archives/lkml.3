Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab3KLWJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:09:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:4632 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786Ab3KLWJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 17:09:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434167695"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH 2/3] x86: intel-mid: struct devs_id.name should have 'SFI_NAME_LEN' length
Date: Tue, 12 Nov 2013 14:13:39 -0800
Message-Id: <1384294420-9124-3-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384294420-9124-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1384294420-9124-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes struct devs_id.name to match size of
struct sfi_device_table_entry.size.
Correct size if SFI_NAME_LEN instead of SFI_NAME_LEN + 1.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/include/asm/intel-mid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/intel-mid.h b/arch/x86/include/asm/intel-mid.h
index c810abd5178c..971cbb1abab3 100644
--- a/arch/x86/include/asm/intel-mid.h
+++ b/arch/x86/include/asm/intel-mid.h
@@ -28,7 +28,7 @@ extern struct sfi_rtc_table_entry sfi_mrtc_array[];
  * its platform data.
  */
 struct devs_id {
-	char name[SFI_NAME_LEN + 1];
+	char name[SFI_NAME_LEN];
 	u8 type;
 	u8 delay;
 	void *(*get_platform_data)(void *info);
-- 
1.8.4.2

