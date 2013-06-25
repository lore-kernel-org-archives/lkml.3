Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab3FYB7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 21:59:25 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9601 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3FYB7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 21:59:24 -0400
X-Spam-Score: -100.8
Message-ID: <51C8F948.2040204@asianux.com>
Date: Tue, 25 Jun 2013 09:58:32 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: msalter@redhat.com, a-jacquiot@ti.com
CC: jkc@redhat.com, linux-c6x-dev@linux-c6x.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: c6x: kernel: include "linux/console.h" when 'VT' and
 'DUMMY_CONSOLE' enabled.
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need include "linux/console.h" when 'VT' and 'DUMMY_CONSOLE' enabled
(e.g allmodconfig).

The related error:
  arch/c6x/kernel/setup.c: In function ‘setup_arch’:
  arch/c6x/kernel/setup.c:442:2: error: ‘conswitchp’ undeclared (first use in this function)
  arch/c6x/kernel/setup.c:442:2: note: each undeclared identifier is reported only once for each function it appears in
  arch/c6x/kernel/setup.c:442:16: error: ‘dummy_con’ undeclared (first use in this function)

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/c6x/kernel/setup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/c6x/kernel/setup.c b/arch/c6x/kernel/setup.c
index f4e72bd..1411141 100644
--- a/arch/c6x/kernel/setup.c
+++ b/arch/c6x/kernel/setup.c
@@ -26,6 +26,9 @@
 #include <linux/cpu.h>
 #include <linux/fs.h>
 #include <linux/of.h>
+#if defined(CONFIG_VT) && defined(CONFIG_DUMMY_CONSOLE)
+#include <linux/console.h>
+#endif
 
 
 #include <asm/sections.h>
-- 
1.7.7.6
