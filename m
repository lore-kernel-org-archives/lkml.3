Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab3ENFrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 01:47:05 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62880 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3ENFrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 01:47:03 -0400
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
Subject: [PATCH 2/4] media: dvb-frontends: remove duplicate checks for EPERM in dbg_g/s_register
Date: Tue, 14 May 2013 11:15:15 +0530
Message-Id: <1368510317-4356-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368510317-4356-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368510317-4356-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch removes check for EPERM in dbg_g/s_register
as this check is already performed by core.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 2099f21..9d159b4 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -529,8 +529,6 @@ static int au8522_g_register(struct v4l2_subdev *sd,
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	reg->val = au8522_readreg(state, reg->reg & 0xffff);
 	return 0;
 }
@@ -543,8 +541,6 @@ static int au8522_s_register(struct v4l2_subdev *sd,
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	au8522_writereg(state, reg->reg, reg->val & 0xff);
 	return 0;
 }
-- 
1.7.4.1

