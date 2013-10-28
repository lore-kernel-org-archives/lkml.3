Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab3J1MQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:16:15 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:36660 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab3J1MQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:16:12 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [media] radio-shark: Mark shark_resume_leds() inline to kill compiler warning
Date: Mon, 28 Oct 2013 13:16:05 +0100
Message-Id: <1382962565-1662-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If SHARK_USE_LEDS=1, but CONFIG_PM=n:

drivers/media/radio/radio-shark.c:275: warning: ‘shark_resume_leds’ defined but not used

Instead of making the #ifdef logic even more complicated (there are already
two definitions of shark_resume_leds()), mark shark_resume_leds() inline to
kill the compiler warning. shark_resume_leds() is small and it has only one
caller.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
{cris,m68k,parisc,sparc,xtensa}-all{mod,yes}config

 drivers/media/radio/radio-shark.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index b91477212413..050b3bb96fec 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -271,7 +271,7 @@ static void shark_unregister_leds(struct shark_device *shark)
 	cancel_work_sync(&shark->led_work);
 }
 
-static void shark_resume_leds(struct shark_device *shark)
+static inline void shark_resume_leds(struct shark_device *shark)
 {
 	if (test_bit(BLUE_IS_PULSE, &shark->brightness_new))
 		set_bit(BLUE_PULSE_LED, &shark->brightness_new);
-- 
1.7.9.5

