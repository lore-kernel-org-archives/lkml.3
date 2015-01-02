Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbbABX0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 18:26:10 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47059 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbbABX0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 18:26:08 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] media: i2c: adv7604:  Remove some unused functions
Date: Sat,  3 Jan 2015 00:29:08 +0100
Message-Id: <1420241348-4776-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
test_read() edid_read_block() dpp_write() dpp_read()
esdp_write() esdp_read() cec_write_clr_set()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/i2c/adv7604.c |   66 -------------------------------------------
 1 file changed, 66 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 47795ff..5e07b91 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -466,11 +466,6 @@ static inline int cec_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return adv_smbus_write_byte_data(state, ADV7604_PAGE_CEC, reg, val);
 }
 
-static inline int cec_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8 val)
-{
-	return cec_write(sd, reg, (cec_read(sd, reg) & ~mask) | val);
-}
-
 static inline int infoframe_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
@@ -486,34 +481,6 @@ static inline int infoframe_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 					 reg, val);
 }
 
-static inline int esdp_read(struct v4l2_subdev *sd, u8 reg)
-{
-	struct adv7604_state *state = to_state(sd);
-
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_ESDP, reg);
-}
-
-static inline int esdp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
-{
-	struct adv7604_state *state = to_state(sd);
-
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_ESDP, reg, val);
-}
-
-static inline int dpp_read(struct v4l2_subdev *sd, u8 reg)
-{
-	struct adv7604_state *state = to_state(sd);
-
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_DPP, reg);
-}
-
-static inline int dpp_write(struct v4l2_subdev *sd, u8 reg, u8 val)
-{
-	struct adv7604_state *state = to_state(sd);
-
-	return adv_smbus_write_byte_data(state, ADV7604_PAGE_DPP, reg, val);
-}
-
 static inline int afe_read(struct v4l2_subdev *sd, u8 reg)
 {
 	struct adv7604_state *state = to_state(sd);
@@ -561,32 +528,6 @@ static inline int edid_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 	return adv_smbus_write_byte_data(state, ADV7604_PAGE_EDID, reg, val);
 }
 
-static inline int edid_read_block(struct v4l2_subdev *sd, unsigned len, u8 *val)
-{
-	struct adv7604_state *state = to_state(sd);
-	struct i2c_client *client = state->i2c_clients[ADV7604_PAGE_EDID];
-	u8 msgbuf0[1] = { 0 };
-	u8 msgbuf1[256];
-	struct i2c_msg msg[2] = {
-		{
-			.addr = client->addr,
-			.len = 1,
-			.buf = msgbuf0
-		},
-		{
-			.addr = client->addr,
-			.flags = I2C_M_RD,
-			.len = len,
-			.buf = msgbuf1
-		},
-	};
-
-	if (i2c_transfer(client->adapter, msg, 2) < 0)
-		return -EIO;
-	memcpy(val, msgbuf1, len);
-	return 0;
-}
-
 static inline int edid_write_block(struct v4l2_subdev *sd,
 					unsigned len, const u8 *val)
 {
@@ -652,13 +593,6 @@ static inline int hdmi_write_clr_set(struct v4l2_subdev *sd, u8 reg, u8 mask, u8
 	return hdmi_write(sd, reg, (hdmi_read(sd, reg) & ~mask) | val);
 }
 
-static inline int test_read(struct v4l2_subdev *sd, u8 reg)
-{
-	struct adv7604_state *state = to_state(sd);
-
-	return adv_smbus_read_byte_data(state, ADV7604_PAGE_TEST, reg);
-}
-
 static inline int test_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 {
 	struct adv7604_state *state = to_state(sd);
-- 
1.7.10.4

