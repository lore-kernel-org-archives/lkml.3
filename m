Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab3IVDXj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 23:23:39 -0400
Received: from intranet.asianux.com ([58.214.24.6]:15006 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3IVDXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 23:23:38 -0400
X-Spam-Score: -100.9
Message-ID: <523E6274.3030602@asianux.com>
Date: Sun, 22 Sep 2013 11:22:28 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arc: include: asm: uaccess.h: include "asm-generic/uaccess-unaligned.h"
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need include the default implementation, just like another platforms
(e.g. parisc, tile ...), or can not pass compiling.

The related error (with allmodconfig for arc):

    CC [M]  fs/btrfs/ioctl.o
  fs/btrfs/ioctl.c: In function ‘btrfs_ioctl_file_extent_same’:
  fs/btrfs/ioctl.c:2802: error: implicit declaration of function ‘__put_user_unaligned’


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arc/include/asm/uaccess.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arc/include/asm/uaccess.h b/arch/arc/include/asm/uaccess.h
index 3242082..8a2721f 100644
--- a/arch/arc/include/asm/uaccess.h
+++ b/arch/arc/include/asm/uaccess.h
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <asm/errno.h>
 #include <linux/string.h>	/* for generic string functions */
+#include <asm-generic/uaccess-unaligned.h>
 
 
 #define __kernel_ok		(segment_eq(get_fs(), KERNEL_DS))
-- 
1.7.7.6
