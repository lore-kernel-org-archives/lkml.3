Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3CKHOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:14:41 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26675 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3CKHOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:14:37 -0400
Message-ID: <513D844D.7000301@huawei.com>
Date: Mon, 11 Mar 2013 15:14:21 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 12/13] scsi/tracing: include correct header file
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scsi_trace.c just export function scsi_trace_parse_cdb to
event tracing infrastructure, It's not necessary to
include trace/events/scsi.h

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 drivers/scsi/scsi_trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 2bea4f0..b703256 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -17,7 +17,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/trace_seq.h>
-#include <trace/events/scsi.h>
+#include <scsi/scsi.h>

 #define SERVICE_ACTION16(cdb) (cdb[1] & 0x1f)
 #define SERVICE_ACTION32(cdb) ((cdb[8] << 8) | cdb[9])
-- 
1.7.9.7


