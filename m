Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbbAVO3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:29:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57959 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbbAVO3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:29:30 -0500
Date: Thu, 22 Jan 2015 06:29:07 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-8686608336e11276d72d020cb0b67bee70d9a5cd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, bp@alien8.de,
        jiang.liu@linux.intel.com, tony.luck@intel.com, mingo@kernel.org,
        joro@8bytes.org, hpa@zytor.com
Reply-To: linux-kernel@vger.kernel.org, tglx@linutronix.de, bp@alien8.de,
        jiang.liu@linux.intel.com, tony.luck@intel.com, mingo@kernel.org,
        joro@8bytes.org, hpa@zytor.com
In-Reply-To: <20150115211703.397170414@linutronix.de>
References: <20150115211703.397170414@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/ioapic: Provide stub functions for IOAPIC%3Dn
Git-Commit-ID: 8686608336e11276d72d020cb0b67bee70d9a5cd
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

Commit-ID:  8686608336e11276d72d020cb0b67bee70d9a5cd
Gitweb:     http://git.kernel.org/tip/8686608336e11276d72d020cb0b67bee70d9a5cd
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:30 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:55 +0100

x86/ioapic: Provide stub functions for IOAPIC%3Dn

To avoid lots of ifdeffery provide proper stubs for setup_IO_APIC(),
enable_IO_APIC() and setup_ioapic_dest().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20150115211703.397170414@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index bf006cc..2f91685 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -279,6 +279,11 @@ static inline void disable_ioapic_support(void) { }
 #define native_ioapic_set_affinity	NULL
 #define native_setup_ioapic_entry	NULL
 #define native_eoi_ioapic_pin		NULL
+
+static inline void setup_IO_APIC(void) { }
+static inline void enable_IO_APIC(void) { }
+static inline void setup_ioapic_dest(void) { }
+
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
