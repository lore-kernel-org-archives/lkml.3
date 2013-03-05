Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3CEQrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:47:19 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:47379 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3CEQrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:47:18 -0500
Date: Wed, 6 Mar 2013 00:48:06 +0800
From: Wang YanQing <udknight@gmail.com>
To: hpa@zytor.com
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2]x86:boot: Remove unneccessary headers
Message-ID: <20130305164806.GA8515@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, hpa@zytor.com,
	tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm/segment.h come from setup.S:
we used to need GDT_ENTRY_BOOT_CS
to setup gdt, but now we don't need it,
boot_gdt had been moved to kernel/head_32.S

generated/utsrelease.h come from setup.S:
we used to define kernel_version in setup.S,
but we don't need it now, because the
definition of kernel_version had been move
to boot/version.c

asm/e820.h come from setup.S:
we used to do the memory detect in setup.S,
but we don't need it now, because
we do memory detect in boot/memory.c

I can't finger out the commits import the changes
above, because all the changes happened before git
epoch :)

asm/page_types.h come from setup.S:
we used to need the __PAGE_OFFSET define
in page_types.h to compute ramdisk_max,
but now we don't need it in header.S anymore,
cf8fa920c(i386: handle an initrd in highmem (version 2))
remove it.

This patch remove the unneeded head files included
in header.S.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
Changes:
V1-V2:
1:add more detail and long long log

 arch/x86/boot/header.S | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 9ec06a1..43a3502 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -15,11 +15,7 @@
  *
  */
 
-#include <asm/segment.h>
-#include <generated/utsrelease.h>
 #include <asm/boot.h>
-#include <asm/e820.h>
-#include <asm/page_types.h>
 #include <asm/setup.h>
 #include <asm/bootparam.h>
 #include "boot.h"
-- 
1.7.12.4.dirty
