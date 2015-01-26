Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbbAZXaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:30:18 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:54950 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbbAZXaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:30:08 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, arnd@arndb.de, linux-mm@kvack.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 7/7] mm: Add config HUGE_IOMAP to enable huge I/O mappings
Date: Mon, 26 Jan 2015 16:13:29 -0700
Message-Id: <1422314009-31667-8-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
References: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add config HUGE_IOMAP to enable huge I/O mappings.  This feature
is set to Y by default when HAVE_ARCH_HUGE_VMAP is defined on the
architecture.

Note, user can also disable this feature at boot-time by the kernel
option "nohgiomap" if necessary.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 mm/Kconfig |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index 1d1ae6b..eb738ae 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -444,6 +444,17 @@ choice
 	  benefit.
 endchoice
 
+config HUGE_IOMAP
+	bool "Kernel huge I/O mapping support"
+	depends on HAVE_ARCH_HUGE_VMAP
+	default y
+	help
+	  Kernel huge I/O mapping allows the kernel to transparently
+	  create I/O mappings with huge pages for memory-mapped I/O
+	  devices whenever possible.  This feature can improve
+	  performance of certain devices with large memory size, such
+	  as NVM, and reduce the time to create their mappings.
+
 #
 # UP and nommu archs use km based percpu allocator
 #
