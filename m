Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbaKRPFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:05:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075AbaKROJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:41 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 045/206] [media] ttusb-dec: buffer overflow in ioctl
Date: Tue, 18 Nov 2014 15:06:40 +0100
Message-Id: <482c6cb2dfb40838d67b0ba844b4b3d0af0f3d20.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f2e323ec96077642d397bb1c355def536d489d16 upstream.

We need to add a limit check here so we don't overflow the buffer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/usb/ttusb-dec/ttusbdecfe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/ttusb-dec/ttusbdecfe.c b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
index 5c45c9d0712d..9c29552aedec 100644
--- a/drivers/media/usb/ttusb-dec/ttusbdecfe.c
+++ b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
@@ -156,6 +156,9 @@ static int ttusbdecfe_dvbs_diseqc_send_master_cmd(struct dvb_frontend* fe, struc
 		   0x00, 0x00, 0x00, 0x00,
 		   0x00, 0x00 };
 
+	if (cmd->msg_len > sizeof(b) - 4)
+		return -EINVAL;
+
 	memcpy(&b[4], cmd->msg, cmd->msg_len);
 
 	state->config->send_command(fe, 0x72,
-- 
2.1.3

