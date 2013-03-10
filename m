Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3CJDNZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 22:13:25 -0500
Received: from intranet.asianux.com ([58.214.24.6]:21943 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3CJDNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 22:13:24 -0500
X-Spam-Score: -100.8
Message-ID: <513BFA37.4040100@asianux.com>
Date: Sun, 10 Mar 2013 11:12:55 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: lizefan@huawei.com, tj@kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        glommer@parallels.com, fweisbec@redhat.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] include/linux/res_counter.h: fixup commit 9259826ccb8165f797e4c2c9d17925b41af5f6ae
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  still need include linux/errno.h for EBUSY.

additional info:
  make command:
    make EXTRA_CFLAGS=-W V=1 ARCH=arm allmodconfig
    make EXTRA_CFLAGS=-W V=1 ARCH=arm
  error report:
    In file included from mm/memcontrol.c:28:0:
    include/linux/res_counter.h: in function ¡®res_counter_set_limit¡¯:
    include/linux/res_counter.h:204:13: error £º¡®EBUSY¡¯ is not declared.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/linux/res_counter.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index a83a849..f9822dc 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -13,6 +13,7 @@
  * info about what this counter is.
  */
 
+#include <linux/errno.h>
 #include <linux/spinlock.h>
 
 /*
-- 
1.7.7.6
