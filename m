Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960AbaICWTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:19:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933871AbaICWSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Robert Elliott <elliott@hp.com>, Joe Handzik <joseph.t.handzik@hp.com>,
        Scott Teel <scott.teel@hp.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.16 083/125] hpsa: fix bad -ENOMEM return value in hpsa_big_passthru_ioctl
Date: Wed,  3 Sep 2014 15:07:20 -0700
Message-Id: <20140903220626.161243776@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5092,7 +5092,7 @@ static int hpsa_big_passthru_ioctl(struc
 		}
 		if (ioc->Request.Type.Direction & XFER_WRITE) {
 			if (copy_from_user(buff[sg_used], data_ptr, sz)) {
-				status = -ENOMEM;
+				status = -EFAULT;
 				goto cleanup1;
 			}
 		} else


