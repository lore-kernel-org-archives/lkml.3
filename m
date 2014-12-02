Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934153AbaLBT41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:56:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46508 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbaLBTU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:20:28 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 012/121] [media] ttusb-dec: buffer overflow in ioctl
Date: Tue,  2 Dec 2014 11:18:11 -0800
Message-Id: <1417548000-1794-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit f2e323ec96077642d397bb1c355def536d489d16 upstream.

We need to add a limit check here so we don't overflow the buffer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Reference: CVE-2014-8884
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/usb/ttusb-dec/ttusbdecfe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/ttusb-dec/ttusbdecfe.c b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
index 5c45c9d..9c29552 100644
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
1.9.1

