Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaFGPB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 11:01:26 -0400
Received: from smtpsalv.cc.upv.es ([158.42.249.11]:47370 "EHLO smtpsalv.upv.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbaFGPBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 11:01:24 -0400
X-Greylist: delayed 1128 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jun 2014 11:01:24 EDT
From: =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>
Cc: =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] media-device: Remove duplicated memset() in media_enum_entities()
Date: Sat,  7 Jun 2014 16:41:44 +0200
Message-Id: <1402152104-16865-1-git-send-email-speiro@ai2.upv.es>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the zeroing the whole struct struct media_entity_desc u_ent,
it is no longer necessary to memset(0) its u_ent.name field.

Signed-off-by: Salva Peiró <speiro@ai2.upv.es>

To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: stable@kernel.org
---
 drivers/media/media-device.c |    2 --
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
1.7.10.4

