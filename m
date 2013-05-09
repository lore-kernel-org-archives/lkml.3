Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab3EICCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 22:02:03 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:49847 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab3EICCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 22:02:01 -0400
MIME-Version: 1.0
Date: Thu, 9 May 2013 10:02:00 +0800
Message-ID: <CAPgLHd8=VBbx6kvSTM9Ys2kFQC6mn=Xvr7Za-juFa=0hb7nLpw@mail.gmail.com>
Subject: [PATCH] remoteproc: fix error return code in rproc_fw_boot()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: ohad@wizery.com, sjur.brandeland@stericsson.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -EINVAL in the rproc_find_loaded_rsc_table() error handling
case instead of 0, as done elsewhere in this function.

Introduced by commit a2b950ac7b1e6442919ee9e79c4963e134698869
(remoteproc: perserve resource table data).

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/remoteproc/remoteproc_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 022dc63..56e35c6 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -852,8 +852,10 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	 * copy this information to device memory.
 	 */
 	loaded_table = rproc_find_loaded_rsc_table(rproc, fw);
-	if (!loaded_table)
+	if (!loaded_table) {
+		ret = -EINVAL;
 		goto clean_up;
+	}
 
 	memcpy(loaded_table, rproc->cached_table, tablesz);
 

