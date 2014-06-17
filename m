Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967385AbaFQWCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:02:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54831 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967082AbaFQVw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 085/212] [media] media-device: fix infoleak in ioctl media_enum_entities()
Date: Tue, 17 Jun 2014 14:42:59 -0700
Message-Id: <1403041506-13646-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>

commit e6a623460e5fc960ac3ee9f946d3106233fd28d8 upstream.

This fixes CVE-2014-1739.

Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/media-device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index d5a7a13..703560f 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -93,6 +93,7 @@ static long media_device_enum_entities(struct media_device *mdev,
 	struct media_entity *ent;
 	struct media_entity_desc u_ent;
 
+	memset(&u_ent, 0, sizeof(u_ent));
 	if (copy_from_user(&u_ent.id, &uent->id, sizeof(u_ent.id)))
 		return -EFAULT;
 
-- 
1.9.1

