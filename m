Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaKDRWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:22:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60066 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbaKDRV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:21:56 -0500
Date: Tue, 4 Nov 2014 09:21:37 -0800
From: tip-bot for Daniel J Blueman <tipbot@zytor.com>
Message-ID: <tip-00e7977dd1bbd46e336d7ef907d0fb6b6a4c294f@git.kernel.org>
Cc: mingo@kernel.org, daniel@numascale.com, sp@numascale.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, bhelgaas@google.com,
        hpa@zytor.com
Reply-To: tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        bhelgaas@google.com, mingo@kernel.org, daniel@numascale.com,
        sp@numascale.com
In-Reply-To: <1415089784-28779-1-git-send-email-daniel@numascale.com>
References: <1415089784-28779-1-git-send-email-daniel@numascale.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: numachip: Fix 16-bit APIC ID truncation
Git-Commit-ID: 00e7977dd1bbd46e336d7ef907d0fb6b6a4c294f
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

Commit-ID:  00e7977dd1bbd46e336d7ef907d0fb6b6a4c294f
Gitweb:     http://git.kernel.org/tip/00e7977dd1bbd46e336d7ef907d0fb6b6a4c294f
Author:     Daniel J Blueman <daniel@numascale.com>
AuthorDate: Tue, 4 Nov 2014 16:29:41 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Nov 2014 18:17:27 +0100

x86: numachip: Fix 16-bit APIC ID truncation

Prevent 16-bit APIC IDs being truncated by using correct mask. This fixes
booting large systems, where the wrong core would receive the startup and
init IPIs, causing hanging.

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
Cc: Steffen Persvold <sp@numascale.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Link: http://lkml.kernel.org/r/1415089784-28779-1-git-send-email-daniel@numascale.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic_numachip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 4128b5f..2aaee79 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -40,7 +40,7 @@ static unsigned int get_apic_id(unsigned long x)
 	unsigned int id;
 
 	rdmsrl(MSR_FAM10H_NODE_ID, value);
-	id = ((x >> 24) & 0xffU) | ((value << 2) & 0x3f00U);
+	id = ((x >> 24) & 0xffU) | ((value << 2) & 0xff00U);
 
 	return id;
 }
