Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3A3BlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:41:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43879 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3A3BlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:41:11 -0500
Date: Tue, 29 Jan 2013 17:40:59 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-577af55d802d9fe114287e750504e09e7c677c9c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        ebiederm@xmission.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        ebiederm@xmission.com
In-Reply-To: <1359058816-7615-22-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-22-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, kexec:
  Remove 1024G limitation for kexec buffer on 64bit
Git-Commit-ID: 577af55d802d9fe114287e750504e09e7c677c9c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:41:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  577af55d802d9fe114287e750504e09e7c677c9c
Gitweb:     http://git.kernel.org/tip/577af55d802d9fe114287e750504e09e7c677c9c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:20:02 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:26:23 -0800

x86, kexec: Remove 1024G limitation for kexec buffer on 64bit

Now 64bit kernel supports more than 1T ram and kexec tools
could find buffer above 1T, remove that obsolete limitation.
and use MAXMEM instead.

Tested on system with more than 1024G ram.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-22-git-send-email-yinghai@kernel.org
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/kexec.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 6080d26..17483a4 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -48,11 +48,11 @@
 # define vmcore_elf_check_arch_cross(x) ((x)->e_machine == EM_X86_64)
 #else
 /* Maximum physical address we can use pages from */
-# define KEXEC_SOURCE_MEMORY_LIMIT      (0xFFFFFFFFFFUL)
+# define KEXEC_SOURCE_MEMORY_LIMIT      (MAXMEM-1)
 /* Maximum address we can reach in physical address mode */
-# define KEXEC_DESTINATION_MEMORY_LIMIT (0xFFFFFFFFFFUL)
+# define KEXEC_DESTINATION_MEMORY_LIMIT (MAXMEM-1)
 /* Maximum address we can use for the control pages */
-# define KEXEC_CONTROL_MEMORY_LIMIT     (0xFFFFFFFFFFUL)
+# define KEXEC_CONTROL_MEMORY_LIMIT     (MAXMEM-1)
 
 /* Allocate one page for the pdp and the second for the code */
 # define KEXEC_CONTROL_PAGE_SIZE  (4096UL + 4096UL)
