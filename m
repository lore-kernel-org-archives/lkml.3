Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3CEWSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:18:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab3CEWQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:16:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3/9] mfd: remove __exit_p annotation for twl4030_madc_remove
Date: Tue,  5 Mar 2013 23:16:43 +0100
Message-Id: <1362521809-22989-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362521809-22989-1-git-send-email-arnd@arndb.de>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:QK8rzCQUZvM+0LnwyaHqRCbcH0x7Lxr7GoAhMyJ3w2Y
 tcgq/GZ1avVT1f9xBi3GOy1sOyo4YrHVUpIqfddk7NhZrw1v1t
 QKDpczvCcZ2zddF72jZRV+6CVJkD2ZwOuCik03ti+XnycADcfH
 0IGPU4DgASCJCb2sXI+KeVZerIrYjYUvZ8xuVLuKLcGFE3C8TY
 AN9BIAvH/9n0uLAjxhEX5oJAIrHXTCoAKsbw/9u12WSa+T9knG
 /ps+Y0hxxsVuMAPmV0NpqyjqtG1O4wcOv6Ob+i9hLxeX1Oon25
 tFa2mwPdHD0vgWB1uSyEznph2lU9OWFfD1tN5oNMvxT6jhgFRv
 /CCFvviPicJSHk3YTJQJeWgU++qWKUrgxABkQ44hW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

4740f73fe5 "mfd: remove use of __devexit" removed the __devexit annotation
on the twl4030_madc_remove function, but left an __exit_p() present on the
pointer to this function. Using __exit_p was as wrong with the devexit in
place as it is now, but now we get a gcc warning about an unused function.

In order for the twl4030_madc_remove to work correctly in built-in code, we
have to remove the __exit_p.

Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/mfd/twl4030-madc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 88ff9dc..942b666 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -800,7 +800,7 @@ static int twl4030_madc_remove(struct platform_device *pdev)
 
 static struct platform_driver twl4030_madc_driver = {
 	.probe = twl4030_madc_probe,
-	.remove = __exit_p(twl4030_madc_remove),
+	.remove = twl4030_madc_remove,
 	.driver = {
 		   .name = "twl4030_madc",
 		   .owner = THIS_MODULE,
-- 
1.8.1.2

