Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3JWNG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:06:56 -0400
Received: from one.firstfloor.org ([193.170.194.197]:44319 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab3JWNGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:06:55 -0400
Date: Wed, 23 Oct 2013 15:06:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Joe Perches <joe@perches.com>
Cc: Andi Kleen <andi@firstfloor.org>, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Mario <jmario@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] kbuild: Increase kallsyms max symbol length v2
Message-ID: <20131023130653.GN29695@two.firstfloor.org>
References: <1382456783-22826-1-git-send-email-andi@firstfloor.org>
 <1382456783-22826-2-git-send-email-andi@firstfloor.org>
 <1382459764.2041.90.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382459764.2041.90.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Mario <jmario@redhat.com>

[AK: This seems like a ticking time bomb even without LTO,
so should be merged now. It causes very weird problems.
Thanks to Joe for tracking them down.]

With the added postfixes that LTO adds for local
symbols, the longest name in the kernel overflows
the namebuf[KSYM_NAME_LEN] array by two bytes.  That name is:
__pci_fixup_resumePCI_VENDOR_ID_SERVERWORKSPCI_DEVICE_ID_SERVERWORKS_HT1000SBquirk_disable_broadcom_boot_interrupt.1488004.672802

Double the max symbol name length.

v2: Use 255  (Joe Perches)
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/kallsyms.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 6883e19..5648870 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -9,7 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/stddef.h>
 
-#define KSYM_NAME_LEN 128
+#define KSYM_NAME_LEN 255
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
 			 2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)
 
-- 
1.8.4

-- 
ak@linux.intel.com -- Speaking for myself only.
