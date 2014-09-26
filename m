Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbaIZK0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:26:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33053 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbaIZJqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 035/142] media: media-device: Remove duplicated memset() in media_enum_entities()
Date: Fri, 26 Sep 2014 11:44:06 +0200
Message-Id: <d99e678657e070df68f8394de67a01805f1a0303.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Salva Peiró <speiro@ai2.upv.es>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f8ca6ac00d2ba24c5557f08f81439cd3432f0802 upstream.

After the zeroing the whole struct struct media_entity_desc u_ent,
it is no longer necessary to memset(0) its u_ent.name field.

Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/media-device.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 703560fa5e73..88c1606fd555 100644
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
2.1.0

