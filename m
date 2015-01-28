Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761046AbbA1ERS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:17:18 -0500
Received: from mail.kernel.org ([198.145.29.136]:38020 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933239AbbA1ERO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:17:14 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mike Snitzer <snitzer@redhat.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 041/177] dm log userspace: fix memory leak in dm_ulog_tfr_init failure path
Date: Wed, 28 Jan 2015 12:07:28 +0800
Message-Id: <1422418236-12852-81-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 56ec16cb1e1ce46354de8511eef962a417c32c92 upstream.

If cn_add_callback() fails in dm_ulog_tfr_init(), it does not
deallocate prealloced memory but calls cn_del_callback().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/md/dm-log-userspace-transfer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index 08d9a20..c69d0b7 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -272,7 +272,7 @@ int dm_ulog_tfr_init(void)
 
 	r = cn_add_callback(&ulog_cn_id, "dmlogusr", cn_ulog_callback);
 	if (r) {
-		cn_del_callback(&ulog_cn_id);
+		kfree(prealloced_cn_msg);
 		return r;
 	}
 
-- 
1.9.1

