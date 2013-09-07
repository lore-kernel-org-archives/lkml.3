Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab3IGIYF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 04:24:05 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:40311 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3IGIYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 04:24:03 -0400
Message-ID: <522AE0FD.4030502@gmail.com>
Date: Sat, 07 Sep 2013 10:17:01 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/19] pramfs: add x86 set_memory_{rw|ro} flag
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a flag to x86 arch to know if a set_memory_{rw|ro} is supported.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 arch/Kconfig     |    3 +++
 arch/x86/Kconfig |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 1feb169..589a043 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -171,6 +171,9 @@ config USER_RETURN_NOTIFIER
 config HAVE_IOREMAP_PROT
 	bool
 
+config HAVE_SET_MEMORY_RO
+	bool
+
 config HAVE_KPROBES
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5c0ed72..c500462 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -30,6 +30,7 @@ config X86
 	select HAVE_OPROFILE
 	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
+	select HAVE_SET_MEMORY_RO
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select HAVE_MEMBLOCK
-- 
1.7.3.4
