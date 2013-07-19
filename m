Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965818Ab3GSFeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:34:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965743Ab3GSF07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chen Gang <gang.chen@asianux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 38/72] arch: c6x: mm: include "asm/uaccess.h" to pass compiling
Date: Thu, 18 Jul 2013 22:25:55 -0700
Message-Id: <20130719052602.466806781@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

commit fe74650166dd6905b0cf66594eb79222dc9d7109 upstream.

Need include "asm/uaccess.h" to pass compiling.

The related error (with allmodconfig):

  arch/c6x/mm/init.c: In function `paging_init':
  arch/c6x/mm/init.c:46:2: error: implicit declaration of function `set_fs' [-Werror=implicit-function-declaration]
  arch/c6x/mm/init.c:46:9: error: `KERNEL_DS' undeclared (first use in this function)
  arch/c6x/mm/init.c:46:9: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/c6x/mm/init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/c6x/mm/init.c
+++ b/arch/c6x/mm/init.c
@@ -18,6 +18,7 @@
 #include <linux/initrd.h>
 
 #include <asm/sections.h>
+#include <asm/uaccess.h>
 
 /*
  * ZERO_PAGE is a special page that is used for zero-initialized


