Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3FGWRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 18:17:21 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:38700 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab3FGWRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 18:17:20 -0400
Message-ID: <51B25BEC.5050003@linaro.org>
Date: Sat, 08 Jun 2013 00:17:16 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC] add a WARN in setup_irq function for the IRQF_DISABLED flag
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

we are still seeing drivers with the irq flag IRQF_DISABLED present and
*new* drivers submitted with this flag set.

I am wondering if we can add a WARN in the setup_irq function about this
flag. May be it is a bit rough but people will pay attention.

Thanks

  -- Daniel

Index: clockevents/kernel/irq/manage.c
===================================================================
--- clockevents.orig/kernel/irq/manage.c        2013-06-05
23:57:22.723446115 +0200
+++ clockevents/kernel/irq/manage.c     2013-06-08 00:12:19.985035465 +0200
@@ -1212,6 +1212,9 @@ int setup_irq(unsigned int irq, struct i

        if (WARN_ON(irq_settings_is_per_cpu_devid(desc)))
                return -EINVAL;
+
+       WARN(act->flags & IRQF_DISABLED, "IRQF_DISABLED flag is disabled");
+
        chip_bus_lock(desc);
        retval = __setup_irq(irq, desc, act);
        chip_bus_sync_unlock(desc);

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

