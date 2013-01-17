Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306Ab3AQBuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:50:00 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33980 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab3AQBt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:49:59 -0500
Message-ID: <1358387389.17958.1.camel@phoenix>
Subject: [PATCH] rtc: hid-sensor-time: Add missing spin_lock_init
From: Axel Lin <axel.lin@ingics.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexander Holler <holler@ahsoftware.de>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2013 09:49:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/rtc/rtc-hid-sensor-time.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
index 0438c9e..31c5728 100644
--- a/drivers/rtc/rtc-hid-sensor-time.c
+++ b/drivers/rtc/rtc-hid-sensor-time.c
@@ -225,6 +225,7 @@ static int hid_time_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, time_state);
 
+	spin_lock_init(&time_state->lock_last_time);
 	init_completion(&time_state->comp_last_time);
 	time_state->common_attributes.hsdev = hsdev;
 	time_state->common_attributes.pdev = pdev;
-- 
1.7.9.5



