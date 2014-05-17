Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbaEQAqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 20:46:55 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40655 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbaEQAqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 20:46:53 -0400
From: "Son P. Nguyen" <fastmutex@gmail.com>
To: w.d.hubbs@gmail.com
Cc: chris@the-brannons.com, kirk@reisers.ca, samuel.thibault@ens-lyon.org,
        gregkh@linuxfoundation.org, speakup@braille.uwo.ca,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Son P. Nguyen" <fastmutex@gmail.com>
Subject: [PATCH] Staging: speakup: fixed reporting_keystroke variable type
Date: Sat, 17 May 2014 00:46:43 +0000
Message-Id: <1400287603-9362-1-git-send-email-fastmutex@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Son P. Nguyen" <fastmutex@gmail.com>

Fixed reporting_keystroke type to int instead of bool to quiet sparse
complaints of error cannot size expression.

This is a part of eudyptula-challenge.

Signed-off-by: Son P. Nguyen <fastmutex@gmail.com>
---
 drivers/staging/speakup/fakekey.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/speakup/fakekey.c b/drivers/staging/speakup/fakekey.c
index 4299cf4..44ebb36 100644
--- a/drivers/staging/speakup/fakekey.c
+++ b/drivers/staging/speakup/fakekey.c
@@ -28,7 +28,7 @@
 #define PRESSED 1
 #define RELEASED 0
 
-static DEFINE_PER_CPU(bool, reporting_keystroke);
+static DEFINE_PER_CPU(int, reporting_keystroke);
 
 static struct input_dev *virt_keyboard;
 
@@ -78,10 +78,10 @@ void speakup_fake_down_arrow(void)
 	/* don't change CPU */
 	preempt_disable();
 
-	__this_cpu_write(reporting_keystroke, true);
+	__this_cpu_write(reporting_keystroke, 1);
 	input_report_key(virt_keyboard, KEY_DOWN, PRESSED);
 	input_report_key(virt_keyboard, KEY_DOWN, RELEASED);
-	__this_cpu_write(reporting_keystroke, false);
+	__this_cpu_write(reporting_keystroke, 0);
 
 	/* reenable preemption */
 	preempt_enable();
-- 
1.8.1.2

