Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965684Ab3GSF0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:26:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965630Ab3GSF0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Heiko Schocher <hs@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 31/72] drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq
Date: Thu, 18 Jul 2013 22:25:48 -0700
Message-Id: <20130719052601.998917151@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 29ecd78c0fd6ee05f2c6b07b23823a6ae43c13ff upstream.

In the disable AIE irq code path, current code passes "1" to enable
parameter of rv3029c2_rtc_i2c_alarm_set_irq().  Thus it does not disable
AIE irq.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Heiko Schocher <hs@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-rv3029c2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-rv3029c2.c
+++ b/drivers/rtc/rtc-rv3029c2.c
@@ -310,7 +310,7 @@ static int rv3029c2_rtc_i2c_set_alarm(st
 		dev_dbg(&client->dev, "alarm IRQ armed\n");
 	} else {
 		/* disable AIE irq */
-		ret = rv3029c2_rtc_i2c_alarm_set_irq(client, 1);
+		ret = rv3029c2_rtc_i2c_alarm_set_irq(client, 0);
 		if (ret)
 			return ret;
 


