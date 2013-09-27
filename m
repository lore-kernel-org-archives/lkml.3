Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3I0QvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:51:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:6637 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab3I0QvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:51:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,994,1371106800"; 
   d="scan'208";a="384476201"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 4/5] misc: mic: fix a warning in the IOCTL header file.
Date: Fri, 27 Sep 2013 09:50:06 -0700
Message-Id: <bff1d803a4f89eb6c4d552845649becea3b2c5c2.1380289102.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1380289102.git.sudeep.dutt@intel.com>
References: <cover.1380289102.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warning from mic_ioctl.h is fixed via this patch:
found __[us]{8,16,32,64} type without #include <linux/types.h>

Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 include/uapi/linux/mic_ioctl.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/mic_ioctl.h b/include/uapi/linux/mic_ioctl.h
index 0e6cbf3..7fabba5 100644
--- a/include/uapi/linux/mic_ioctl.h
+++ b/include/uapi/linux/mic_ioctl.h
@@ -21,6 +21,8 @@
 #ifndef _MIC_IOCTL_H_
 #define _MIC_IOCTL_H_
 
+#include <linux/types.h>
+
 /*
  * mic_copy - MIC virtio descriptor copy.
  *
-- 
1.8.2.1

