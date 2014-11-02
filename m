Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaKBIKs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 03:10:48 -0500
Received: from numascale.com ([213.162.240.84]:59356 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbaKBIKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 03:10:46 -0500
From: Daniel J Blueman <daniel@numascale.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Daniel J Blueman <daniel@numascale.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH v3 2/5] Numachip: Elide self-IPI ICR polling
Date: Sun,  2 Nov 2014 16:10:10 +0800
Message-Id: <1414915813-2462-2-git-send-email-daniel@numascale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414915813-2462-1-git-send-email-daniel@numascale.com>
References: <1414915813-2462-1-git-send-email-daniel@numascale.com>
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

The default self-IPI path polls the ICR to delay sending the IPI until
there is no IPI in progress. This is redundant on x86-86 APICs, since
IPIs are queued. See the AMD64 Architecture Programmer's Manual, vol 2,
p525.

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
---
 arch/x86/kernel/apic/apic_numachip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 81d70ba..bd083c0 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -145,7 +145,7 @@ static void numachip_send_IPI_all(int vector)
 
 static void numachip_send_IPI_self(int vector)
 {
-	__default_send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
+	apic_write(APIC_SELF_IPI, vector);
 }
 
 static int __init numachip_probe(void)
-- 
1.9.1

