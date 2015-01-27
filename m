Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbbA0Qou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:44:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbbA0Qon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:44:43 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v2 4/5] clockevents: export clockevents_unbind_device instead of clockevents_unbind
Date: Tue, 27 Jan 2015 17:44:18 +0100
Message-Id: <1422377059-7858-5-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1422377059-7858-1-git-send-email-vkuznets@redhat.com>
References: <1422377059-7858-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like clockevents_unbind is being exported by mistake as:
- it is static;
- it is not listed in include/linux/clockchips.h;
- EXPORT_SYMBOL_GPL(clockevents_unbind) follows clockevents_unbind_device()
  implementation.

I think clockevents_unbind_device should be exported instead. This is going to
be used to teardown Hyper-V clockevent devices on module unload.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 kernel/time/clockevents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 5544990..888ecc1 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -371,7 +371,7 @@ int clockevents_unbind_device(struct clock_event_device *ced, int cpu)
 	mutex_unlock(&clockevents_mutex);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(clockevents_unbind);
+EXPORT_SYMBOL_GPL(clockevents_unbind_device);
 
 /**
  * clockevents_register_device - register a clock event device
-- 
1.9.3

