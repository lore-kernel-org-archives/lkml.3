Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab3GKWOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:14:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700Ab3GKWLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:11:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>
Subject: [ 03/11] charger-manager: Ensure event is not used as format string
Date: Thu, 11 Jul 2013 15:11:03 -0700
Message-Id: <20130711220545.981905096@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711220545.542911892@linuxfoundation.org>
References: <20130711220545.542911892@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/charger-manager.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -330,7 +330,7 @@ static void uevent_notify(struct charger
 	strncpy(env_str, event, UEVENT_BUF_SIZE);
 	kobject_uevent(&cm->dev->kobj, KOBJ_CHANGE);
 
-	dev_info(cm->dev, event);
+	dev_info(cm->dev, "%s", event);
 }
 
 /**


