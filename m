Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab3KNQWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:22:45 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41677 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab3KNQPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:15:55 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Fan Yong <fan.yong@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 23/40] staging/lustre/scrub: control OI scrub on OST from user space
Date: Fri, 15 Nov 2013 00:13:25 +0800
Message-Id: <1384445622-12346-24-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fan Yong <fan.yong@intel.com>

Not all the OI inconsistency can be detected automatically, such as /O
entry lost case. So the OI scrub on OST should can be triggered by the
administrator manually.

Lustre-change: http://review.whamcloud.com/6698
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3335
Signed-off-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/include/obd_support.h    |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lustre/include/obd_support.h b/drivers/staging/lustre/lustre/include/obd_support.h
index 1748985..4d1f62c 100644
--- a/drivers/staging/lustre/lustre/include/obd_support.h
+++ b/drivers/staging/lustre/lustre/include/obd_support.h
@@ -257,6 +257,7 @@ int obd_alloc_fail(const void *ptr, const char *name, const char *type,
 #define OBD_FAIL_OSD_FID_MAPPING			0x193
 #define OBD_FAIL_OSD_LMA_INCOMPAT			0x194
 #define OBD_FAIL_OSD_COMPAT_INVALID_ENTRY		0x195
+#define OBD_FAIL_OSD_COMPAT_NO_ENTRY			0x196
 
 #define OBD_FAIL_OST		     0x200
 #define OBD_FAIL_OST_CONNECT_NET	 0x201
-- 
1.7.9.5

