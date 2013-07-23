Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934812Ab3GWWnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:43:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934665Ab3GWW1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [ 054/103] clocksource: dw_apb: Fix error check
Date: Tue, 23 Jul 2013 15:26:05 -0700
Message-Id: <20130723220424.596626997@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baruch Siach <baruch@tkos.co.il>

commit 1a33bd2be705cbb3f57d7223b60baea441039307 upstream.

irq_of_parse_and_map() returns 0 on error, while the code checks for NO_IRQ.
This breaks on platforms that have NO_IRQ != 0.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clocksource/dw_apb_timer_of.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -44,7 +44,7 @@ static void add_clockevent(struct device
 	u32 irq, rate;
 
 	irq = irq_of_parse_and_map(event_timer, 0);
-	if (irq == NO_IRQ)
+	if (irq == 0)
 		panic("No IRQ for clock event timer");
 
 	timer_get_base_and_rate(event_timer, &iobase, &rate);


