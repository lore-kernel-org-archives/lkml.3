Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab3CIIvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 03:51:22 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:38101 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab3CIIvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 03:51:20 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] res_counter: Add missing #include <linux/errno.h>
Date: Sat,  9 Mar 2013 09:51:17 +0100
Message-Id: <1362819077-14211-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9259826ccb8165f797e4c2c9d17925b41af5f6ae ("res_counter: remove
include of cgroup.h from res_counter.h") removed the indirect inclusion of
<linux/errno.h>, breaking the build on m68k and sparc:

In file included from mm/memcontrol.c:29:
include/linux/res_counter.h: In function ‘res_counter_set_limit’:
include/linux/res_counter.h:203: error: ‘EBUSY’ undeclared (first use in this function)
include/linux/res_counter.h:203: error: (Each undeclared identifier is reported only once
include/linux/res_counter.h:203: error: for each function it appears in.)

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/8342952/
http://kisskb.ellerman.id.au/kisskb/buildresult/8342757/
http://kisskb.ellerman.id.au/kisskb/buildresult/8342767/

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
1.7.0.4

