Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbbAAQKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 11:10:23 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38543 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbbAAQKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 11:10:21 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] media: i2c: adv7604.c:  Remove some unused functions
Date: Thu,  1 Jan 2015 17:13:20 +0100
Message-Id: <1420128800-28746-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
vblanking() hblanking()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/i2c/adv7604.c |   10 ----------
 drivers/media/i2c/adv7842.c |   10 ----------
 drivers/media/i2c/ths8200.c |   10 ----------
 3 files changed, 30 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 47795ff..0ecca94 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -333,21 +333,11 @@ static inline struct adv7604_state *to_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct adv7604_state, sd);
 }
 
-static inline unsigned hblanking(const struct v4l2_bt_timings *t)
-{
-	return V4L2_DV_BT_BLANKING_WIDTH(t);
-}
-
 static inline unsigned htotal(const struct v4l2_bt_timings *t)
 {
 	return V4L2_DV_BT_FRAME_WIDTH(t);
 }
 
-static inline unsigned vblanking(const struct v4l2_bt_timings *t)
-{
-	return V4L2_DV_BT_BLANKING_HEIGHT(t);
-}
-
 static inline unsigned vtotal(const struct v4l2_bt_timings *t)
 {
 	return V4L2_DV_BT_FRAME_HEIGHT(t);
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 48b628b..d89898c 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -220,21 +220,11 @@ static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
 	return &container_of(ctrl->handler, struct adv7842_state, hdl)->sd;
 }
 
-static inline unsigned hblanking(const struct v4l2_bt_timings *t)
-{
-	return V4L2_DV_BT_BLANKING_WIDTH(t);
-}
-
 static inline unsigned htotal(const struct v4l2_bt_timings *t)
 {
 	return V4L2_DV_BT_FRAME_WIDTH(t);
 }
 
-static inline unsigned vblanking(const struct v4l2_bt_timings *t)
-{
-	return V4L2_DV_BT_BLANKING_HEIGHT(t);
-}
-
 static inline unsigned vtotal(const struct v4l2_bt_timings *t)
 {
 	return V4L2_DV_BT_FRAME_HEIGHT(t);
diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index 656d889..4ebd329 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -58,21 +58,11 @@ static inline struct ths8200_state *to_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct ths8200_state, sd);
 }
 
-static inline unsigned hblanking(const struct v4l2_bt_timings *t)
-{
-	return V4L2_DV_BT_BLANKING_WIDTH(t);
-}
-
 static inline unsigned htotal(const struct v4l2_bt_timings *t)
 {
 	return V4L2_DV_BT_FRAME_WIDTH(t);
 }
 
-static inline unsigned vblanking(const struct v4l2_bt_timings *t)
-{
-	return V4L2_DV_BT_BLANKING_HEIGHT(t);
-}
-
 static inline unsigned vtotal(const struct v4l2_bt_timings *t)
 {
 	return V4L2_DV_BT_FRAME_HEIGHT(t);
-- 
1.7.10.4

