Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3CQNc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 09:32:57 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50641 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab3CQNcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 09:32:52 -0400
X-Greylist: delayed 98094 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Mar 2013 09:32:52 EDT
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: staging: davinci_vpfe: fix build error
Date: Sun, 17 Mar 2013 19:02:30 +0530
Message-Id: <1363527150-6371-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

add missing header file delay.h required for msleep().
This patch fixes following build error:

drivers/staging/media/davinci_vpfe/dm365_isif.c: In function 'isif_enable':
drivers/staging/media/davinci_vpfe/dm365_isif.c:129: error: implicit declaration of function 'msleep'
make[4]: *** [drivers/staging/media/davinci_vpfe/dm365_isif.o] Error 1

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/staging/media/davinci_vpfe/dm365_isif.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index ebeea72..e4e6fcc 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -19,6 +19,8 @@
  *      Prabhakar Lad <prabhakar.lad@ti.com>
  */
 
+#include <linux/delay.h>
+
 #include "dm365_isif.h"
 #include "vpfe_mc_capture.h"
 
-- 
1.7.0.4

