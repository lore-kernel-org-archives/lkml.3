Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbaCKUvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:51:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38601 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaCKUvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:51:51 -0400
Message-ID: <531F7765.40207@codeaurora.org>
Date: Tue, 11 Mar 2014 13:51:49 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: Silence sparse warning
References: <1393981281-25553-1-git-send-email-sboyd@codeaurora.org> <alpine.LNX.2.00.1403101407440.3690@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1403101407440.3690@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/14 06:08, Jiri Kosina wrote:
> On Tue, 4 Mar 2014, Stephen Boyd wrote:
>
>> drivers/irqchip/irqchip.c:27:13: warning: symbol 'irqchip_init'
>> was not declared. Should it be static?
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Why do we have to have drivers/irqchip/irqchip.h and 
> include/linux/irqchip.h anyway?

include/linux/irqchip.h is for irqchip_init() which is typically called
from arch layers. drivers/irqchip/irqchip.h is for irqchip drivers to
include so they can use the IRQCHIP_DECLARE macro. Perhaps you're
pointing out that the "irqchip.h" include in irqchip.c is unused? How
about this patch?

----8<----

From: Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH] irqchip: Remove unused include

The "irqchip.h" include here is not needed as the only thing in
irqchip.h is IRQCHIP_DECLARE which this file doesn't use. Drop
it.

Reported-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/irqchip/irqchip.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/irqchip/irqchip.c b/drivers/irqchip/irqchip.c
index 3469141f10f6..cad3e2495552 100644
--- a/drivers/irqchip/irqchip.c
+++ b/drivers/irqchip/irqchip.c
@@ -12,8 +12,6 @@
 #include <linux/of_irq.h>
 #include <linux/irqchip.h>
 
-#include "irqchip.h"
-
 /*
  * This special of_device_id is the sentinel at the end of the
  * of_device_id[] array of all irqchips. It is automatically placed at


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

