Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab3J1Oti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:49:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51183 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab3J1Ot0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jonghwan Choi <jhbird.choi@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 36/64] [media] sh_vou: almost forever loop in sh_vou_try_fmt_vid_out()
Date: Mon, 28 Oct 2013 14:47:55 +0000
Message-Id: <1382971703-17393-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 47c32ec9392a1fc7dec9d7cfde084e1432fcee82 upstream.

The "i < " part of the "i < ARRAY_SIZE()" condition was missing.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
[g.liakhovetski@gmx.de: remove unrelated superfluous braces]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Jonghwan Choi <jhbird.choi@gmail.com>
[ luis: backported to 3.5:
  - file rename: drivers/media/platform/sh_vou.c ->
    drivers/media/video/sh_vou.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/video/sh_vou.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/sh_vou.c b/drivers/media/video/sh_vou.c
index 8fd1874..1ca38b0 100644
--- a/drivers/media/video/sh_vou.c
+++ b/drivers/media/video/sh_vou.c
@@ -776,7 +776,7 @@ static int sh_vou_try_fmt_vid_out(struct file *file, void *priv,
 	v4l_bound_align_image(&pix->width, 0, VOU_MAX_IMAGE_WIDTH, 1,
 			      &pix->height, 0, VOU_MAX_IMAGE_HEIGHT, 1, 0);
 
-	for (i = 0; ARRAY_SIZE(vou_fmt); i++)
+	for (i = 0; i < ARRAY_SIZE(vou_fmt); i++)
 		if (vou_fmt[i].pfmt == pix->pixelformat)
 			return 0;
 
-- 
1.8.3.2

