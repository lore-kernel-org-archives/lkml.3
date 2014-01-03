Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750959AbaACDzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 22:55:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaACDzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 22:55:21 -0500
Date: Fri, 3 Jan 2014 11:54:31 +0800
From: Dave Young <dyoung@redhat.com>
To: matt@console-pimps.org, hpa@zytor.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        kexec@lists.infradead.org
Subject: [PATCH tip/efi-kexec] x86: ksysfs.c build fix
Message-ID: <20140103035431.GA5259@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild test robot report below error for randconfig:

   arch/x86/kernel/ksysfs.c: In function 'get_setup_data_paddr':
>> arch/x86/kernel/ksysfs.c:81:3: error: implicit declaration of function 'ioremap_cache' [-Werror=implicit-function-declaration]
      data = ioremap_cache(pa_data, sizeof(*data));
      ^
>> arch/x86/kernel/ksysfs.c:86:3: error: implicit declaration of function 'iounmap' [-Werror=implicit-function-declaration]
      iounmap(data);
      ^
Fix it by including <asm/io.h> in ksysfs.c

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/kernel/ksysfs.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86/kernel/ksysfs.c
===================================================================
--- linux.orig/arch/x86/kernel/ksysfs.c
+++ linux/arch/x86/kernel/ksysfs.c
@@ -16,6 +16,7 @@
 #include <linux/stat.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <asm/io.h>
 
 #include <asm/setup.h>
 
