Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaKKLYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:24:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57767 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbaKKLLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Torsten Fleischer <to-fleischer@t-online.de>,
        Peter Chen <peter.chen@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 132/170] usb: chipidea: Fix oops when removing the ci_hdrc module
Date: Tue, 11 Nov 2014 11:08:11 +0000
Message-Id: <1415704129-12709-133-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Torsten Fleischer <to-fleischer@t-online.de>

commit 9680b60ed79edaf52f84b65cbb20859bbb26cb68 upstream.

The call of 'kfree(ci->hw_bank.regmap)' in ci_hdrc_remove() sometimes causes
a kernel oops when removing the ci_hdrc module.

Since there is no separate memory allocated for the ci->hw_bank.regmap array,
there is no need to free it.

Signed-off-by: Torsten Fleischer <to-fleischer@t-online.de>
Signed-off-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/chipidea/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 619d13e29995..4ecb6501a7ea 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -732,7 +732,6 @@ static int ci_hdrc_remove(struct platform_device *pdev)
 	ci_role_destroy(ci);
 	ci_hdrc_enter_lpm(ci, true);
 	usb_phy_shutdown(ci->transceiver);
-	kfree(ci->hw_bank.regmap);
 
 	return 0;
 }
-- 
2.1.0

