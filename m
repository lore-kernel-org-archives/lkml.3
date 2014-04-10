Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935354AbaDJDYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:24:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935136AbaDJDXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:23:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Grazvydas Ignotas <notasas@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 120/134] OMAPFB: fix framebuffer console colors
Date: Wed,  9 Apr 2014 20:23:56 -0700
Message-Id: <20140410032314.718614904@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grazvydas Ignotas <notasas@gmail.com>

commit c1c52848cef52e157468b8879fc3cae23b6f3a99 upstream.

omapfb does not currently set pseudo palette correctly for color depths
above 16bpp, making red text invisible, command like
  echo -e '\e[0;31mRED' > /dev/tty1
will display nothing on framebuffer console in 24bpp mode.
This is because temporary variable is declared incorrectly, fix it.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/omap2/omapfb/omapfb-main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/omap2/omapfb/omapfb-main.c
@@ -1187,7 +1187,7 @@ static int _setcolreg(struct fb_info *fb
 			break;
 
 		if (regno < 16) {
-			u16 pal;
+			u32 pal;
 			pal = ((red >> (16 - var->red.length)) <<
 					var->red.offset) |
 				((green >> (16 - var->green.length)) <<


