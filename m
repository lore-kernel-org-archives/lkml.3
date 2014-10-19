Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaJSBq5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 21:46:57 -0400
Received: from numascale.com ([213.162.240.84]:39347 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbaJSBqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 21:46:55 -0400
From: Daniel J Blueman <daniel@numascale.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Daniel J Blueman <daniel@numascale.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH v2 1/5] Numachip: Fix build failure with trunk GCC
Date: Sun, 19 Oct 2014 09:45:48 +0800
Message-Id: <1413683152-31302-1-git-send-email-daniel@numascale.com>
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

Fix APIC declaration to be consistent with definition; this addresses
a compilation failure with the development branch of GCC, see:
https://bugzilla.kernel.org/show_bug.cgi?id=78251

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
---
 arch/x86/kernel/apic/apic_numachip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index ae91539..81d70ba 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -32,7 +32,7 @@
 
 static int numachip_system __read_mostly;
 
-static const struct apic apic_numachip __read_mostly;
+static const struct apic apic_numachip __refconst;
 
 static unsigned int get_apic_id(unsigned long x)
 {
-- 
1.9.1

