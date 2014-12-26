Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaLZAG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 19:06:29 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33556 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbaLZAGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 19:06:23 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Kirill Tkhai <ktkhai@parallels.com>, Joe Perches <joe@perches.com>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Dmitry Eremin <dmitry.eremin@intel.com>,
        Masaru Nomura <massa.nomura@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James A Shackleford <shack@linux.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH 6/6] staging: lustre: remove custom MIN/MAX and min_t operations
Date: Thu, 25 Dec 2014 16:04:46 -0800
Message-Id: <1419552286-8492-7-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419552286-8492-1-git-send-email-jmmahler@gmail.com>
References: <1419552286-8492-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all custom MIN/MAX and min_t operations since they are
no longer needed.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/staging/lustre/include/linux/libcfs/libcfs_private.h | 8 --------
 drivers/staging/lustre/lustre/osc/osc_internal.h             | 5 -----
 2 files changed, 13 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
index 2817112..3d86fb5 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
@@ -458,14 +458,6 @@ struct libcfs_device_userstate {
 	struct page   *ldu_memhog_root_page;
 };
 
-/* what used to be in portals_lib.h */
-#ifndef MIN
-# define MIN(a, b) (((a) < (b)) ? (a) : (b))
-#endif
-#ifndef MAX
-# define MAX(a, b) (((a) > (b)) ? (a) : (b))
-#endif
-
 #define MKSTR(ptr) ((ptr)) ? (ptr) : ""
 
 static inline int cfs_size_round4(int val)
diff --git a/drivers/staging/lustre/lustre/osc/osc_internal.h b/drivers/staging/lustre/lustre/osc/osc_internal.h
index d788dac..af96c7b 100644
--- a/drivers/staging/lustre/lustre/osc/osc_internal.h
+++ b/drivers/staging/lustre/lustre/osc/osc_internal.h
@@ -160,11 +160,6 @@ static inline unsigned long rpcs_in_flight(struct client_obd *cli)
 	return cli->cl_r_in_flight + cli->cl_w_in_flight;
 }
 
-#ifndef min_t
-#define min_t(type, x, y) \
-	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
-#endif
-
 struct osc_device {
 	struct cl_device    od_cl;
 	struct obd_export  *od_exp;
-- 
2.1.4

