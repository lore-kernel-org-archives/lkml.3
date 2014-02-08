Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaBHB6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 20:58:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:46384 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaBHB6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 20:58:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,804,1384329600"; 
   d="scan'208";a="477904570"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <trivial@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: unexport static function create_syslog_header
Date: Sat,  8 Feb 2014 09:59:02 +0800
Message-Id: <1391824742-25336-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function create_syslog_header() is defined as static, so it should
not be exported.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/base/core.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2b56717..b5d1b84 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2058,7 +2058,6 @@ create_syslog_header(const struct device *dev, char *hdr, size_t hdrlen)
 
 	return pos;
 }
-EXPORT_SYMBOL(create_syslog_header);
 
 int dev_vprintk_emit(int level, const struct device *dev,
 		     const char *fmt, va_list args)
-- 
1.7.10.4

