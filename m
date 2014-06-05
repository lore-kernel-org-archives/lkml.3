Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaFEFCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:02:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaFEEUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.4 063/214] media: media-device: fix infoleak in ioctl media_enum_entities()
Date: Wed,  4 Jun 2014 21:17:06 -0700
Message-Id: <20140605041647.980617145@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>

commit e6a623460e5fc960ac3ee9f946d3106233fd28d8 upstream.

This fixes CVE-2014-1739.

Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/media-device.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -90,6 +90,7 @@ static long media_device_enum_entities(s
 	struct media_entity *ent;
 	struct media_entity_desc u_ent;
 
+	memset(&u_ent, 0, sizeof(u_ent));
 	if (copy_from_user(&u_ent.id, &uent->id, sizeof(u_ent.id)))
 		return -EFAULT;
 


