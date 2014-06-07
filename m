Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaFGB1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:27:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36148 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752693AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "=?UTF-8?q?Salva=20Peir=C3=B3?=" <speiro@ai2.upv.es>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.665480053@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 44/92] [media] media-device: fix infoleak in ioctl
 media_enum_entities()
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Salva Peiró <speiro@ai2.upv.es>

commit e6a623460e5fc960ac3ee9f946d3106233fd28d8 upstream.

This fixes CVE-2014-1739.

Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/media-device.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -90,6 +90,7 @@ static long media_device_enum_entities(s
 	struct media_entity *ent;
 	struct media_entity_desc u_ent;
 
+	memset(&u_ent, 0, sizeof(u_ent));
 	if (copy_from_user(&u_ent.id, &uent->id, sizeof(u_ent.id)))
 		return -EFAULT;
 

