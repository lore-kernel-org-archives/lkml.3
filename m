Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3B1PHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:07:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42250 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3B1Osw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 074/139] drivers/video/backlight/adp88?0_bl.c: fix resume
Date: Thu, 28 Feb 2013 14:43:44 +0000
Message-Id: <1362062689-2567-75-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 5eb02c01bd1f3ef195989ab05e835e2b0711b5a9 upstream.

Clearing the NSTBY bit in the control register also automatically clears
the BLEN bit.  So we need to make sure to set it again during resume,
otherwise the backlight will stay off.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/backlight/adp8860_bl.c | 2 +-
 drivers/video/backlight/adp8870_bl.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index 77d1fdb..716daaa 100644
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
index edf7f91..f58a189 100644
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
1.8.1.2

