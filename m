Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab3IJXdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:33:10 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:53522 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3IJXdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:33:07 -0400
From: Ryan Mallon <rmallon@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: carl@ok-labs.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ryan Mallon <rmallon@gmail.com>
Subject: [PATCH 2/2] uinput: Use input_inject_event in uinput_inject_event
Date: Wed, 11 Sep 2013 09:32:53 +1000
Message-Id: <1378855973-11595-2-git-send-email-rmallon@gmail.com>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1378855973-11595-1-git-send-email-rmallon@gmail.com>
References: <1378855973-11595-1-git-send-email-rmallon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call input_inject_event rather than input_event in uinput_inject_event. This
mirrors the behaviour of evdev_write. input_inject_event will ignore the
injected event if the uinput input device has been grabbed for exclusive
access by a handler other than uinput.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---
 drivers/input/misc/uinput.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 6aea346..0962ecb 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -443,7 +443,7 @@ static ssize_t uinput_inject_event(struct uinput_device *udev,
 		if (input_event_from_user(buffer + bytes, &ev))
 			return -EFAULT;
 
-		input_event(udev->dev, ev.type, ev.code, ev.value);
+		input_inject_event(udev->dev, ev.type, ev.code, ev.value);
 		bytes += input_event_size();
 	}
 
-- 
1.7.9.7

