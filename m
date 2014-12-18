Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaLRBrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 20:47:25 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60134 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaLRBrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 20:47:24 -0500
From: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
To: arnd@arndb.de
Cc: gregkh@linuxfoundation.org, michael.hennerich@analog.com,
        linux-kernel@vger.kernel.org,
        Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Subject: [PATCH 2/2] ad525x_dpot:Remove break after return
Date: Thu, 18 Dec 2014 07:17:13 +0530
Message-Id: <1418867233-5279-1-git-send-email-md.jamalmohiuddin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418867186-5221-1-git-send-email-md.jamalmohiuddin@gmail.com>
References: <1418867186-5221-1-git-send-email-md.jamalmohiuddin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the break statements present after return

Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
---
 drivers/misc/ad525x_dpot.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index 32f9072..15e8807 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -334,7 +334,6 @@ static s32 dpot_write_i2c(struct dpot_data *dpot, u8 reg, u16 value)
 	case DPOT_UID(AD5246_ID):
 	case DPOT_UID(AD5247_ID):
 		return dpot_write_d8(dpot, value);
-		break;
 
 	case DPOT_UID(AD5245_ID):
 	case DPOT_UID(AD5241_ID):
@@ -346,7 +345,6 @@ static s32 dpot_write_i2c(struct dpot_data *dpot, u8 reg, u16 value)
 		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
 			0 : DPOT_AD5282_RDAC_AB;
 		return dpot_write_r8d8(dpot, ctrl, value);
-		break;
 	case DPOT_UID(AD5171_ID):
 	case DPOT_UID(AD5273_ID):
 		if (reg & DPOT_ADDR_OTP) {
@@ -356,7 +354,6 @@ static s32 dpot_write_i2c(struct dpot_data *dpot, u8 reg, u16 value)
 			ctrl = DPOT_AD5273_FUSE;
 		}
 		return dpot_write_r8d8(dpot, ctrl, value);
-		break;
 	case DPOT_UID(AD5172_ID):
 	case DPOT_UID(AD5173_ID):
 		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
@@ -368,7 +365,6 @@ static s32 dpot_write_i2c(struct dpot_data *dpot, u8 reg, u16 value)
 			ctrl |= DPOT_AD5170_2_3_FUSE;
 		}
 		return dpot_write_r8d8(dpot, ctrl, value);
-		break;
 	case DPOT_UID(AD5170_ID):
 		if (reg & DPOT_ADDR_OTP) {
 			tmp = dpot_read_r8d16(dpot, tmp);
@@ -377,7 +373,6 @@ static s32 dpot_write_i2c(struct dpot_data *dpot, u8 reg, u16 value)
 			ctrl = DPOT_AD5170_2_3_FUSE;
 		}
 		return dpot_write_r8d8(dpot, ctrl, value);
-		break;
 	case DPOT_UID(AD5272_ID):
 	case DPOT_UID(AD5274_ID):
 		dpot_write_r8d8(dpot, DPOT_AD5270_1_2_4_CTRLREG << 2,
@@ -392,7 +387,6 @@ static s32 dpot_write_i2c(struct dpot_data *dpot, u8 reg, u16 value)
 
 		return dpot_write_r8d8(dpot, (DPOT_AD5270_1_2_4_RDAC << 2) |
 				       (value >> 8), value & 0xFF);
-		break;
 	default:
 		if (reg & DPOT_ADDR_CMD)
 			return dpot_write_d8(dpot, reg);
-- 
1.7.9.5

