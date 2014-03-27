Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaC0Hp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 03:45:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:32183 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbaC0Hp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 03:45:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,739,1389772800"; 
   d="scan'208";a="508734712"
From: Feng Tang <feng.tang@intel.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH] x86: hpet: Don't default CONFIG_HPET_TIMER to be y for X86_64
Date: Thu, 27 Mar 2014 15:45:09 +0800
Message-Id: <1395906309-7519-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On many new phone/tablet platforms like Baytrail/Merrifield etc,
the HPET are either defeatured or has some problem to be used
as a reliable timer. As these platforms also have X86_64, we
should not make HPET_TIMER default y for all X86_64.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..269bd47 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -695,8 +695,7 @@ config X86_CYCLONE_TIMER
 source "arch/x86/Kconfig.cpu"
 
 config HPET_TIMER
-	def_bool X86_64
-	prompt "HPET Timer Support" if X86_32
+	prompt "HPET Timer Support"
 	---help---
 	  Use the IA-PC HPET (High Precision Event Timer) to manage
 	  time in preference to the PIT and RTC, if a HPET is
-- 
1.7.0.4

