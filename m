Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaDNHXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:23:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaDNHXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:23:04 -0400
Date: Mon, 14 Apr 2014 00:22:42 -0700
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgVmlsbGUgU3lyasOkbMOk?=" <tipbot@zytor.com>
Message-ID: <tip-86e587623a0ca8426267dad8d3eaebd6fc2d00f1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bhelgaas@google.com, ville.syrjala@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, ville.syrjala@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1397382303-17525-1-git-send-email-ville.syrjala@linux.intel.com>
References: <1397382303-17525-1-git-send-email-ville.syrjala@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/gpu:
  Fix sign extension issue in Intel graphics stolen memory quirks
Git-Commit-ID: 86e587623a0ca8426267dad8d3eaebd6fc2d00f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86e587623a0ca8426267dad8d3eaebd6fc2d00f1
Gitweb:     http://git.kernel.org/tip/86e587623a0ca8426267dad8d3eaebd6fc2d00f1
Author:     Ville Syrjälä <ville.syrjala@linux.intel.com>
AuthorDate: Sun, 13 Apr 2014 12:45:03 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 14 Apr 2014 08:50:56 +0200

x86/gpu: Fix sign extension issue in Intel graphics stolen memory quirks

Have the KB(),MB(),GB() macros produce unsigned longs to avoid
unintended sign extension issues with the gen2 memory size
detection.

What happens is first the uint8_t returned by
read_pci_config_byte() gets promoted to an int which gets
multiplied by another int from the MB() macro, and finally the
result gets sign extended to size_t.

Although this shouldn't be a problem in practice as all affected
gen2 platforms are 32bit AFAIK, so size_t will be 32 bits.

Reported-by: Bjorn Helgaas <bhelgaas@google.com>
Suggested-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/r/1397382303-17525-1-git-send-email-ville.syrjala@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/early-quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index b0cc380..6e2537c 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -240,7 +240,7 @@ static u32 __init intel_stolen_base(int num, int slot, int func, size_t stolen_s
 	return base;
 }
 
-#define KB(x)	((x) * 1024)
+#define KB(x)	((x) * 1024UL)
 #define MB(x)	(KB (KB (x)))
 #define GB(x)	(MB (KB (x)))
 
