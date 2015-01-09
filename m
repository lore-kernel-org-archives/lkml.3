Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbbAJAAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:00:08 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35600 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbbAIX5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:57:43 -0500
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH 07/11] coresight: remove the unused macro CORESIGHT_DEBUGFS_ENTRY
Date: Fri,  9 Jan 2015 16:57:18 -0700
Message-Id: <1420847842-31769-8-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420847842-31769-1-git-send-email-mathieu.poirier@linaro.org>
References: <1420847842-31769-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xia Kaixu <xiakaixu@huawei.com>

Debugfs isn't used for coresight configuration, so the macro
CORESIGHT_DEBUGFS_ENTRY is unnecessary, just remove it.

Signed-off-by: Xia Kaixu <xiakaixu@huawei.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 include/linux/coresight.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/coresight.h b/include/linux/coresight.h
index 5d3c54311f7a..7cbfecbfa643 100644
--- a/include/linux/coresight.h
+++ b/include/linux/coresight.h
@@ -179,15 +179,6 @@ struct coresight_device {
 #define sink_ops(csdev)		csdev->ops->sink_ops
 #define link_ops(csdev)		csdev->ops->link_ops
 
-#define CORESIGHT_DEBUGFS_ENTRY(__name, __entry_name,			\
-				 __mode, __get, __set, __fmt)		\
-DEFINE_SIMPLE_ATTRIBUTE(__name ## _ops, __get, __set, __fmt);		\
-static const struct coresight_ops_entry __name ## _entry = {		\
-	.name = __entry_name,						\
-	.mode = __mode,							\
-	.ops  = &__name ## _ops						\
-}
-
 /**
  * struct coresight_ops_sink - basic operations for a sink
  * Operations available for sinks
-- 
1.9.1

