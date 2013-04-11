Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934232Ab3DKSpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:45:10 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:56563 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3DKSpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:45:06 -0400
MIME-Version: 1.0
Date: Fri, 12 Apr 2013 00:15:05 +0530
Message-ID: <CA+G9fYu0q31fca5yBdX1f=yhAS2B5R16S+=sK=UE=rVRG9yqrg@mail.gmail.com>
Subject: [Linaro-QA-Service] [linux-next] Snowball build broken
From: Naresh Kamboju <naresh.kamboju@linaro.org>
To: linux-kernel@vger.kernel.org,
        Lists linaro-dev <linaro-dev@lists.linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Greetings from Linaro QA services.
We have setup the process of validating Linux on ARM Kernel builds.
One of those ARM targets is Snowball. Snowball build broken log can be
found here

Build Error:
--------------
04:48:08   CC      drivers/mfd/ab8500-debugfs.o
04:48:09 /mnt/ci_build/workspace/linux-next/hwpack/snowball/label/precise_hwpack_cloud/drivers/mfd/ab8500-debugfs.c:95:23:
fatal error: mach/irqs.h: No such file or directory
04:48:09 compilation terminated.
04:48:09 make[3]: *** [drivers/mfd/ab8500-debugfs.o] Error 1
04:48:09 make[2]: *** [drivers/mfd] Error 2
04:48:09 make[1]: *** [drivers] Error 2

Code snippet:
------------------
File: drivers/mfd/ab8500-debugfs.c

 89 #ifdef CONFIG_DEBUG_FS
  90 #include <linux/string.h>
  91 #include <linux/ctype.h>
  92 #endif
  93
  94 /* TODO: this file should not reference IRQ_DB8500_AB8500! */
  95 #include <mach/irqs.h>
  96
  97 static u32 debug_bank;
  98 static u32 debug_address;
  99

Kernel Commit id:
----------------------
484eecb3dc4d7173015feeb41e2995bbcb724523

Please let me know if you need more info.

Best regards
Naresh Kamboju
