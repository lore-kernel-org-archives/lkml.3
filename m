Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbaIOWLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:11:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50542 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444AbaIOWLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:11:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Christoph Hellwig <hch@lst.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 094/187] hpsa: fix bad -ENOMEM return value in hpsa_big_passthru_ioctl
Date: Mon, 15 Sep 2014 15:08:24 -0700
Message-Id: <1410818997-9432-95-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 0758f4f732b08b6ef07f2e5f735655cf69fea477 upstream.

When copy_from_user fails, return -EFAULT, not -ENOMEM

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reported-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Joe Handzik <joseph.t.handzik@hp.com>
Reviewed-by: Scott Teel <scott.teel@hp.com>
Reviewed by: Mike MIller <michael.miller@canonical.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ad034ab..d518bba 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3151,7 +3151,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		}
 		if (ioc->Request.Type.Direction == XFER_WRITE) {
 			if (copy_from_user(buff[sg_used], data_ptr, sz)) {
-				status = -ENOMEM;
+				status = -EFAULT;
 				goto cleanup1;
 			}
 		} else
-- 
1.9.1

