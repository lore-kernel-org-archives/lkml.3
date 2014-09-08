Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaIHTBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:01:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58998 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbaIHTBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:01:32 -0400
Date: Mon, 8 Sep 2014 12:01:12 -0700
From: tip-bot for Mathias Krause <tipbot@zytor.com>
Message-ID: <tip-8a5a5d1530d55e367ef29c80946d0274717617bb@git.kernel.org>
Cc: arjan.van.de.ven@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, minipli@googlemail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan.van.de.ven@intel.com, minipli@googlemail.com, tglx@linutronix.de
In-Reply-To: <1410114629-24523-1-git-send-email-minipli@googlemail.com>
References: <1410114629-24523-1-git-send-email-minipli@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64, ptdump:
  Mark espfix area only if existent
Git-Commit-ID: 8a5a5d1530d55e367ef29c80946d0274717617bb
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

Commit-ID:  8a5a5d1530d55e367ef29c80946d0274717617bb
Gitweb:     http://git.kernel.org/tip/8a5a5d1530d55e367ef29c80946d0274717617bb
Author:     Mathias Krause <minipli@googlemail.com>
AuthorDate: Sun, 7 Sep 2014 20:30:29 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 8 Sep 2014 11:57:34 -0700

x86-64, ptdump: Mark espfix area only if existent

We should classify the espfix area as such only if we actually have
enabled the corresponding option. Otherwise the page table dump might
look confusing.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Link: http://lkml.kernel.org/r/1410114629-24523-1-git-send-email-minipli@googlemail.com
Cc: Arjan van de Ven <arjan.van.de.ven@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/dump_pagetables.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 167ffca..95a427e 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -48,7 +48,9 @@ enum address_markers_idx {
 	LOW_KERNEL_NR,
 	VMALLOC_START_NR,
 	VMEMMAP_START_NR,
+# ifdef CONFIG_X86_ESPFIX64
 	ESPFIX_START_NR,
+# endif
 	HIGH_KERNEL_NR,
 	MODULES_VADDR_NR,
 	MODULES_END_NR,
@@ -71,7 +73,9 @@ static struct addr_marker address_markers[] = {
 	{ PAGE_OFFSET,		"Low Kernel Mapping" },
 	{ VMALLOC_START,        "vmalloc() Area" },
 	{ VMEMMAP_START,        "Vmemmap" },
+# ifdef CONFIG_X86_ESPFIX64
 	{ ESPFIX_BASE_ADDR,	"ESPfix Area", 16 },
+# endif
 	{ __START_KERNEL_map,   "High Kernel Mapping" },
 	{ MODULES_VADDR,        "Modules" },
 	{ MODULES_END,          "End Modules" },
