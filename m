Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaGQEIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 00:08:19 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:48096 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaGQEIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 00:08:16 -0400
From: Kiran Padwal <kiran.padwal21@gmail.com>
To: gregkh@linuxfoundation.org
Cc: wkang77@gmail.com, kiran.padwal21@gmail.com, fengguang.wu@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: gdm724x: gdm_tty.c: fix missing blank line after variable declaration
Date: Thu, 17 Jul 2014 09:35:18 +0530
Message-Id: <1405569918-9559-1-git-send-email-kiran.padwal21@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch fix - Add missing blank line after variable declaration

Signed-off-by: Kiran Padwal <kiran.padwal21@gmail.com>
---
 drivers/staging/gdm724x/gdm_tty.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/gdm724x/gdm_tty.c b/drivers/staging/gdm724x/gdm_tty.c
index fe47cd3..001348c 100644
--- a/drivers/staging/gdm724x/gdm_tty.c
+++ b/drivers/staging/gdm724x/gdm_tty.c
@@ -111,24 +111,28 @@ static int gdm_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 static int gdm_tty_open(struct tty_struct *tty, struct file *filp)
 {
 	struct gdm *gdm = tty->driver_data;
+
 	return tty_port_open(&gdm->port, tty, filp);
 }
 
 static void gdm_tty_cleanup(struct tty_struct *tty)
 {
 	struct gdm *gdm = tty->driver_data;
+
 	tty_port_put(&gdm->port);
 }
 
 static void gdm_tty_hangup(struct tty_struct *tty)
 {
 	struct gdm *gdm = tty->driver_data;
+
 	tty_port_hangup(&gdm->port);
 }
 
 static void gdm_tty_close(struct tty_struct *tty, struct file *filp)
 {
 	struct gdm *gdm = tty->driver_data;
+
 	tty_port_close(&gdm->port, tty, filp);
 }
 
@@ -139,6 +143,7 @@ static int gdm_tty_recv_complete(void *data,
 				 int complete)
 {
 	struct gdm *gdm = tty_dev->gdm[index];
+
 	if (!GDM_TTY_READY(gdm)) {
 		if (complete == RECV_PACKET_PROCESS_COMPLETE)
 			gdm_tty_recv(gdm, gdm_tty_recv_complete);
-- 
1.7.9.5

