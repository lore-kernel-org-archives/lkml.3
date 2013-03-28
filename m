Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3C1JbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 05:31:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:40032 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab3C1JbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 05:31:24 -0400
Date: Thu, 28 Mar 2013 10:31:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Turquette <mturquette@linaro.org>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        rajagopal.venkat@linaro.org, davidb@codeaurora.org,
        ulf.hansson@linaro.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/2] clk: abstract locking out into helper functions
In-Reply-To: <1364445958-2999-2-git-send-email-mturquette@linaro.org>
Message-ID: <alpine.LFD.2.02.1303281027170.22263@ionos>
References: <1364368183-24420-1-git-send-email-mturquette@linaro.org> <1364445958-2999-1-git-send-email-mturquette@linaro.org> <1364445958-2999-2-git-send-email-mturquette@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Mike Turquette wrote:

> Create locking helpers for the global mutex and global spinlock.  The
> definitions of these helpers will be expanded upon in the next patch
> which introduces reentrancy into the locking scheme.

This looks way better. Nitpick below.
 
> +static void clk_enable_lock(unsigned long *flags)
> +{
> +	spin_lock_irqsave(&enable_lock, *flags);
> +}

> +static void clk_enable_unlock(unsigned long *flags)

Please just hand in the flags, no need for indirection.

> +{
> +	spin_unlock_irqrestore(&enable_lock, *flags);
> +}
> +

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

