Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab3KVPdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:33:38 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:63805 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3KVPdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:33:37 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX195WXsiuGmaEJpD2A35dItF
Date: Fri, 22 Nov 2013 07:33:34 -0800
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, benoit.cousson@linaro.org,
        santosh.shilimkar@ti.com, jgchunter@gmail.com, rnayak@ti.com,
        balbi@ti.com
Subject: Re: [PATCH 1/8] ARM: OMAP: Move public portion of dmtimer.h to
 include/linux/omap-timer.h
Message-ID: <20131122153334.GE10023@atomide.com>
References: <1385085414-9034-1-git-send-email-joelf@ti.com>
 <1385085414-9034-2-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385085414-9034-2-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Joel Fernandes <joelf@ti.com> [131121 18:00]:
> Multiplatform support has made arch/arm/plat-omap/include/plat/ inaccessible to
> drivers outside the plat-omap directory [1]. Due to this the following drivers
> are disabled with !CONFIG_ARCH_MULTIPLATFORM:
> CONFIG_IR_RX51 (drivers/media/rc/ir-rx51.c)
> CONFIG_TIDSPBRIDGE (drivers/staging/tidspbridge/core/dsp-clock.c)
> 
> We move the portion of the dmtimer "API" that should be accessible to the
> drivers, into include/linux/omap-timer.h

As we chatted earlier, we don't have to expose all these hardware specific
functions and use existing Linux generic frameworks instead.

We can implement an irqchip and a clocksource in the dmtimer code for the
client drivers to use, and after that we only have a couple of dmtimer
specific functions left to export.

I'm thinkging some thing like this for the public API:

omap_dm_timer_request			request_irq
omap_dm_timer_request_specific		request_irq
omap_dm_timer_get_irq			request_irq
omap_dm_timer_set_source		clk_set_rate
omap_dm_timer_stop			disable_irq
omap_dm_timer_start			enable_irq
omap_dm_timer_disable			disable_irq
omap_dm_timer_free			free_irq
omap_dm_timer_set_int_enable		enable_irq

After that, what's left to export are some functions to configure
the hardware timer:

omap_dm_timer_write_counter
omap_dm_timer_set_match
omap_dm_timer_read_counter
omap_dm_timer_read_status
omap_dm_timer_write_status

And for those we can then eventually probably have some Linux generic
hardware timer API :)

Regards,

Tony
