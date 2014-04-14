Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaDNJEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:04:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:58664 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaDNJEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:04:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,856,1389772800"; 
   d="scan'208";a="492478818"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: hpa@zytor.com, tony.luck@intel.com
Cc: tglx@linutronix.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [PATCH 1/2] x86, CMCI: Fix a missed put_cpu_var
Date: Mon, 14 Apr 2014 04:39:36 -0400
Message-Id: <1397464777-25451-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <tip-27f6c573e0f77f7d1cc907c1494c99a61e48b7d8@git.kernel.org>
References: <tip-27f6c573e0f77f7d1cc907c1494c99a61e48b7d8@git.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue is introduced in commit 27f6c573e0. I forget to
execute put_cpu_var operation after get_cpu_var.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index eeee23f..26eaf3b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -620,6 +620,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 
 		v = &get_cpu_var(mce_polled_error);
 		set_bit(0, v);
+		put_cpu_var(mce_polled_error);
 		/*
 		 * Uncorrected or signalled events are handled by the exception
 		 * handler when it is enabled, so don't process those here.
-- 
1.9.0

