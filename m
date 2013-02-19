Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab3BSNAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:00:45 -0500
Received: from smtp-out-114.synserver.de ([212.40.185.114]:1322 "EHLO
	smtp-out-114.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab3BSNAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:00:44 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22104
From: Lars-Peter Clausen <lars@metafoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Michael Hennerich <michael.hennerich@analog.com>,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] backlight: adp8860/adp8870: Fix resume
Date: Tue, 19 Feb 2013 14:02:05 +0100
Message-Id: <1361278925-11107-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clearing the NSTBY bit in the control register also automatically clears the
BLEN bit. So we need to make sure to set it again during resume, otherwise the
backlight will stay off.

Cc: stable@vger.kernel.org
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/video/backlight/adp8860_bl.c | 2 +-
 drivers/video/backlight/adp8870_bl.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index 6bb72c0..a77c9ca 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -783,7 +783,7 @@ static int adp8860_i2c_suspend(struct i2c_client *client, pm_message_t message)
 
 static int adp8860_i2c_resume(struct i2c_client *client)
 {
-	adp8860_set_bits(client, ADP8860_MDCR, NSTBY);
+	adp8860_set_bits(client, ADP8860_MDCR, NSTBY | BLEN);
 
 	return 0;
 }
diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
index 63c882b..712c25a 100644
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -957,7 +957,7 @@ static int adp8870_i2c_suspend(struct i2c_client *client, pm_message_t message)
 
 static int adp8870_i2c_resume(struct i2c_client *client)
 {
-	adp8870_set_bits(client, ADP8870_MDCR, NSTBY);
+	adp8870_set_bits(client, ADP8870_MDCR, NSTBY | BLEN);
 
 	return 0;
 }
-- 
1.8.0

