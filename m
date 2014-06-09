Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbaFII6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:58:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58566 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932219AbaFIIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 088/146] media: media-device: fix infoleak in ioctl media_enum_entities()
Date: Mon,  9 Jun 2014 10:50:23 +0200
Message-Id: <4d6707b534a7e2d3251e673820ee312d08f8dc73.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Salva Peiró <speiro@ai2.upv.es>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e6a623460e5fc960ac3ee9f946d3106233fd28d8 upstream.

This fixes CVE-2014-1739.

Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/media-device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index d5a7a135f75d..703560fa5e73 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -93,6 +93,7 @@ static long media_device_enum_entities(struct media_device *mdev,
 	struct media_entity *ent;
 	struct media_entity_desc u_ent;
 
+	memset(&u_ent, 0, sizeof(u_ent));
 	if (copy_from_user(&u_ent.id, &uent->id, sizeof(u_ent.id)))
 		return -EFAULT;
 
-- 
1.9.3

