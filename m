Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbaICKBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:01:42 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57465 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932531AbaICJ6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:58:45 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 56/56] hpsa: fix bad -ENOMEM return value in hpsa_big_passthru_ioctl
Date: Wed,  3 Sep 2014 11:27:15 +0200
Message-Id: <dde74ef5a830f172e05b660eef52ca5f26aa45ce.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0758f4f732b08b6ef07f2e5f735655cf69fea477 upstream.

When copy_from_user fails, return -EFAULT, not -ENOMEM

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reported-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Joe Handzik <joseph.t.handzik@hp.com>
Reviewed-by: Scott Teel <scott.teel@hp.com>
Reviewed by: Mike MIller <michael.miller@canonical.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0eb09403680c..d535e7504ea0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3140,7 +3140,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		}
 		if (ioc->Request.Type.Direction == XFER_WRITE) {
 			if (copy_from_user(buff[sg_used], data_ptr, sz)) {
-				status = -ENOMEM;
+				status = -EFAULT;
 				goto cleanup1;
 			}
 		} else
-- 
2.1.0

