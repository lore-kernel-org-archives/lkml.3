Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158Ab3GKO1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:27:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43322 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933144Ab3GKO1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:27:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 97/98] charger-manager: Ensure event is not used as format string
Date: Thu, 11 Jul 2013 15:25:07 +0100
Message-Id: <1373552708-15235-98-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 3594f4c0d7bc51e3a7e6d73c44e368ae079e42f3 upstream.

The exposed interface for cm_notify_event() could result in the event msg
string being parsed as a format string. Make sure it is only used as a
literal string.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Anton Vorontsov <anton@enomsg.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/power/charger-manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 86935ec..d101f91 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -371,7 +371,7 @@ static void uevent_notify(struct charger_manager *cm, const char *event)
 	strncpy(env_str, event, UEVENT_BUF_SIZE);
 	kobject_uevent(&cm->dev->kobj, KOBJ_CHANGE);
 
-	dev_info(cm->dev, event);
+	dev_info(cm->dev, "%s", event);
 }
 
 /**
-- 
1.8.1.2

