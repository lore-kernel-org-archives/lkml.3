Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3CBHbI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 02:31:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50695 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422Ab3CBHbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 02:31:05 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: twl4030-audio: Fix argument type for twl4030_audio_disable_resource()
Date: Sat,  2 Mar 2013 15:30:35 +0800
Message-Id: <1362209435-11029-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the conversion to enum was missed for the definition of this
function, the declaration has been updated.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/twl4030-audio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl4030-audio.c b/drivers/mfd/twl4030-audio.c
index e16edca..d2ab222 100644
--- a/drivers/mfd/twl4030-audio.c
+++ b/drivers/mfd/twl4030-audio.c
@@ -118,7 +118,7 @@ EXPORT_SYMBOL_GPL(twl4030_audio_enable_resource);
  * Disable the resource.
  * The function returns with error or the content of the register
  */
-int twl4030_audio_disable_resource(unsigned id)
+int twl4030_audio_disable_resource(enum twl4030_audio_res id)
 {
 	struct twl4030_audio *audio = platform_get_drvdata(twl4030_audio_dev);
 	int val;
-- 
1.7.10.4

