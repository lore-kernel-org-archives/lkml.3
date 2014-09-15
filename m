Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbaIOWxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:53:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50986 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbaIOWQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:16:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 087/187] [media] media-device: Remove duplicated memset() in media_enum_entities()
Date: Mon, 15 Sep 2014 15:08:17 -0700
Message-Id: <1410818997-9432-88-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>

commit f8ca6ac00d2ba24c5557f08f81439cd3432f0802 upstream.

After the zeroing the whole struct struct media_entity_desc u_ent,
it is no longer necessary to memset(0) its u_ent.name field.

Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/media-device.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 703560f..88c1606 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -106,8 +106,6 @@ static long media_device_enum_entities(struct media_device *mdev,
 	if (ent->name) {
 		strncpy(u_ent.name, ent->name, sizeof(u_ent.name));
 		u_ent.name[sizeof(u_ent.name) - 1] = '\0';
-	} else {
-		memset(u_ent.name, 0, sizeof(u_ent.name));
 	}
 	u_ent.type = ent->type;
 	u_ent.revision = ent->revision;
-- 
1.9.1

