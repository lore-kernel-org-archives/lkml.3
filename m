Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab3J2DvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 23:51:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36682 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758073Ab3J2DvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 23:51:03 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] pinctrl: remove minor dead code
Date: Tue, 29 Oct 2013 04:50:45 +0100
Message-Id: <1383018645-10019-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes a test whether the 'desc' variable is NULL.
This possibility has already been eliminated by the
below test earlier in the loop:

                if (desc == NULL) {
                        dev_warn(pctldev->dev,
                                 "could not get pin desc for pin %d\n",
                                 pins[i]);
                        continue;
                }

Found with Coverity: CID #1090078

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/pinctrl/pinmux.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 9d144a2..9248ce4 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -505,16 +505,14 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
 			pin_free(pctldev, pins[i], NULL);
 		} else {
 			const char *gname;
-			const char *pname;
 
-			pname = desc ? desc->name : "non-existing";
 			gname = pctlops->get_group_name(pctldev,
 						setting->data.mux.group);
 			dev_warn(pctldev->dev,
 				 "not freeing pin %d (%s) as part of "
 				 "deactivating group %s - it is already "
 				 "used for some other setting",
-				 pins[i], pname, gname);
+				 pins[i], desc->name, gname);
 		}
 	}
 
-- 
1.8.1.2

