Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaFYBLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:11:11 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:53823 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaFYBLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:11:09 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: gdm72xx: check return value of sscanf
Date: Tue, 24 Jun 2014 18:11:08 -0700
Message-Id: <1403658668-8922-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Chan <benchan@chromium.org>
---
 drivers/staging/gdm72xx/gdm_wimax.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index e5e5115..3081fd4 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -291,8 +291,9 @@ static void __gdm_wimax_event_send(struct work_struct *work)
 		e = list_entry(wm_event.evtq.next, struct evt_entry, list);
 		spin_unlock_irqrestore(&wm_event.evt_lock, flags);
 
-		sscanf(e->dev->name, "wm%d", &idx);
-		netlink_send(wm_event.sock, idx, 0, e->evt_data, e->size);
+		if (sscanf(e->dev->name, "wm%d", &idx) == 1)
+			netlink_send(wm_event.sock, idx, 0, e->evt_data,
+				     e->size);
 
 		spin_lock_irqsave(&wm_event.evt_lock, flags);
 		list_del(&e->list);
-- 
2.0.0.526.g5318336

