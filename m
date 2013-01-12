Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab3ALLuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 06:50:09 -0500
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:11241
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285Ab3ALLuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 06:50:07 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: John Stultz <john.stultz@linaro.org>, <arm@kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 1/3] clockevents: export clockevents_config_and_register for module use
Date: Sat, 12 Jan 2013 19:50:04 +0800
Message-ID: <1357991406-22778-2-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357991406-22778-1-git-send-email-shawn.guo@linaro.org>
References: <1357991406-22778-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clockevents_config_and_register is a handy helper for clockevent
drivers, some of which might support module build, so export the symbol.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clockevents.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 30b6de0..c6d6400 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -339,6 +339,7 @@ void clockevents_config_and_register(struct clock_event_device *dev,
 	clockevents_config(dev, freq);
 	clockevents_register_device(dev);
 }
+EXPORT_SYMBOL_GPL(clockevents_config_and_register);
 
 /**
  * clockevents_update_freq - Update frequency and reprogram a clock event device.
-- 
1.7.9.5


