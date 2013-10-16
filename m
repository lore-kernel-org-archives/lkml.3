Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762033Ab3JPR7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:59:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934571Ab3JPRqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@iguana.be>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 20/50] watchdog: kempld_wdt: Fix bit mask definition
Date: Wed, 16 Oct 2013 10:45:06 -0700
Message-Id: <20131016174400.814000376@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingoo Han <jg1.han@samsung.com>

commit 4c4e45669de475573b15d968a6dca8d00124c9ad upstream.

STAGE_CFG bits are defined as [5:4] bits. However, '(((x) & 0x30) << 4)'
handles [9:8] bits. Thus, it should be fixed in order to handle
[5:4] bits.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/kempld_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/kempld_wdt.c
+++ b/drivers/watchdog/kempld_wdt.c
@@ -35,7 +35,7 @@
 #define KEMPLD_WDT_STAGE_TIMEOUT(x)	(0x1b + (x) * 4)
 #define KEMPLD_WDT_STAGE_CFG(x)		(0x18 + (x))
 #define STAGE_CFG_GET_PRESCALER(x)	(((x) & 0x30) >> 4)
-#define STAGE_CFG_SET_PRESCALER(x)	(((x) & 0x30) << 4)
+#define STAGE_CFG_SET_PRESCALER(x)	(((x) & 0x3) << 4)
 #define STAGE_CFG_PRESCALER_MASK	0x30
 #define STAGE_CFG_ACTION_MASK		0x7
 #define STAGE_CFG_ASSERT		(1 << 3)


