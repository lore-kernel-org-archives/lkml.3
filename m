Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755Ab3B1PZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:25:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41910 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab3B1OqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anatolij Gustschin <agust@denx.de>, Timur Tabi <timur@tabi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 015/139] drivers/video: fsl-diu-fb: fix pixel formats for 24 and 16 bpp
Date: Thu, 28 Feb 2013 14:42:45 +0000
Message-Id: <1362062689-2567-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anatolij Gustschin <agust@denx.de>

commit 5d3cc311a76073f6e0a27c0752f7e41f69e95ea7 upstream.

Framebuffer colors for 24 and 16 bpp are currently wrong. The order
of the color component arguments in the MAKE_PF() is not natural
and causes some confusion. The generated pixel format values for 24
and 16 bpp depths do not much the values in the comments.

Fix the macro arguments to be in the natural RGB order and adjust
the arguments for all depths to generate correct pixel format values
(equal to the values mentioned in the comments).

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Timur Tabi <timur@tabi.org>
Acked-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/fsl-diu-fb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
index 458c006..dbce2da 100644
--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -922,7 +922,7 @@ static u32 fsl_diu_get_pixel_format(unsigned int bits_per_pixel)
 #define PF_COMP_0_MASK		0x0000000F
 #define PF_COMP_0_SHIFT		0
 
-#define MAKE_PF(alpha, red, blue, green, size, c0, c1, c2, c3) \
+#define MAKE_PF(alpha, red, green, blue, size, c0, c1, c2, c3) \
 	cpu_to_le32(PF_BYTE_F | (alpha << PF_ALPHA_C_SHIFT) | \
 	(blue << PF_BLUE_C_SHIFT) | (green << PF_GREEN_C_SHIFT) | \
 	(red << PF_RED_C_SHIFT) | (c3 << PF_COMP_3_SHIFT) | \
@@ -932,10 +932,10 @@ static u32 fsl_diu_get_pixel_format(unsigned int bits_per_pixel)
 	switch (bits_per_pixel) {
 	case 32:
 		/* 0x88883316 */
-		return MAKE_PF(3, 2, 0, 1, 3, 8, 8, 8, 8);
+		return MAKE_PF(3, 2, 1, 0, 3, 8, 8, 8, 8);
 	case 24:
 		/* 0x88082219 */
-		return MAKE_PF(4, 0, 1, 2, 2, 0, 8, 8, 8);
+		return MAKE_PF(4, 0, 1, 2, 2, 8, 8, 8, 0);
 	case 16:
 		/* 0x65053118 */
 		return MAKE_PF(4, 2, 1, 0, 1, 5, 6, 5, 0);
-- 
1.8.1.2

