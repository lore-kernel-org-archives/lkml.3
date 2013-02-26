Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab3BZX6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:58:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549Ab3BZX6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anatolij Gustschin <agust@denx.de>, Timur Tabi <timur@tabi.org>,
        Timur Tabi <timur@freescale.com>
Subject: [ 114/150] drivers/video: fsl-diu-fb: fix pixel formats for 24 and 16 bpp
Date: Tue, 26 Feb 2013 15:56:11 -0800
Message-Id: <20130226235535.921979927@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fsl-diu-fb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -944,7 +944,7 @@ static u32 fsl_diu_get_pixel_format(unsi
 #define PF_COMP_0_MASK		0x0000000F
 #define PF_COMP_0_SHIFT		0
 
-#define MAKE_PF(alpha, red, blue, green, size, c0, c1, c2, c3) \
+#define MAKE_PF(alpha, red, green, blue, size, c0, c1, c2, c3) \
 	cpu_to_le32(PF_BYTE_F | (alpha << PF_ALPHA_C_SHIFT) | \
 	(blue << PF_BLUE_C_SHIFT) | (green << PF_GREEN_C_SHIFT) | \
 	(red << PF_RED_C_SHIFT) | (c3 << PF_COMP_3_SHIFT) | \
@@ -954,10 +954,10 @@ static u32 fsl_diu_get_pixel_format(unsi
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


