Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbaGIT0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:26:36 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:34097 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaGIT0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:26:35 -0400
From: James A Shackleford <shack@linux.com>
To: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH] staging: rtl8712: remove wrapper function thread_enter()
Date: Wed,  9 Jul 2014 15:26:23 -0400
Message-Id: <1404933983-24234-1-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inline function thread_enter() accepts a single ignored parameter and is
just a wrapper for allow_signal(SIGTERM).  Removed.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/rtl8712/osdep_service.h | 5 -----
 drivers/staging/rtl8712/rtl8712_cmd.c   | 2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index c80f006..d7a357b 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -118,11 +118,6 @@ static inline unsigned char _cancel_timer_ex(struct timer_list *ptimer)
 	return del_timer(ptimer);
 }
 
-static inline void thread_enter(void *context)
-{
-	allow_signal(SIGTERM);
-}
-
 static inline void flush_signals_thread(void)
 {
 	if (signal_pending(current))
diff --git a/drivers/staging/rtl8712/rtl8712_cmd.c b/drivers/staging/rtl8712/rtl8712_cmd.c
index 6151977..ab0c7eb 100644
--- a/drivers/staging/rtl8712/rtl8712_cmd.c
+++ b/drivers/staging/rtl8712/rtl8712_cmd.c
@@ -326,7 +326,7 @@ int r8712_cmd_thread(void *context)
 	struct _adapter *padapter = (struct _adapter *)context;
 	struct	cmd_priv	*pcmdpriv = &(padapter->cmdpriv);
 
-	thread_enter(padapter);
+	allow_signal(SIGTERM);
 	while (1) {
 		if ((_down_sema(&(pcmdpriv->cmd_queue_sema))) == _FAIL)
 			break;
-- 
1.9.1

