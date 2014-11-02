Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaKBIKu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 03:10:50 -0500
Received: from numascale.com ([213.162.240.84]:36026 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbaKBIKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 03:10:46 -0500
From: Daniel J Blueman <daniel@numascale.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Daniel J Blueman <daniel@numascale.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH v3 1/5] Numachip: Fix 16-bit APIC ID truncation
Date: Sun,  2 Nov 2014 16:10:09 +0800
Message-Id: <1414915813-2462-1-git-send-email-daniel@numascale.com>
X-Mailer: git-send-email 1.9.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent 16-bit APIC IDs being truncated by using correct mask. This fixes
booting large systems, where the wrong core would receive the startup and
init IPIs, causing hanging.

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
---
 arch/x86/kernel/apic/apic_numachip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 81d70ba..bd083c0 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -40,7 +40,7 @@ static unsigned int get_apic_id(unsigned long x)
 	unsigned int id;
 
 	rdmsrl(MSR_FAM10H_NODE_ID, value);
-	id = ((x >> 24) & 0xffU) | ((value << 2) & 0x3f00U);
+	id = ((x >> 24) & 0xffU) | ((value << 2) & 0xff00U);
 
 	return id;
 }
-- 
1.9.1

