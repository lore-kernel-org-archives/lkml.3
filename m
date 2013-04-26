Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3DZRDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 13:03:45 -0400
Received: from svenfoo.org ([82.94.215.22]:59573 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab3DZRDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 13:03:44 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Apr 2013 13:03:44 EDT
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, patrice.chotard@st.com,
        Daniel Mack <zonque@gmail.com>
Subject: [PATCH, for-next] pinctrl: fix mutex deadlock in get_pinctrl_dev_from_of_node()
Date: Fri, 26 Apr 2013 18:57:02 +0200
Message-Id: <1366995422-7135-1-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This obvious bug was introduced by d755910b7 ("pinctrl: move subsystem
mutex to pinctrl_dev struct").

Signed-off-by: Daniel Mack <zonque@gmail.com>
---
This applies on today's linux-next.

 drivers/pinctrl/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 37cd774..78eae4d 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -129,7 +129,7 @@ struct pinctrl_dev *get_pinctrl_dev_from_of_node(struct device_node *np)
 			return pctldev;
 		}
 
-	mutex_lock(&pinctrldev_list_mutex);
+	mutex_unlock(&pinctrldev_list_mutex);
 
 	return NULL;
 }
-- 
1.8.1.4

