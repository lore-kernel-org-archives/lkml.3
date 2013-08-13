Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab3HMQ1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:27:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33381 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758046Ab3HMQ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:54 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=QYeLScWkNyMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=W3FCQELpNHMA:10 a=8T59DR07AAAA:8 a=VwQbUJbxAAAA:8 a=tmtSDGaQAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=jkObVMfX7fAA:10 a=jeBq3FmKZ4MA:10 a=waj7ZiSQsRW-JnJg:21 a=tnfrcH3apRTAogDH:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155833.394040945@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [62/88] sd: Fix parsing of temporary  cache mode prefix
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0062-sd-Fix-parsing-of-temporary-cache-mode-prefix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit 2ee3e26c673e75c05ef8b914f54fadee3d7b9c88 ]

Commit 39c60a0948cc '[SCSI] sd: fix array cache flushing bug causing
performance problems' added temp as a pointer to "temporary " and used
sizeof(temp) - 1 as its length.  But sizeof(temp) is the size of the
pointer, not the size of the string constant.  Change temp to a static
array so that sizeof() does what was intended.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/scsi/sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 88ced02..a2ecd324 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -141,7 +141,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 	char *buffer_data;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
-	const char *temp = "temporary ";
+	static const char temp[] = "temporary ";
 	int len;
 
 	if (sdp->type != TYPE_DISK)
-- 
1.7.10.4


