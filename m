Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaLOOhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:37:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38888 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbaLOO27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dean Anderson <linux-dev@sensoray.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 130/168] [media] s2255drv: fix payload size for JPG, MJPEG
Date: Mon, 15 Dec 2014 14:26:24 +0000
Message-Id: <1418653622-21105-131-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: sensoray-dev <linux-dev@sensoray.com>

commit 1f391217ad8d7cd7b1e48e6e2abf49970cd91d18 upstream.

length is the size of the buffer, not the payload. That's set using
vb2_set_plane_payload().

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/s2255/s2255drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index a44466bc7b86..ea56159e9bb2 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -632,7 +632,7 @@ static void s2255_fillbuff(struct s2255_vc *vc,
 			break;
 		case V4L2_PIX_FMT_JPEG:
 		case V4L2_PIX_FMT_MJPEG:
-			buf->vb.v4l2_buf.length = jpgsize;
+			vb2_set_plane_payload(&buf->vb, 0, jpgsize);
 			memcpy(vbuf, tmpbuf, jpgsize);
 			break;
 		case V4L2_PIX_FMT_YUV422P:
-- 
2.1.3

