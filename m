Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab3FYCCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 22:02:42 -0400
Received: from intranet.asianux.com ([58.214.24.6]:26419 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3FYCCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 22:02:41 -0400
X-Spam-Score: -100.8
Message-ID: <51C8FA0C.5090202@asianux.com>
Date: Tue, 25 Jun 2013 10:01:48 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: msalter@redhat.com, a-jacquiot@ti.com
CC: Andrew Morton <akpm@linux-foundation.org>, jiang.liu@huawei.com,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        linux-c6x-dev@linux-c6x.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: c6x: mm: include "asm/uaccess.h" to pass compiling
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need include "asm/uaccess.h" to pass compiling.

The related error (with allmodconfig):
  arch/c6x/mm/init.c: In function ‘paging_init’:
  arch/c6x/mm/init.c:46:2: error: implicit declaration of function ‘set_fs’ [-Werror=implicit-function-declaration]
  arch/c6x/mm/init.c:46:9: error: ‘KERNEL_DS’ undeclared (first use in this function)
  arch/c6x/mm/init.c:46:9: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/c6x/mm/init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/c6x/mm/init.c b/arch/c6x/mm/init.c
index e524fde..63f5560 100644
--- a/arch/c6x/mm/init.c
+++ b/arch/c6x/mm/init.c
@@ -18,6 +18,7 @@
 #include <linux/initrd.h>
 
 #include <asm/sections.h>
+#include <asm/uaccess.h>
 
 /*
  * ZERO_PAGE is a special page that is used for zero-initialized
-- 
1.7.7.6
