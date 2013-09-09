Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab3IIJHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 05:07:13 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:38592 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3IIJHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 05:07:12 -0400
Date: Mon, 9 Sep 2013 10:07:08 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        ldewangan@nvidia.com, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] mfd: tps6586x: implement irq_set_wake
Message-ID: <20130909090708.GE22938@lee--X1>
References: <1378509433-26404-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378509433-26404-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Sep 2013, Stephen Warren wrote:

> From: Stephen Warren <swarren@nvidia.com>
> 
> rtc-tps6586x calls enable/disable_irq_wake() during suspend/resume. Since
> the main tps6586x irq_chip doesn't implement .irq_set_wake, this causes
> the RTC's enable_irq_wake() to fail, and the disable_irq_wake() to spew a
> WARN about unbalanced wake disable. Solve this by implementing
> .irq_set_wake.
> 
> Also, I assume that enable_irq_wake() shouldn't be called unconditionally
> in tps6586x_irq_init(), since this is now triggered by IRQ children
> setting up their cascaded IRQs for wake. So, remove that.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> I'm tempted to Cc stable here, since this bug is certainly present in
> older kernel releases. However, the only user-visible aspect is the WARN
> on resume, so I'm not sure if it's worth it?

Can't do any harm?

> ---
>  drivers/mfd/tps6586x.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)

Patch applied.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
