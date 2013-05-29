Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965918Ab3E2S5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:57:39 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:61158 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965553Ab3E2S5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:57:33 -0400
Message-ID: <1369853850.23034.28.camel@x61.thuisdomein>
Subject: [PATCH] x86: Remove check for CONFIG_X86_MCE_P4THERMAL
From: Paul Bolle <pebolle@tiscali.nl>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 29 May 2013 20:57:30 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2013 18:57:31.0327 (UTC) FILETIME=[5F4504F0:01CE5C9E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol X86_MCE_P4THERMAL was removed in v2.6.32. Remove a
useless check for its macro, as it will now always evaluate to false.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Entirely untested.

 arch/x86/kernel/apic/apic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 904611b..1600b1c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2302,7 +2302,7 @@ static void lapic_resume(void)
 	apic_write(APIC_SPIV, apic_pm_state.apic_spiv);
 	apic_write(APIC_LVT0, apic_pm_state.apic_lvt0);
 	apic_write(APIC_LVT1, apic_pm_state.apic_lvt1);
-#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
+#if defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5)
 		apic_write(APIC_LVTTHMR, apic_pm_state.apic_thmr);
 #endif
-- 
1.7.11.7

