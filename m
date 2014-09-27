Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaI0VLt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 17:11:49 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:44861 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaI0VLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 17:11:47 -0400
From: Nicholas Krause <yocto6@gmail.com>
To: IvDoorn@gmail.com
Cc: helmut.schaa@googlemail.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: Remove unnessary write over of register 11 in rt2800lib.c
Date: Sat, 27 Sep 2014 17:11:41 -0400
Message-Id: <1411852301-26857-1-git-send-email-yocto6@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the unnecessary  overwrite of register 11 in the function,
rt2800_config_channel as we are already writing a correct value to the
register with rt2800_rfcsr_write(rt2x00dev,11.rfcsr).

Signed-off-by: Nicholas Krause <yocto6@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 893c9d5..fb0ae38 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2787,8 +2787,6 @@ static void rt2800_config_channel_rf55xx(struct rt2x00_dev *rt2x00dev,
 
 	if (rf->channel <= 14) {
 		rt2800_rfcsr_write(rt2x00dev, 10, 0x90);
-		/* FIXME: RF11 owerwrite ? */
-		rt2800_rfcsr_write(rt2x00dev, 11, 0x4A);
 		rt2800_rfcsr_write(rt2x00dev, 12, 0x52);
 		rt2800_rfcsr_write(rt2x00dev, 13, 0x42);
 		rt2800_rfcsr_write(rt2x00dev, 22, 0x40);
-- 
1.9.1

