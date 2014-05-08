Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbaEHKqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:46:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33360 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaEHKqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:46:17 -0400
Date: Thu, 8 May 2014 03:45:46 -0700
From: tip-bot for Feng Tang <tipbot@zytor.com>
Message-ID: <tip-f10f383d8414bfe3357e24432ed8a26eeb58ffb8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, john.stultz@linaro.org,
        tglx@linutronix.de, feng.tang@intel.com, clemens@ladisch.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, john.stultz@linaro.org,
        tglx@linutronix.de, feng.tang@intel.com, clemens@ladisch.de
In-Reply-To: <1398327498-13163-1-git-send-email-feng.tang@intel.com>
References: <1398327498-13163-1-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/hpet: Make boot_hpet_disable extern
Git-Commit-ID: f10f383d8414bfe3357e24432ed8a26eeb58ffb8
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

Commit-ID:  f10f383d8414bfe3357e24432ed8a26eeb58ffb8
Gitweb:     http://git.kernel.org/tip/f10f383d8414bfe3357e24432ed8a26eeb58ffb8
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Thu, 24 Apr 2014 16:18:17 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 8 May 2014 08:15:34 +0200

x86/hpet: Make boot_hpet_disable extern

HPET on some platform has accuracy problem. Making
"boot_hpet_disable" extern so that we can runtime disable
the HPET timer by using quirk to check the platform.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1398327498-13163-1-git-send-email-feng.tang@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/hpet.h | 1 +
 arch/x86/kernel/hpet.c      | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index b18df57..36f7125 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -63,6 +63,7 @@
 /* hpet memory map physical address */
 extern unsigned long hpet_address;
 extern unsigned long force_hpet_address;
+extern int boot_hpet_disable;
 extern u8 hpet_blockid;
 extern int hpet_force_user;
 extern u8 hpet_msi_disable;
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 8d80ae0..4177bfb 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -88,7 +88,7 @@ static inline void hpet_clear_mapping(void)
 /*
  * HPET command line enable / disable
  */
-static int boot_hpet_disable;
+int boot_hpet_disable;
 int hpet_force_user;
 static int hpet_verbose;
 
