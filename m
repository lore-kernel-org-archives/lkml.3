Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab3AWOFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:05:10 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:47678 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab3AWOFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:05:07 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH v6 2/2] adv7180: remove {query/g_/s_}ctrl
Date: Wed, 23 Jan 2013 15:07:07 +0100
Message-Id: <1358950027-27419-2-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1358950027-27419-1-git-send-email-federico.vaga@gmail.com>
References: <1358950027-27419-1-git-send-email-federico.vaga@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All drivers which use this subdevice use also the control framework.
The v4l2_subdev_core_ops operations {query/g_/s_}ctrl are useless because
device drivers will inherit controls from this subdevice.

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
---
 drivers/media/i2c/adv7180.c | 3 ---
 1 file modificato, 3 rimozioni(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 45ecf8d..43bc2b9 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -402,9 +402,6 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 static const struct v4l2_subdev_core_ops adv7180_core_ops = {
 	.g_chip_ident = adv7180_g_chip_ident,
 	.s_std = adv7180_s_std,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
 };
 
 static const struct v4l2_subdev_ops adv7180_ops = {
-- 
1.7.11.7

