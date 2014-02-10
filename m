Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaBJNbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:31:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33211 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaBJNbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:31:14 -0500
Date: Mon, 10 Feb 2014 05:31:02 -0800
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgVmlsbGUgU3lyasOkbMOk?=" <tipbot@zytor.com>
Message-ID: <tip-c71ef7b3c3be3337deaf1eb28dd26e0d5d4b4aa7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bhelgaas@google.com, ville.syrjala@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, ville.syrjala@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1391628540-23072-4-git-send-email-ville.syrjala@linux.intel.com>
References: <1391628540-23072-4-git-send-email-ville.syrjala@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/gpu:
  Print the Intel graphics stolen memory range
Git-Commit-ID: c71ef7b3c3be3337deaf1eb28dd26e0d5d4b4aa7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:31:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c71ef7b3c3be3337deaf1eb28dd26e0d5d4b4aa7
Gitweb:     http://git.kernel.org/tip/c71ef7b3c3be3337deaf1eb28dd26e0d5d4b4aa7
Author:     Ville Syrjälä <ville.syrjala@linux.intel.com>
AuthorDate: Wed, 5 Feb 2014 21:29:00 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 15:11:31 +0100

x86/gpu: Print the Intel graphics stolen memory range

Print an informative message when reserving the graphics stolen
memory region in the early quirk.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Link: http://lkml.kernel.org/r/1391628540-23072-4-git-send-email-ville.syrjala@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/early-quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 5218dd2..52f36e6 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -520,6 +520,8 @@ static void __init intel_graphics_stolen(int num, int slot, int func)
 			size = stolen_funcs->size(num, slot, func);
 			start = stolen_funcs->base(num, slot, func, size);
 			if (size && start) {
+				printk(KERN_INFO "Reserving Intel graphics stolen memory at 0x%x-0x%x\n",
+				       start, start + (u32)size - 1);
 				/* Mark this space as reserved */
 				e820_add_region(start, size, E820_RESERVED);
 				sanitize_e820_map(e820.map,
