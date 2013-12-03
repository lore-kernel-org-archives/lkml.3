Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab3LCPuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:50:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:15163 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab3LCPuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:50:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,818,1378882800"; 
   d="scan'208";a="446080269"
From: ville.syrjala@linux.intel.com
To: intel-gfx@lists.freedesktop.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] x86: Print the Intel graphcis stolen memory range
Date: Tue,  3 Dec 2013 17:49:50 +0200
Message-Id: <1386085793-317-4-git-send-email-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386085793-317-1-git-send-email-ville.syrjala@linux.intel.com>
References: <1386085793-317-1-git-send-email-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Print an informative message when reserving the graphics stolen
memory region in the early quirk.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 arch/x86/kernel/early-quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 66357bf..d15e087 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -527,6 +527,8 @@ static void __init intel_graphics_stolen(int num, int slot, int func)
 			size = stolen_funcs->size(num, slot, func);
 			start = stolen_funcs->base(num, slot, func, size);
 			if (size && start) {
+				printk(KERN_INFO "Reserving Intel graphics stolen memory at 0x%x-0x%x\n",
+				       start, start + (u32)size - 1);
 				/* Mark this space as reserved */
 				e820_add_region(start, size, E820_RESERVED);
 				sanitize_e820_map(e820.map,
-- 
1.8.3.2

