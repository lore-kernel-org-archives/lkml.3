Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab3KRSnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:43:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3KRSmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:42:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.10 24/24] media: sh_vou: almost forever loop in sh_vou_try_fmt_vid_out()
Date: Mon, 18 Nov 2013 10:42:34 -0800
Message-Id: <20131118184223.746620815@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184222.017393843@linuxfoundation.org>
References: <20131118184222.017393843@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 47c32ec9392a1fc7dec9d7cfde084e1432fcee82 upstream.

The "i < " part of the "i < ARRAY_SIZE()" condition was missing.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
[g.liakhovetski@gmx.de: remove unrelated superfluous braces]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/sh_vou.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -776,7 +776,7 @@ static int sh_vou_try_fmt_vid_out(struct
 	v4l_bound_align_image(&pix->width, 0, VOU_MAX_IMAGE_WIDTH, 1,
 			      &pix->height, 0, VOU_MAX_IMAGE_HEIGHT, 1, 0);
 
-	for (i = 0; ARRAY_SIZE(vou_fmt); i++)
+	for (i = 0; i < ARRAY_SIZE(vou_fmt); i++)
 		if (vou_fmt[i].pfmt == pix->pixelformat)
 			return 0;
 


