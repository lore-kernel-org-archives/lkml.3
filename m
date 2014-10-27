Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaJ0S5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:57:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52407 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaJ0S5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:57:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 005/105] [media] em28xx-v4l: fix video buffer field order reporting in progressive mode
Date: Mon, 27 Oct 2014 11:55:40 -0700
Message-Id: <1414436240-13879-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Schaefer <fschaefer.oss@googlemail.com>

commit 662c97cf8f9e9d67d45d0a9f0c1565a1ede364c2 upstream.

The correct field order in progressive mode is V4L2_FIELD_NONE, not V4L2_FIELD_INTERLACED.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index f435c75..e346189 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -148,7 +148,10 @@ static inline void finish_buffer(struct em28xx *dev,
 	em28xx_isocdbg("[%p/%d] wakeup\n", buf, buf->top_field);
 
 	buf->vb.v4l2_buf.sequence = dev->field_count++;
-	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
+	if (dev->progressive)
+		buf->vb.v4l2_buf.field = V4L2_FIELD_NONE;
+	else
+		buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 
 	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
-- 
1.9.1

