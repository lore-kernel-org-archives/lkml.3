Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308AbaAFXI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:08:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933117AbaAFWlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dinh Nguyen <dinguyen@altera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 3.10 091/129] clocksource: dw_apb_timer_of: Fix read_sched_clock
Date: Mon,  6 Jan 2014 14:38:40 -0800
Message-Id: <20140106223902.207957203@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinh Nguyen <dinguyen@altera.com>

commit 85dc6ee1237c8a4a7742e6abab96a20389b7d682 upstream.

The read_sched_clock should return the ~value because the clock is a
countdown implementation. read_sched_clock() should be the same as
 __apbt_read_clocksource().

Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clocksource/dw_apb_timer_of.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -77,7 +77,7 @@ static void __iomem *sched_io_base;
 
 static u32 read_sched_clock(void)
 {
-	return __raw_readl(sched_io_base);
+	return ~__raw_readl(sched_io_base);
 }
 
 static const struct of_device_id sptimer_ids[] __initconst = {


