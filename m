Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbbAEW25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:28:57 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:44304 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbbAEW2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:28:50 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        linux-kernel@vger.kernel.org, silverhammermba@gmail.com,
        peter.hutterer@who-t.net, hdegoede@redhat.com,
        benjamin.tissoires@gmail.com,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH v2 1/4] input: synaptics - fix pressure values calculation on image sensors
Date: Mon,  5 Jan 2015 23:28:32 +0100
Message-Id: <1420496915-31560-2-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420496915-31560-1-git-send-email-gabriele.mzt@gmail.com>
References: <1420496915-31560-1-git-send-email-gabriele.mzt@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pressure values retrieved from secondary packets was incorrectly
shifted, making them lower than what they actually were.
Since this only happened with secondary packets, the values reported
when only one finger was present on the touchpad were correct.

Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
---
 drivers/input/mouse/synaptics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index f89de89..4d22ebd 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -588,7 +588,7 @@ static void synaptics_parse_agm(const unsigned char buf[],
 		agm->w = hw->w;
 		agm->x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
 		agm->y = (((buf[4] & 0xf0) << 4) | buf[2]) << 1;
-		agm->z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
+		agm->z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 2;
 		break;
 
 	case 2:
-- 
2.1.4

