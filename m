Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaL3LMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 06:12:40 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:13566 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaL3LMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 06:12:39 -0500
From: Kaixu Xia <xiakaixu@huawei.com>
To: <mathieu.poirier@linaro.org>
CC: <gregkh@linuxfoundation.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <pratikp@codeaurora.org>,
        <xiakaixu@huawei.com>
Subject: [PATCH] coresight: remove the unused macro CORESIGHT_DEBUGFS_ENTRY
Date: Tue, 30 Dec 2014 19:07:37 +0800
Message-ID: <1419937657-35292-1-git-send-email-xiakaixu@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.54A2889F.01B2,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 1f974bc21a5bb69edbe90daea8566f67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xia Kaixu <xiakaixu@huawei.com>

Debugfs isn't used for coresight configuration, so the macro
CORESIGHT_DEBUGFS_ENTRY is unnecessary, just remove it.

Signed-off-by: Xia Kaixu <xiakaixu@huawei.com>
---
 include/linux/coresight.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/coresight.h b/include/linux/coresight.h
index 5d3c543..7cbfecb 100644
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
2.2.1

