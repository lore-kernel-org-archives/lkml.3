Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934281Ab3CZIpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 04:45:44 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:62188 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934170Ab3CZIpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 04:45:41 -0400
Message-ID: <1364287538.1390.315.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Fix printk typo "CONFIG_LED_CLASS"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 09:45:38 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2013 08:45:38.0984 (UTC) FILETIME=[4A920A80:01CE29FE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested again.

1) A better fix might be to not mention a Kconfig macro at all. Because
future Kconfig reshuffles might make this warning incorrect again. And
it can already be incorrect, as the actual configuration problem seems
to be: "LEDS_CLASS and RADIO_SHARK do not match". But that is not my
call.

 drivers/media/radio/radio-shark.c  | 2 +-
 drivers/media/radio/radio-shark2.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index 8c309c7..8fa18ab 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -284,7 +284,7 @@ static void shark_resume_leds(struct shark_device *shark)
 static int shark_register_leds(struct shark_device *shark, struct device *dev)
 {
 	v4l2_warn(&shark->v4l2_dev,
-		  "CONFIG_LED_CLASS not enabled, LED support disabled\n");
+		  "CONFIG_LEDS_CLASS not enabled, LED support disabled\n");
 	return 0;
 }
 static inline void shark_unregister_leds(struct shark_device *shark) { }
diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index ef65ebb..9fb6697 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -250,7 +250,7 @@ static void shark_resume_leds(struct shark_device *shark)
 static int shark_register_leds(struct shark_device *shark, struct device *dev)
 {
 	v4l2_warn(&shark->v4l2_dev,
-		  "CONFIG_LED_CLASS not enabled, LED support disabled\n");
+		  "CONFIG_LEDS_CLASS not enabled, LED support disabled\n");
 	return 0;
 }
 static inline void shark_unregister_leds(struct shark_device *shark) { }
-- 
1.7.11.7

