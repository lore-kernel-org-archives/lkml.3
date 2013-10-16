Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934151Ab3JPLDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:03:46 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:35749 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934079Ab3JPLDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:03:40 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/8] zorro: Don't fill in dummy names in zorro_name_device()
Date: Wed, 16 Oct 2013 13:03:20 +0200
Message-Id: <1381921405-11206-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381921405-11206-1-git-send-email-geert@linux-m68k.org>
References: <1381921405-11206-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the device is not found in the database, it's not needed to fill in
a dummy name. The caller of zorro_name_device() has already taken care
of that to support CONFIG_ZORRO_NAMES=n.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/zorro/names.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/zorro/names.c b/drivers/zorro/names.c
index e8517c3d8e82..e44e04c4f29d 100644
--- a/drivers/zorro/names.c
+++ b/drivers/zorro/names.c
@@ -69,7 +69,6 @@ void __init zorro_name_device(struct zorro_dev *dev)
 	} while (--i);
 
 	/* Couldn't find either the manufacturer nor the product */
-	sprintf(name, "Zorro device %08x", dev->id);
 	return;
 
 	match_manuf: {
-- 
1.7.9.5

