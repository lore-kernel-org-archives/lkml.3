Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3ENFsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 01:48:02 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57329 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab3ENFsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 01:48:00 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org, ivtv-devel@ivtvdriver.org
Cc: linux-kernel@vger.kernel.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, Andy Walls <awalls@md.metrocast.net>,
        Mike Isely <isely@pobox.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Antti Palosaari <crope@iki.fi>,
        =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexey Klimov <klimov.linux@gmail.com>,
        Martin Bugge <marbugge@cisco.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        Janne Grunau <j@jannau.net>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 3/4] media: usb: remove duplicate checks for EPERM in vidioc_g/s_register
Date: Tue, 14 May 2013 11:15:16 +0530
Message-Id: <1368510317-4356-4-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368510317-4356-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368510317-4356-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch removes check for EPERM in vidioc_g/s_register
as this check is already performed by core.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index e11267f..01d1c2d 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -5173,8 +5173,6 @@ int pvr2_hdw_register_access(struct pvr2_hdw *hdw,
 	int stat = 0;
 	int okFl = 0;
 
-	if (!capable(CAP_SYS_ADMIN)) return -EPERM;
-
 	req.match = *match;
 	req.reg = reg_id;
 	if (setFl) req.val = *val_ptr;
-- 
1.7.4.1

