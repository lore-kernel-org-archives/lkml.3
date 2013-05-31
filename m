Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3EaMvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:51:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58008 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab3EaMvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:51:44 -0400
Date: Fri, 31 May 2013 05:51:30 -0700
From: tip-bot for Paul Bolle <tipbot@zytor.com>
Message-ID: <tip-71c69f7f4b67150e10cdfcad217d464f1821b3c6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, pebolle@tiscali.nl, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, pebolle@tiscali.nl,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1369853850.23034.28.camel@x61.thuisdomein>
References: <1369853850.23034.28.camel@x61.thuisdomein>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86/mce:
  Remove check for CONFIG_X86_MCE_P4THERMAL
Git-Commit-ID: 71c69f7f4b67150e10cdfcad217d464f1821b3c6
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

Commit-ID:  71c69f7f4b67150e10cdfcad217d464f1821b3c6
Gitweb:     http://git.kernel.org/tip/71c69f7f4b67150e10cdfcad217d464f1821b3c6
Author:     Paul Bolle <pebolle@tiscali.nl>
AuthorDate: Wed, 29 May 2013 20:57:30 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 31 May 2013 13:12:35 +0200

x86/mce: Remove check for CONFIG_X86_MCE_P4THERMAL

The Kconfig symbol X86_MCE_P4THERMAL was removed in v2.6.32.
Remove a useless check for its macro, as it will now always
evaluate to false.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Link: http://lkml.kernel.org/r/1369853850.23034.28.camel@x61.thuisdomein
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
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
