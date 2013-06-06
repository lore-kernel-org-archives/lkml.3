Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab3FFUxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:53:32 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34767 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab3FFUx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:53:27 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Karsten Keil <isdn@linux-pingi.de>, Kees Cook <keescook@chromium.org>,
        stable@vger.kernel.org
Subject: [PATCH 4/8] power: ensure event is not used as format string
Date: Thu,  6 Jun 2013 13:52:21 -0700
Message-Id: <1370551945-8444-5-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370551945-8444-1-git-send-email-keescook@chromium.org>
References: <1370551945-8444-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exposed interface for cm_notify_event() could result in the event
msg string being parsed as a format string. Make sure it is only used
as a literal string.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/charger-manager.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index fefc39f..98de1dd 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -450,7 +450,7 @@ static void uevent_notify(struct charger_manager *cm, const char *event)
 	strncpy(env_str, event, UEVENT_BUF_SIZE);
 	kobject_uevent(&cm->dev->kobj, KOBJ_CHANGE);
 
-	dev_info(cm->dev, event);
+	dev_info(cm->dev, "%s", event);
 }
 
 /**
-- 
1.7.9.5

