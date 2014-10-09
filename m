Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbaJIVGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:06:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59024 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbaJIVGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:06:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 128/163] [media] adv7604: fix inverted condition
Date: Thu,  9 Oct 2014 14:02:33 -0700
Message-Id: <1412888588-26755-129-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

commit 77639ff2b3404a913b8037d230a384798b854bae upstream.

The log_status function should show HDMI information, but the test checking for
an HDMI input was inverted. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/i2c/adv7604.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index a324106b..20676ae 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1752,7 +1752,7 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "HDCP keys read: %s%s\n",
 			(hdmi_read(sd, 0x04) & 0x20) ? "yes" : "no",
 			(hdmi_read(sd, 0x04) & 0x10) ? "ERROR" : "");
-	if (!is_hdmi(sd)) {
+	if (is_hdmi(sd)) {
 		bool audio_pll_locked = hdmi_read(sd, 0x04) & 0x01;
 		bool audio_sample_packet_detect = hdmi_read(sd, 0x18) & 0x01;
 		bool audio_mute = io_read(sd, 0x65) & 0x40;
-- 
1.9.1

