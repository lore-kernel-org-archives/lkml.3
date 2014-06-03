Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbaFCLlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:41:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43490 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbaFCLlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 055/138] [media] media-device: fix infoleak in ioctl media_enum_entities()
Date: Tue,  3 Jun 2014 12:38:21 +0100
Message-Id: <1401795584-22664-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>

commit e6a623460e5fc960ac3ee9f946d3106233fd28d8 upstream.

This fixes CVE-2014-1739.

Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

