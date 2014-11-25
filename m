Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaKYLRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:17:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58752 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbaKYKmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        =?UTF-8?q?Moritz=20M=C3=BChlenhoff?= <jmm@inutil.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 147/254] [media] ttusb-dec: buffer overflow in ioctl
Date: Tue, 25 Nov 2014 10:38:17 +0000
Message-Id: <1416912004-5928-148-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit f2e323ec96077642d397bb1c355def536d489d16 upstream.

We need to add a limit check here so we don't overflow the buffer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Moritz Mühlenhoff <jmm@inutil.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.0

