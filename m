Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbaFWUaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:30:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbaFWUaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:30:20 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] Input - wacom: assign phys field from struct wacom into input_dev
Date: Mon, 23 Jun 2014 16:30:15 -0400
Message-Id: <1403555415-547-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This field was not used for 9 years, it is time to assign it.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
Hi Dmitry,

this is the v2 (more a re-spin) of the patch entitled:
"Input - wacom: remove phys field in struct wacom".

Cheers,
Benjamin

 drivers/input/tablet/wacom_sys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index afa4e8d..f03f25b 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -1133,6 +1133,7 @@ static int wacom_register_input(struct wacom *wacom)
 	}
 
 	input_dev->name = wacom_wac->name;
+	input_dev->phys = wacom->phys;
 	input_dev->dev.parent = &intf->dev;
 	input_dev->open = wacom_open;
 	input_dev->close = wacom_close;
-- 
1.9.3

