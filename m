Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3H2EQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 00:16:10 -0400
Received: from intranet.asianux.com ([58.214.24.6]:49321 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab3H2EQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 00:16:08 -0400
X-Spam-Score: -101.0
Message-ID: <521ECAC8.4050308@asianux.com>
Date: Thu, 29 Aug 2013 12:15:04 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/h8300/kernel/setup.c: implement default 'screen_info'
References: <521EC935.90200@asianux.com>
In-Reply-To: <521EC935.90200@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need implement default 'screen_info' just like another architectures
(tile, cris, score, sh), or can not pass compiling for defconfig:

The related error:

  drivers/video/console/vgacon.c:820: undefined reference to `screen_info'
  drivers/video/console/vgacon.c:840: undefined reference to `screen_info'
  drivers/built-in.o: In function `vgacon_init':
  drivers/video/console/vgacon.c:589: undefined reference to `screen_info'
  drivers/built-in.o: In function `vgacon_startup':
  drivers/video/console/vgacon.c:375: undefined reference to `screen_info'
  drivers/video/console/vgacon.c:387: undefined reference to `screen_info'
  drivers/built-in.o:/root/linux-next/drivers/video/console/vgacon.c:388: more undefined references to `screen_info' follow


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/h8300/kernel/setup.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
index d0b1607..488b94c 100644
--- a/arch/h8300/kernel/setup.c
+++ b/arch/h8300/kernel/setup.c
@@ -31,6 +31,7 @@
 #include <linux/bootmem.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
+#include <linux/screen_info.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -49,6 +50,10 @@
 
 #define STUBSIZE 0xc000
 
+#ifdef CONFIG_VT
+struct screen_info screen_info;
+#endif
+
 unsigned long rom_length;
 unsigned long memory_start;
 unsigned long memory_end;
-- 
1.7.7.6
