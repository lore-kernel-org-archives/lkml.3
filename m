Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbbA0Wdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:33:40 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42777
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933060AbbA0Wdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:33:35 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com, tglx@linutronix.de
Cc: Vitaly Kuznetsov 
	<"[mailto:vkuznets@redhat.com]"@linuxonhyperv.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 7/8] clockevents: export clockevents_unbind_device instead of clockevents_unbind
Date: Tue, 27 Jan 2015 15:46:47 -0800
Message-Id: <1422402408-5504-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1422402408-5504-1-git-send-email-kys@microsoft.com>
References: <1422402376-5463-1-git-send-email-kys@microsoft.com>
 <1422402408-5504-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuznetsov <[mailto:vkuznets@redhat.com]>

It looks like clockevents_unbind is being exported by mistake as:
- it is static;
- it is not listed in include/linux/clockchips.h;
- EXPORT_SYMBOL_GPL(clockevents_unbind) follows clockevents_unbind_device()
  implementation.

I think clockevents_unbind_device should be exported instead. This is going to
be used to teardown Hyper-V clockevent devices on module unload.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 kernel/time/clockevents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.4.1

