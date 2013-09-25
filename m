Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab3IYATs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:19:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab3IYATq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:19:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        Chris Zankel <chris@zankel.net>
Subject: [ 003/117] xtensa: Fix broken allmodconfig build
Date: Tue, 24 Sep 2013 17:17:49 -0700
Message-Id: <20130925001741.237265341@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 8872366df396444d7655287c79ed182d8f47cba6 upstream.

xtansa allmodbuild fails with:

arch/xtensa/kernel/xtensa_ksyms.c:129:1: error: '_mcount' undeclared here (not in a function)
make[2]: *** [arch/xtensa/kernel/xtensa_ksyms.o] Error 1
make[1]: *** [arch/xtensa/kernel] Error 2

The breakage is due to commit 478ba61af (xtensa: add static function tracer
support) which exports _mcount without declaring it.

Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Chris Zankel <chris@zankel.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/kernel/xtensa_ksyms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/xtensa/kernel/xtensa_ksyms.c
+++ b/arch/xtensa/kernel/xtensa_ksyms.c
@@ -25,6 +25,7 @@
 #include <asm/io.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
+#include <asm/ftrace.h>
 #ifdef CONFIG_BLK_DEV_FD
 #include <asm/floppy.h>
 #endif


