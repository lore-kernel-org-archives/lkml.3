Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab3HMQ2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:28:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542Ab3HMQ07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:59 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=g0Pw5I3W5McA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=MO9z1FgTUloA:10 a=cm27Pg_UAAAA:8 a=VwQbUJbxAAAA:8 a=RgBw9RmQAAAA:8 a=JfrnYn6hAAAA:8 a=NPcXljDpAAAA:8 a=Gm9_gKILpQXdQ6L73H0A:9 a=zv9_9hqRWm8A:10 a=3Rfx1nUSh_UA:10 a=FW2zQvlL1bsA:10 a=jeBq3FmKZ4MA:10 a=ieMl4yFhspLFiLkg:21 a=VhKHoak1iWRPEP3M:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155832.337008076@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>
Subject: [55/88] charger-manager: Ensure event is not used as format string
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0055-charger-manager-Ensure-event-is-not-used-as-format-s.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 3594f4c0d7bc51e3a7e6d73c44e368ae079e42f3 ]

The exposed interface for cm_notify_event() could result in the event msg
string being parsed as a format string. Make sure it is only used as a
literal string.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Anton Vorontsov <anton@enomsg.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/power/charger-manager.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 526e5c9..25b1fea 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -368,7 +368,7 @@ static void uevent_notify(struct charger_manager *cm, const char *event)
 	strncpy(env_str, event, UEVENT_BUF_SIZE);
 	kobject_uevent(&cm->dev->kobj, KOBJ_CHANGE);
 
-	dev_info(cm->dev, event);
+	dev_info(cm->dev, "%s", event);
 }
 
 /**
-- 
1.7.10.4


